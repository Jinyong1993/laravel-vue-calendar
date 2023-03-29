<script>
import CalendarHeader from '@/Layouts/CalendarHeader.vue'
import axios from 'axios'

export default {
  props: {
    date_board_query: Array,
  },

  components: {
    CalendarHeader,
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
      active: {
        btnDialog: false,
      },
    }
  },

  methods: {
    getDateBoard(delta){
        this.dateBoard(delta)
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
        console.log(response)
        this.query = response.data
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
  },

  created() {
    let date = new Date()
    this.year = date.getFullYear()
    this.month = date.getMonth()

    this.cur_date = this.year + '年' + (this.month + 1) + '月' + date.getDate() + '日' + this.dates[date.getDay()] + '曜日'

    this.getDateBoard(0)
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
            v-for="(day, d_idx) in week"
            :key="d_idx"
          >
            {{ day.day }}
            <div
              v-if="query[day.day]"
            >
              <template
                v-for="q in query[day.day]"
                :key="q.event_id"
              >
                <button
                  class="bg-indigo-600 font-semibold text-white py-1 px-1 rounded"
                  :style="{backgroundColor: q.tag_color}"
                >
                  {{ q.title }}
                </button>
              </template>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
