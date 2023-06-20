<script>
import CalendarLayout from '@/Layouts/CalendarLayout.vue'
import SearchDialog from './CalendarSearchDialog.vue'
import MyColorSettingDialog from './MyColorSettingDialog.vue'
import EventSettingDialog from './EventSettingDialog.vue'
import DateTable from './DateTable.vue'
import axios from 'axios'
import VueDatePicker from '@vuepic/vue-datepicker'
import '@vuepic/vue-datepicker/dist/main.css'

export default {
  props: {
    is_list: Boolean,
    event_id: String,
  },

  components: {
    CalendarLayout,
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
        repeat_date: null,
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

      success: false,
      errors: false,
      eventDateFrom: null,
      errorMessages: null,
    }
  },

  methods: {
    eventConfirm(){
      this.success = false
      axios.post(route('calendar.eventUpdate'), {
        event_id: this.eventDialogData.event_id,
        title: this.eventDialogData.title,
        text: this.eventDialogData.text,
        date_from: this.eventDialogData.date_from,
        date_to: this.eventDialogData.date_to,
        tag_id: this.eventDialogData.tag_id,
        repeat_date: this.eventDialogData.repeat_date,
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then((response) => {
        this.active.addDialog = false
        this.active.editDialog = false
        this.$refs.date_table.getDateBoard(0)
        this.success = true
      }).catch((error) => {
        this.errorMessages = error.response.data
        this.active.editDialog = false
        this.active.addDialog = false
        this.errors = true
      });
    },

    eventDelete(){
      this.success = false
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
        this.success = true
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
        tag_name: event.tag_name,
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
      this.success = false
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
        this.success = true
      }).catch(function (error) {
        console.log(error)
      })
    },

    myColorConfirm(){
      this.success = false
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
        this.success = true
      }).catch((error) => {
        this.errorMessages = error.response.data
        this.active.colorSettingDialog = false
        this.errors = true
      })
    },

    eventDate(date) {
      this.eventDateFrom = date
    },
  },

  created() {
    let date = new Date()
    this.year = date.getFullYear()
    this.month = date.getMonth()
    this.getMyColor()
  },
}
</script>

<template>
  <!-- ヘッダー -->
  <CalendarLayout>
    <!-- 検索ダイアログ -->
    <SearchDialog
      ref="dialogSearch"
      @eventDateClick="eventDate"
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

    <!-- アラート -->
    <v-alert
      v-model="success"
      icon="$success"
      type="success"
      title="保存しました。"
      closable
      class="mt-0"
    ></v-alert>

    <v-alert
      v-model="errors"
      type="error"
      closable
      class="mt-0"
    >
      <div
        v-for="(errors, errors_idx) in errorMessages"
        :key="errors_idx"
      >
        <span
          v-for="(error, error_idx) in errors"
          :key="error_idx"
        >
          {{ error }}
        </span>
      </div>
    </v-alert>

    <!-- 日付テーブル -->
    <DateTable
      ref="date_table"
      @add="add"
      @edit="edit"
      :event_id="event_id"
      :eventDateFrom="eventDateFrom"
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
  </CalendarLayout>
</template>
