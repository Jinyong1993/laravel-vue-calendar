<script>
import CalendarHeader from '@/Layouts/CalendarHeader.vue'

export default {
  components: {
    CalendarHeader,
  },

  props: {

  },

  data() {
    return {
      boards: [],
      options: {
        per_page: 10,
        page: 1,
        total_page: null,
        total_row: null,
      },
    }
  },

  methods: {
    getBoard(){
      axios.get(route('board.getBoard'),{
        params: this.options
      }, {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then((response) => {
        this.boards = response.data.data
        this.options.total_page = response.data.total_page
        this.options.total_row = response.data.total_row

      }).catch((error) => {
        console.log(error)
      })
    },
  },

  created() {
    this.getBoard()
  },
}
</script>

<template>
  <!-- ヘッダー -->
  <CalendarHeader></CalendarHeader>

  <div>
    <v-table>
      <thead>
        <tr>
          <th>
            ID
          </th>
          <th>
            タイトル
          </th>
          <th>
            作成者
          </th>
          <th>
            内容
          </th>
          <th>
            作成日
          </th>
          <th>
            操作
          </th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="board in boards"
          :key="board.board_id"
        >
          <td>{{ board.board_id }}</td>
          <td>
            <a>
              {{ board.title }}
            </a>
          </td>
          <td>{{ board.user_id }}</td>
          <td>
            <div
              class="word_overflow"
            >{{ board.note }}</div>
          </td>
          <td>{{ board.created_at }}</td>
        </tr>
      </tbody>
    </v-table>
    <v-pagination
      v-model="options.page"
      :length="options.total_page"
      total-visible="10"
      @update:modelValue="getBoard()"
    ></v-pagination>
  </div>
</template>

<style scoped>
  .word_overflow {
    width: 300px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
</style>
