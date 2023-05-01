<script>
import CalendarHeader from '@/Layouts/CalendarHeader.vue'
import SearchDialog from './CalendarSearchDialog.vue'
import MyColorSettingDialog from './MyColorSettingDialog.vue'
import EventSettingDialog from './EventSettingDialog.vue'
import DateTable from './DateTable.vue'
import axios from 'axios'
import VueDatePicker from '@vuepic/vue-datepicker'
import '@vuepic/vue-datepicker/dist/main.css'
import {circliful} from 'js-plugin-circliful'
import 'js-plugin-circliful/dist/main.css'

export default {
  props: {
    is_list: Boolean,
  },

  components: {
    CalendarHeader,
    SearchDialog,
    VueDatePicker,
    MyColorSettingDialog,
    EventSettingDialog,
    DateTable,
  },

  data() {
    return {
      year: null,
      month: null,
      day: null,
      cur_date: null,
      dates: ["日", "月", "火", "水", "木", "金", "土"],
      myColorQuery: [],

      active: {
        progressDialog: false,
        addDialog: false,
        editDialog: false,
        colorSettingDialog: false,
      },

      eventDialogData: {
        event_id: null,
        title: null,
        text: null,
        date_from: null,
        date_to: null,
        tag_id: null,
      },

      tagData: {
        event_id: null,
        title: null,
        text: null,
        date_from: null,
        date_to: null,
        tag_id: null,
      },

      myColorDialogData: {
        tag_id: null,
        tag_name: null,
        tag_note: null,
        tag_color: null,
      },
    }
  },

  methods: {
    eventConfirm(){
      axios.post(route('calendar.eventUpdate'), {
        event_id: this.eventDialogData.event_id,
        title: this.eventDialogData.title,
        text: this.eventDialogData.text,
        date_from: this.eventDialogData.date_from,
        date_to: this.eventDialogData.date_to,
        tag_id: this.eventDialogData.tag_id,
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then((response) => {
        this.active.addDialog = false
        this.active.editDialog = false

        this.$refs.date_table.getDateBoard(0)

      }).catch(function (error) {

      });
    },

    eventDelete(){
      axios.post(route('calendar.eventDelete'), {
        event_id: this.eventDialogData.event_id,
        title: this.eventDialogData.title,
        text: this.eventDialogData.text,
        date_from: this.eventDialogData.date_from,
        date_to: this.eventDialogData.date_to,
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then((response) => {
        this.active.editDialog = false
        this.$refs.date_table.getDateBoard(0)
      }).catch(function (error) {

      });
    },

    add(day) {
      this.eventDialogData = {
        event_id: null,
        title: null,
        text: null,
        date_from: this.year + '-' + (this.month+1) + '-' + day,
        date_to: null,
        tag_id: null,
        is_new: true,
      }

      this.active.editDialog = true
    },

    edit(event) {
      this.eventDialogData = {
        event_id: event.event_id,
        title: event.title,
        text: event.text,
        date_from: event.date_from,
        date_to: event.date_to,
        tag_color: event.tag_color,
        tag_id: event.tag_id,
        is_new: false,
      }

      this.active.editDialog = true
    },

    getMyColor(){
      axios.get(route('calendar.myColor'),{
      }, {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then((response) => {
        this.myColorQuery = response.data
      }).catch((error) => {
        this.active.progressDialog = false
        console.log(error)
      })
    },

    openMyColorSettingDialog(){
      this.myColorDialogData = {
        tag_id: null,
        tag_name: null,
        tag_note: null,
        tag_color: null,
      }

      this.active.colorSettingDialog = true
    },

    openSearchDialog(){
      this.$refs.dialogSearch.search_title = null
      this.$refs.dialogSearch.searchDialog = true
    },

    tagToggle(tag_id){
      Object.keys(this.$refs.date_table.eventQuery).forEach(key => {
        this.$refs.date_table.eventQuery[key].forEach(tag => {
          if(tag_id.includes(tag.tag_id)){
            tag.hidden = 0
          } else if(tag_id.length == 0){
            tag.hidden = 0
          } else {
            tag.hidden = 1
          }
        })
      })
    },

    myColorDelete(){
      axios.post(route('calendar.colorDelete'), {
        tag_id: this.myColorDialogData.tag_id,
        tag_name: this.myColorDialogData.tag_name,
        tag_note: this.myColorDialogData.tag_note,
        tag_color: this.myColorDialogData.tag_color,
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then((response) => {
        this.active.colorSettingDialog = false
        this.$refs.date_table.getDateBoard(0, true)
        this.getMyColor()
      }).catch(function (error) {
        console.log(error)
      })
    },

    myColorConfirm(){
      axios.post(route('calendar.colorUpdate'), {
        tag_id: this.myColorDialogData.tag_id,
        tag_name: this.myColorDialogData.tag_name,
        tag_note: this.myColorDialogData.tag_note,
        tag_color: this.myColorDialogData.tag_color,
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then((response) => {
        this.active.colorSettingDialog = false
        this.$refs.date_table.getDateBoard(0, true)
        this.getMyColor()
      }).catch(function (error) {
        console.log(error)
      })
    },
  },

  created() {
    let date = new Date()
    this.year = date.getFullYear()
    this.month = date.getMonth()
    this.cur_date = this.year + '年' + (this.month + 1) + '月' + date.getDate() + '日' + this.dates[date.getDay()] + '曜日'
    this.getMyColor()
  },
}
</script>

<template>
  <!-- ヘッダー -->
  <CalendarHeader
    :cur_date="cur_date"
    :year="year"
  ></CalendarHeader>

  <!-- 検索ダイアログ -->
  <SearchDialog
    ref="dialogSearch"
  ></SearchDialog>

  <div class="mt-8">
    <v-select
      v-model="tagData.tag_id"
      :items="this.myColorQuery"
      label="マイカラー"
      item-title="tag_name"
      item-value="tag_id"
      multiple
      @update:modelValue="tagToggle(tagData.tag_id)"
    >
    </v-select>
  </div>

  <!-- 日付テーブル -->
  <DateTable
    v-if="!is_list"
    :readonly = false
    ref="date_table"
    @add="add"
    @edit="edit"
  ></DateTable>
  <DateTable
    v-else
    :readonly = true
    ref="date_table"
  ></DateTable>

  <!-- ボタン -->
  <div
    class="flex my-3 py-5 px-5"
  >
    <div
      v-if="!is_list"
    >
      <button
        class="bg-emerald-500 font-semibold text-white py-4 px-4 mx-5 rounded"
        @click="openMyColorSettingDialog"
      >
        マイカラー設定
      </button>
    </div>
    <div
      v-if="is_list"
    >
      <button
        class="bg-emerald-500 font-semibold text-white py-4 px-4 mx-5 rounded"
        @click="openSearchDialog"
      >
        イベント検索
      </button>
    </div>
    <div>
      <template
        v-if="!is_list"
      >
        <inertia-link
          :href="route('calendar.list')"
        >
          <button
            class="bg-emerald-500 font-semibold text-white py-4 px-4 mx-5 rounded"
          >
            イベント一覧
          </button>
        </inertia-link>
      </template>
      <template
        v-else
      >
        <inertia-link
          :href="route('calendar.edit')"
        >
          <button
            class="bg-emerald-500 font-semibold text-white py-4 px-4 mx-5 rounded"
          >
            イベント編集
          </button>
        </inertia-link>
      </template>
    </div>
  </div>

  <!-- イベント設定ダイアログ -->
  <EventSettingDialog
    v-model:show="active.editDialog"
    v-model:data="eventDialogData"
    :colors="myColorQuery"
    @delete="eventDelete"
    @confirm="eventConfirm"
  ></EventSettingDialog>

  <!-- プログレスダイアログ -->
  <v-row justify="center">
    <v-dialog
      v-model="active.progressDialog"
    >
      <div class="text-center">
        <v-progress-circular
          indeterminate
          color="primary"
        ></v-progress-circular>
      </div>
    </v-dialog>
  </v-row>

  <!-- マイカラー設定ダイアログ -->
  <MyColorSettingDialog
    v-model:show="active.colorSettingDialog"
    v-model:data="myColorDialogData"
    :colors="myColorQuery"
    @colorDelete="myColorDelete"
    @colorConfirm="myColorConfirm"
  ></MyColorSettingDialog>
</template>
