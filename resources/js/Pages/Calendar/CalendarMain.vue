<script>
export default {
  data() {
    return {
      cur_date: null,
      year: null,
      month: null,
      day: null,
      dates: ["日", "月", "火", "水", "木", "金", "土"],
      date_board: [],
    }
  },
  methods: {
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
              date_board[i][h] = day++
          }
        } else {
          for(let j=0; j<7; j++){
            date_board[i][j] = day++
            if(day > lastDate){
              return this.date_board = date_board
            }
          }
        }
      }
    },
  },
  mounted() {
    let date = new Date()
    this.year = date.getFullYear()
    this.month = date.getMonth()

    this.cur_date = this.year + '年' + (this.month + 1) + '月' + date.getDate() + '日' + this.dates[date.getDay()] + '曜日'

    this.dateBoard(0)
  }
}
</script>

<template>
  <button
  >
    dateboard
  </button>
  <div>
    {{ cur_date }}
  </div>
  <div>
    {{ year }}
  </div>
  <div>
    {{ month+1 }}
  </div>

  <table>
    <thead>
      <tr>
        <template v-for="date in dates">
          <th>{{ date }}</th>
        </template>
      </tr>
    </thead>
    <tbody
      :key="year+' '+month"
    >
      <tr
        v-for="(week, w_idx) in date_board"
        :key="w_idx"
      >
        <td
          v-for="(day, d_idx) in week"
          :key="d_idx"
        >{{ day }}</td>
      </tr>
    </tbody>
  </table>
  <button
    @click="dateBoard(-1)"
  >
    先月
  </button>&nbsp;&nbsp;
  <button
    @click="dateBoard(1)"
  >
    来月
  </button>
</template>
