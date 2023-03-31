<script>
import CalendarHeader from '@/Layouts/CalendarHeader.vue'
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
  },

  components: {
    CalendarHeader,
    VueDatePicker,
    SvgIcon,
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
          eventDialog: false,
          plusDialog: false,
          progressDialog: false,
          myColorSettingDialog: false,
      },

      eventDialogData: {
        event_id: null,
        title: null,
        text: null,
        date_from: null,
        date_to: null,
        tag_id: null,
      },

      path: mdiPlusCircle,
      //key: 0,

      myColorDialogData: {
        tag_id: null,
        tag_name: null,
        tag_note: null,
        tag_color: null,
      },
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
      this.eventDialogData = event

      /* >> this.eventDialogData = event <<
      this.eventDialogData.title = event.title
      this.eventDialogData.text = event.text
      this.eventDialogData.date_from = event.date_from
      this.eventDialogData.date_to = event.date_to
      this.eventDialogData.tag_color = event.tag_color
      */

      this.active.eventDialog = true
    },

    eventConfirm(){
      axios.post(route('calendar.eventUpdate'), {
        event_id: this.eventDialogData.event_id,
        title: this.eventDialogData.title,
        text: this.eventDialogData.text,
        date_from: this.eventDialogData.date_from,
        date_to: this.eventDialogData.date_to,
        tag_id: this.eventDialogData.tag_id.tag_id,
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then((response) => {
        this.active.eventDialog = false
        this.active.plusDialog = false

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
        this.active.plusDialog = false

        this.getDateBoard(0, true)

      }).catch(function (error) {

      });
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
        this.active.myColorSettingDialog = false

        this.getDateBoard(0, true)
      }).catch(function (error) {
        console.log(error)
      });
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

    openPlusDialog(day){
      this.eventDialogData = {
        event_id:null,
        title:null,
        text:null,
        date_from:this.year + '-' + (this.month+1) + '-' + day,
        date_to:null,
        tag_id:null,
      }

      this.active.plusDialog = true
    },

    openMyColorSettingDialog(){
      this.eventDialogData = {
        tag_id: null,
        tag_name: null,
        tag_note: null,
        tag_color: null,
      }

      this.active.myColorSettingDialog = true
    },

    myColorChange(event){
      this.myColorDialogData.tag_id = event.tag_id
      this.myColorDialogData.tag_name = event.tag_name
      this.myColorDialogData.tag_note = event.tag_note
      this.myColorDialogData.tag_color = event.tag_color
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
  <div
    class="flex text-center my-10"
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
              <div>
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
            <div
              v-if="query[day.day]"
            >
              <template
                v-for="event in query[day.day]"
                :key="event.event_id"
              >
                <button
                  class="bg-indigo-600 font-semibold text-white py-1 px-2 my-1 rounded"
                  :style="{backgroundColor: event.tag_color}"
                  @click="openEventDialog(event)"
                >
                  {{ event.title }}
                </button><br>
              </template>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    <div
     class="flex my-3 py-5 px-5"
    >
      <button
        class="bg-emerald-500 font-semibold text-white py-4 px-4 rounded"
        @click="openMyColorSettingDialog"
      >
        マイカラー設定
      </button>
    </div>
  </div>

  <!-- イベント設定ダイアログ -->
  <v-row justify="center">
    <v-dialog
      v-model="active.eventDialog"
      persistent
      width="500px"
    >
      <v-card
       class="px-5"
      >
        <div
          class="flex justify-between"
        >
          <div
            class="text-h5 my-2"
          >
            <v-card-title>
              イベント設定
            </v-card-title>
          </div>
          <div
            class="text-h5 my-2"
          >
            <v-card-title
              v-if="eventDialogData.tag_name"
            >
              <v-btn
                elevation="2"
              >
                {{ eventDialogData.tag_name }}
              </v-btn>
            </v-card-title>
          </div>
        </div>
        <v-text-field
          v-model="eventDialogData.title"
          label="タイトル"
          hide-details="auto"
          required
        ></v-text-field>
        <hr>
        <v-textarea
          v-model="eventDialogData.text"
          label="内容"
          required
        ></v-textarea>
        <div>
          <v-select
            v-model="eventDialogData.tag_id"
            :items="myColorQuery"
            label="マイカラー設定"
            item-title="tag_name"
            item-value="tag_id"
            return-object
          >
        </v-select>
        </div>
        <div
          class="flex justify-between"
        >
          <VueDatePicker
            v-model="eventDialogData.date_from"
            :month-change-on-scroll="false"
            model-type="yyyy-MM-dd"
            :format="eventDialogData.date_from"
            auto-apply
            placeholder="日付を選択する"
            show-now-button
            required
            :enable-time-picker="false"
            now-button-label="本日"
            :esc-close="true"
            teleport-center
          ></VueDatePicker>
          <span>&nbsp;~&nbsp;</span>
          <VueDatePicker
            v-model="eventDialogData.date_to"
            :month-change-on-scroll="false"
            model-type="yyyy-MM-dd"
            :format="eventDialogData.date_to"
            auto-apply
            placeholder="日付を選択する"
            required
            :enable-time-picker="false"
            :esc-close="true"
            teleport-center
          ></VueDatePicker>
        </div>
        <div
          class="mt-5"
        >
          <hr>
        </div>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="grey-darken-5"
            variant="text"
            @click="active.eventDialog = false"
          >
            閉じる
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn
            color="green-darken-1"
            variant="text"
            @click="eventConfirm"
          >
            確定
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn
            color="red-darken-1"
            variant="text"
            @click="eventDelete"
          >
            削除
          </v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>

  <!-- プラス、イベント追加ダイアログ -->
  <v-row justify="center">
    <v-dialog
      v-model="active.plusDialog"
      persistent
      width="500px"
    >
      <v-card
       class="px-5"
      >
        <div
          class="flex justify-between"
        >
          <div
            class="text-h5 my-2"
          >
            <v-card-title>
              イベント追加
            </v-card-title>
          </div>
        </div>
        <v-text-field
          v-model="eventDialogData.title"
          label="タイトル"
          hide-details="auto"
          required
        ></v-text-field>
        <hr>
        <v-textarea
          v-model="eventDialogData.text"
          label="内容"
          required
        ></v-textarea>
        <div>
          <v-select
            v-model="eventDialogData.tag_id"
            :items="myColorQuery"
            label="マイカラー設定"
            item-title="tag_name"
            item-value="tag_id"
            return-object
          >
        </v-select>
        </div>
        <div
          class="flex justify-between"
        >
          <VueDatePicker
            v-model="eventDialogData.date_from"
            :month-change-on-scroll="false"
            model-type="yyyy-MM-dd"
            :format="eventDialogData.date_from"
            auto-apply
            placeholder="日付を選択する"
            show-now-button
            required
            :enable-time-picker="false"
            now-button-label="本日"
            :esc-close="true"
            teleport-center
          ></VueDatePicker>
          <span>&nbsp;~&nbsp;</span>
          <VueDatePicker
            v-model="eventDialogData.date_to"
            :month-change-on-scroll="false"
            model-type="yyyy-MM-dd"
            :format="eventDialogData.date_to"
            auto-apply
            placeholder="日付を選択する"
            required
            :enable-time-picker="false"
            :esc-close="true"
            teleport-center
          ></VueDatePicker>
        </div>
        <div
          class="mt-5"
        >
          <hr>
        </div>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="grey-darken-5"
            variant="text"
            @click="active.plusDialog = false"
          >
            閉じる
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn
            color="green-darken-1"
            variant="text"
            @click="eventConfirm"
          >
            確定
          </v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>

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
  <v-row justify="center">
    <v-dialog
      v-model="active.myColorSettingDialog"
      persistent
      width="500px"
    >
      <v-card
       class="px-5"
      >
        <div
          class="flex justify-between"
        >
          <div
            class="text-h5 my-2"
          >
            <v-card-title>
              マイカラー設定
            </v-card-title>
          </div>
        </div>
        <v-text-field
          v-model="myColorDialogData.tag_name"
          label="カラー名"
          hide-details="auto"
          required
        ></v-text-field>
        <hr>
        <v-textarea
          v-model="myColorDialogData.tag_note"
          label="カラー説明"
          required
        ></v-textarea>
        <div>
          <v-select
            v-model="myColorDialogData.tag_id"
            :items="myColorQuery"
            label="マイカラー設定"
            item-title="tag_name"
            item-value="tag_id"
            return-object
            @update:modelValue="myColorChange(myColorDialogData.tag_id)"
          >
          </v-select>
        </div>
        <div
          class="px-20 py-5"
        >
          <v-color-picker
            v-model="myColorDialogData.tag_color"
            elevation="5"
          ></v-color-picker>
        </div>
        <div>
          {{ myColorDialogData.tag_color }}
        </div>
        <div
          class="mt-5"
        >
          <hr>
        </div>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="grey-darken-5"
            variant="text"
            @click="active.myColorSettingDialog = false"
          >
            閉じる
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn
            color="green-darken-1"
            variant="text"
            @click="myColorConfirm"
          >
            確定
          </v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>
