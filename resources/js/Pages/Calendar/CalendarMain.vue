<script>
import CalendarHeader from '@/Layouts/CalendarHeader.vue'
import SearchDialog from './CalendarSearchDialog.vue'
import MyColorSettingDialog from './MyColorSettingDialog.vue'
import EventSettingDialog from './EventSettingDialog.vue'
import axios from 'axios'
import VueDatePicker from '@vuepic/vue-datepicker'
import '@vuepic/vue-datepicker/dist/main.css'
import SvgIcon from '@jamescoyle/vue-icon'
import { mdiPlusCircle } from '@mdi/js'
import {circliful} from 'js-plugin-circliful'
import 'js-plugin-circliful/dist/main.css'

export default {
  props: {
    date_board_query: Array,
    is_list: Boolean,
  },

  components: {
    CalendarHeader,
    SearchDialog,
    VueDatePicker,
    SvgIcon,
    MyColorSettingDialog,
    EventSettingDialog,
  },

  data() {
    return {
      cur_date: null,
      year: null,
      month: null,
      day: null,
      dates: ["日", "月", "火", "水", "木", "金", "土"],
      date_board: [],

      query: [],
      myColorQuery: [],

      active: {
          progressDialog: false,
          plusDialog: false,
          eventDialog: false,
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

      path: mdiPlusCircle,
      //key: 0,
    }
  },

  methods: {
    getDateBoard(delta, not_refresh){
      this.active.progressDialog = true
      if(!not_refresh) {
        this.dateBoard(delta)
      }
      axios.get(route('calendar.dateBoard'),{
        params: {
            year: this.year,
            month: this.month+1,
        }
      }, {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then((response) => {
        this.active.progressDialog = false
        this.query = response.data
      }).catch((error) => {
        this.active.progressDialog = false
        console.log(error)
      })
    },

    dateBoard(delta){
      if(delta == -1){
        this.month -= 1
        if(this.month == -1){
          this.year -= 1
          this.month = 11
        }
      } else if(delta == 1){
        this.month += 1
        if(this.month == 12){
          this.year += 1
          this.month = 0
        }
      }
      let date_board = []
      let firstDay = new Date(this.year, this.month, 1).getDay()
      let lastDate = new Date(this.year, this.month + 1, 0).getDate()
      let day = 1
      for(let i=0; ; i++){
        date_board[i] = []
        if(i == 0){
          let h=0
          for(; h<firstDay; h++){
            date_board[i][h] = ''
          }
          for(; h<7; h++){
            date_board[i][h] = {
              day: day++,
            }
          }
        } else {
          for(let j=0; j<7; j++){
            date_board[i][j] = {
              day: day++,
            }
            if(day > lastDate){
              return this.date_board = date_board
            }
          }
        }
      }
    },

    openEventDialog(event){
      //   this.eventDialogData = event

      this.eventDialogData.event_id = event.event_id
      this.eventDialogData.title = event.title
      this.eventDialogData.text = event.text
      this.eventDialogData.date_from = event.date_from
      this.eventDialogData.date_to = event.date_to
      this.eventDialogData.tag_color = event.tag_color
      this.eventDialogData.tag_id = event.tag_id

      this.active.eventDialog = true
    },

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
        this.active.plusDialog = false
        this.active.eventDialog = false

        this.getDateBoard(0, true)

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
        this.active.eventDialog = false
        this.getDateBoard(0, true)

      }).catch(function (error) {

      });
    },

    openPlusDialog(day){
      this.eventDialogData = {
        event_id:null,
        title:null,
        text:null,
        date_from:this.year + '-' + (this.month+1) + '-' + day,
        date_to:null,
        tag_id:null,
        is_new:true,
      }
      this.active.eventDialog = true
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

    // myColorChange(event){
    //   this.myColorDialogData.tag_id = event.tag_id
    //   this.myColorDialogData.tag_name = event.tag_name
    //   this.myColorDialogData.tag_note = event.tag_note
    //   this.myColorDialogData.tag_color = event.tag_color
    // },

    openSearchDialog(){
      this.$refs.dialogSearch.search_title = null
      this.$refs.dialogSearch.searchDialog = true
    },

    tagToggle(tag_id){
      Object.keys(this.query).forEach(key => {
        this.query[key].forEach(element => {
          if(tag_id.includes(element.tag_id)){
            element.hidden = 0
          } else if(tag_id.length == 0){
            element.hidden = 0
          } else {
            element.hidden = 1
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

        this.getDateBoard(0, true)
        this.getMyColor()
      }).catch(function (error) {

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

        this.getDateBoard(0, true)
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

    this.getDateBoard(0)
    this.getMyColor()
  },
}
</script>

<template>
  <CalendarHeader
    :cur_date="cur_date"
    :year="year"
  ></CalendarHeader>

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
  <div
    class="flex text-center mb-7"
  >
    <div class="flex-grow"></div>
    <button
      class="bg-indigo-600 font-semibold text-white py-2 px-10 rounded shadow-lg shadow-indigo-500/50"
      @click="getDateBoard(-1)"
    >
      先月
    </button>
    <div class="flex-grow"></div>
    <div
      class="flex-grow text-5xl font-extrabold text-sky-500"
    >
      {{ month+1 }} 月
    </div>
    <div class="flex-grow"></div>
    <button
      class="bg-indigo-600 font-semibold text-white py-2 px-10 rounded shadow-lg shadow-indigo-500/50"
      @click="getDateBoard(1)"
    >
      来月
    </button>
    <div class="flex-grow"></div>
  </div>
  <div class="my-3">
    <table
      class="border-collapse border border-slate-500 w-full"
    >
      <thead>
        <tr>
          <template v-for="date in dates">
            <th
              class="border border-slate-600 h-8"
            >{{ date }}</th>
          </template>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="(week, w_idx) in date_board"
          :key="w_idx"
        >
          <td
            class="border border-slate-700 h-15 text-right pr-4 pb-10"
            style="vertical-align: top;"
            v-for="(day, d_idx) in week"
            :key="d_idx"
          >
            <template
              v-if="day.day"
            >
              <div
                class="flex"
              >
                <div
                  v-if="!is_list"
                >
                  <v-btn
                    color="green"
                    variant="text"
                    @click="openPlusDialog(day.day)"
                  ><svg-icon type="mdi" :path="path"></svg-icon>
                  </v-btn>
                </div>
                <div class="flex-grow"></div>
                <div
                  class="mt-1"
                >
                  {{ day.day }}
                </div>
              </div>
            </template>
            <template
              v-if="query[day.day]"
            >
              <div
                v-for="event in query[day.day]"
                :key="event.event_id"
                v-show="!event.hidden"
              >
                <template
                  v-if="is_list"
                >
                  <button
                    class="bg-indigo-600 font-semibold text-white py-1 px-2 my-1 rounded"
                    :style="{backgroundColor: event.tag_color}"
                  >
                    {{ event.title }}
                  </button>
                </template>
                <template
                 v-else
                >
                  <button
                    :id="event.tag_id"
                    class="bg-indigo-600 font-semibold text-white py-1 px-2 my-1 rounded"
                    :style="{backgroundColor: event.tag_color}"
                    @click="openEventDialog(event)"
                  >
                    {{ event.title }}
                  </button>
                </template>
              </div>
            </template>
          </td>
        </tr>
      </tbody>
    </table>
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
        v-if="!is_list"
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
            :href="route('calendar.calendarList')"
          >
            <button
              class="bg-emerald-500 font-semibold text-white py-4 px-4 mx-5 rounded"
            >
              カレンダー閲覧
            </button>
          </inertia-link>
        </template>
        <template
          v-else
        >
          <inertia-link
            :href="route('calendar.main')"
          >
            <button
              class="bg-emerald-500 font-semibold text-white py-4 px-4 mx-5 rounded"
            >
              カレンダー編集
            </button>
          </inertia-link>
        </template>
      </div>
    </div>
  </div>

  <!-- イベント設定ダイアログ -->
  <EventSettingDialog
    v-model:show="active.eventDialog"
    v-model:data="eventDialogData"
    :colors="myColorQuery"
    @confirm="eventConfirm"
    @delete="eventDelete"
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
