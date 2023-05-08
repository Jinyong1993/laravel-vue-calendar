<script>
import CalendarHeader from '@/Layouts/CalendarHeader.vue'
import SvgIcon from '@jamescoyle/vue-icon';
import { mdiApplication } from '@mdi/js';

export default {
  components: {
    CalendarHeader,
    SvgIcon,
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
      path: mdiApplication,
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
          <th
            style="width: 10%"
          >ID</th>
          <th
            style="width: 20%"
          >タイトル</th>
          <th
            style="width: 20%"
          >作成者</th>
          <th
            style="width: 20%"
          >内容</th>
          <th
            style="width: 20%"
          >作成日</th>
          <th
            style="width: 10%"
          >操作</th>
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
          <td>
            <inertia-link
              :href="route('board.getBoardContent', {board_id: board.board_id})"
            >
              <svg-icon type="mdi" :path="path"></svg-icon>
            </inertia-link>
          </td>
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