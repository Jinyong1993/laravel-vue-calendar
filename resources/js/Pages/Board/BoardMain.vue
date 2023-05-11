<script>
import CalendarLayout from '@/Layouts/CalendarLayout.vue'
import SvgIcon from '@jamescoyle/vue-icon';
import { mdiApplication } from '@mdi/js';
import BoardSortButton from './BoardSortButton.vue'
import ErrorSnackbar from '@/Common/ErrorSnackbar.vue'
import SuccessSnackbar from '@/Common/SuccessSnackbar.vue'

export default {
  components: {
    CalendarLayout,
    SvgIcon,
    BoardSortButton,
    ErrorSnackbar,
    SuccessSnackbar,
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
        sort: {
          name: 'board_id',
          order: 'desc',
        },
      },

      path: {
        mdiApplication,
      },

      snackbar: {
        error: Object.keys(this.$page.props.errors).length > 0,
        success: !!this.$page.props.message,
      },
    }
  },

  methods: {
    getBoard(resetPage = null) {
      if(resetPage) {
        // クリック時、１ページに遷移する。
        this.options.page = 1
      }

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

  watch: {
    // 内容が変更されるたびに、関数が実行されます。
    'options.sort'(newSort, oldSort) {
      this.getBoard(true)
    }
  },

  created() {
    this.getBoard()
  },
}
</script>

<template>
  <!-- ヘッダー -->
  <CalendarLayout>
    <SuccessSnackbar
      v-model:show="snackbar.success"
    ></SuccessSnackbar>

    <ErrorSnackbar
      v-model:show="snackbar.error"
    ></ErrorSnackbar>

    <div>
      <v-table>
        <thead>
          <tr>
            <th
              style="width: 15%"
            >
              ID
              <!-- 子コンポーネントのv-modelのdefault = modelValue -->
              <BoardSortButton
                v-model="options.sort"
                sortName="board_id"
              ></BoardSortButton>
            </th>
            <th
              style="width: 20%"
            >
              タイトル
              <BoardSortButton
                v-model="options.sort"
                sortName="title"
              ></BoardSortButton>
            </th>
            <th
              style="width: 20%"
            >
              作成者
              <BoardSortButton
                v-model="options.sort"
                sortName="user_id"
              ></BoardSortButton>
            </th>
            <th
              style="width: 15%"
            >
              内容
              <BoardSortButton
                v-model="options.sort"
                sortName="note"
              ></BoardSortButton>
            </th>
            <th
              style="width: 20%"
            >
              作成日
              <BoardSortButton
                v-model="options.sort"
                sortName="created_at"
              ></BoardSortButton>
            </th>
            <th
              style="width: 10%"
            >
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
            <td>
              <inertia-link
                :href="route('board.getBoardContent', {board_id: board.board_id})"
              >
                <svg-icon type="mdi" :path="path.mdiApplication"></svg-icon>
              </inertia-link>
            </td>
          </tr>
        </tbody>
      </v-table>
      <div
        class="d-flex justify-end mx-5 my-5"
      >
        <div>
          <v-pagination
            v-model="options.page"
            :length="options.total_page"
            total-visible="10"
            @update:modelValue="getBoard()"
          ></v-pagination>
        </div>
        <div>
          <inertia-link
            :href="route('board.boardEdit')"
          >
            <v-btn
              class="mt-2"
              color="green"
              style="font-weight: bold"
            >
              作成
            </v-btn>
          </inertia-link>
        </div>
      </div>
    </div>
  </CalendarLayout>
</template>

<style scoped>
  .word_overflow {
    width: 300px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
</style>
