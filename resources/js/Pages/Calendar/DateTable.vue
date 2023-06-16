<script>
import SvgIcon from '@jamescoyle/vue-icon'
import VueDatePicker from '@vuepic/vue-datepicker'
import { mdiPlusCircle, mdiSvg } from '@mdi/js'
import { mdiChevronLeft } from '@mdi/js';
import { mdiChevronRight } from '@mdi/js';

  export default {
    data () {
      return {
        dates: ["日", "月", "火", "水", "木", "金", "土"],
        month: null,
        year: null,
        path: {
          mdiPlusCircle,
          mdiChevronLeft,
          mdiChevronRight,
        },
        eventQuery: [],
        date_board: [],
        active: {
          progressDialog: false,
        },
        dateSearch: null,
        datePicker: false,
      }
    },

    props: {
      readonly: Boolean,
      event_id: String,
      eventDateFrom: String,
    },

    emits: [
      'add',
      'edit',
    ],

    computed: {

    },

    created() {
      this.resetDateBoard()
    },

    components: {
    VueDatePicker,
    SvgIcon,
},

    watch: {
      dateSearch(val, oldVal) {
        if(!val) {
          this.resetDateBoard()
        } else {
          let date = new Date(val)
          this.year = date.getFullYear()
          this.month = date.getMonth()
          this.dateBoard()
          this.getDateBoard(0)
          this.datePicker = false
        }
      },

      eventDateFrom(val) {
        this.dateSearch = val
      },
    },

    methods: {
      resetDateBoard() {
        let date = new Date()
        this.year = date.getFullYear()
        this.month = date.getMonth()
        this.getDateBoard(0)
      },

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
          this.eventQuery = response.data
        }).catch((error) => {
          console.log(error)
        }).finally(() => this.active.progressDialog = false)
      },

      dateBoard(delta){
        // 先月
        if(delta == -1){
          this.month -= 1
          if(this.month == -1){
            this.year -= 1
            this.month = 11
          }
        } else if(delta == 1){ // 来月
          this.month += 1
          if(this.month == 12){
            this.year += 1
            this.month = 0
          }
        }

        // 日付テーブル生成
        let date_board = []
        let firstDay = new Date(this.year, this.month, 1).getDay()
        let lastDate = new Date(this.year, this.month + 1, 0).getDate()
        let day = 1
        for(let i=0; ; i++){
          date_board[i] = []
          if(i == 0){ // 一週目
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
    },
  }
</script>

<template>
  <div
    class="flex text-center"
  >
    <div class="flex-grow"></div>
    <v-btn
      variant="text"
      height="100px"
      @click="getDateBoard(-1)"
    >
      <svg-icon
        style="width: 50px; height: 50px; color: rgb(149, 149, 149);"
        type="mdi"
        :path="path.mdiChevronLeft"
      ></svg-icon>
    </v-btn>
    <div class="flex-grow"></div>
    <div
      class="flex-grow text-5xl font-extrabold text-sky-500"
    >
      <v-menu
        v-model="datePicker"
        :close-on-content-click="false"
      >
        <template v-slot:activator="{props}">
          <v-btn
            v-bind="props"
            variant="text"
            style="font-size: larger; color: #4CAF50"
            height="100px"
          >
            {{ month+1 }}月
          </v-btn>
        </template>
        <VueDatePicker
          locale="jp"
          inline
          v-model="dateSearch"
          :month-change-on-scroll="false"
          model-type="yyyy-MM"
          :format="dateSearch"
          now-button-label="今月"
          show-now-button
          month-picker
          auto-apply
          placeholder="日付を選択する"
          :enable-time-picker="false"
          :esc-close="true"
        ></VueDatePicker>
      </v-menu>
    </div>
    <div class="flex-grow"></div>
    <v-btn
      variant="text"
      height="100px"
      @click="getDateBoard(1)"
    >
      <svg-icon
        style="width: 50px; height: 50px; color: rgb(149, 149, 149);"
        type="mdi"
        :path="path.mdiChevronRight"
      ></svg-icon>
    </v-btn>
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
                  v-if="!readonly"
                >
                  <v-btn
                    class="pl-0"
                    color="green"
                    variant="text"
                    @click="$emit('add', day.day)"
                  ><svg-icon type="mdi" :path="path.mdiPlusCircle"></svg-icon>
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
              v-if="eventQuery[day.day]"
            >
              <div
                v-for="event in eventQuery[day.day]"
                :key="event.event_id"
                v-show="!event.hidden"
              >
                <template
                  v-if="readonly"
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
                    @click="$emit('edit', event)"
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
  </div>

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
</template>

