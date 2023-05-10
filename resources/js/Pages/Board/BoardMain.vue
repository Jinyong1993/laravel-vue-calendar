<script>
import CalendarHeader from '@/Layouts/CalendarHeader.vue'
import SvgIcon from '@jamescoyle/vue-icon';
import { mdiApplication } from '@mdi/js';
import { mdiArrowUpThin } from '@mdi/js';
import { mdiArrowDownThin } from '@mdi/js';

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
        sort_target: null,
        order: null,
      },

      path: {
        mdiApplication,
        mdiArrowUpThin,
        mdiArrowDownThin,
      },

      sort: {
        board_id: false,
        title: false,
        user_id: false,
        note: false,
        created_at: false,
      },
    }
  },

  methods: {
    getBoard(sort_target = null, order = null) {
      axios.get(route('board.getBoard'),{
        params: this.options,
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

    toggleSort(event) {
      if(event == 1) {
        this.sort.board_id = !this.sort.board_id
        this.options.sort_target = 'board_id'
        if(this.options.order == 'asc'){
          this.options.order = 'desc'
        } else {
          this.options.order = 'asc'
        }
        this.getBoard()
      }
      if(event == 2) {
        this.sort.title = !this.sort.title
        this.options.sort_target = 'title'
        if(this.options.order == 'asc'){
          this.options.order = 'desc'
        } else {
          this.options.order = 'asc'
        }
        this.getBoard()
      }
      if(event == 3) {
        this.sort.user_id = !this.sort.user_id
        this.options.sort_target = 'user_id'
        if(this.options.order == 'asc'){
          this.options.order = 'desc'
        } else {
          this.options.order = 'asc'
        }
        this.getBoard()
      }
      if(event == 4) {
        this.sort.note = !this.sort.note
        this.options.sort_target = 'note'
        if(this.options.order == 'asc'){
          this.options.order = 'desc'
        } else {
          this.options.order = 'asc'
        }
        this.getBoard()
      }
      if(event == 5) {
        this.sort.created_at = !this.sort.created_at
        this.options.sort_target = 'created_at'
        if(this.options.order == 'asc'){
          this.options.order = 'desc'
        } else {
          this.options.order = 'asc'
        }
        this.getBoard()
      }
    }
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
            style="width: 15%"
          >
            ID
            <v-btn
              class="px-1"
              variant="text"
              size="xs-small"
              @click="toggleSort(1)"
            >
              <svg-icon
                v-if="sort.board_id"
                type="mdi"
                :path="path.mdiArrowUpThin"
              ></svg-icon>
              <svg-icon
                v-else
                type="mdi"
                :path="path.mdiArrowDownThin"
              ></svg-icon>
            </v-btn>
          </th>
          <th
            style="width: 20%"
          >
            タイトル
            <v-btn
              class="px-1"
              variant="text"
              size="xs-small"
              @click="toggleSort(2)"
            >
              <svg-icon
                v-if="sort.title"
                type="mdi"
                :path="path.mdiArrowUpThin"
              ></svg-icon>
              <svg-icon
                v-else
                type="mdi"
                :path="path.mdiArrowDownThin"
              ></svg-icon>
            </v-btn>
          </th>
          <th
            style="width: 15%"
          >
            作成者
            <v-btn
              class="px-1"
              variant="text"
              size="xs-small"
              @click="toggleSort(3)"
            >
              <svg-icon
                v-if="sort.user_id"
                type="mdi"
                :path="path.mdiArrowUpThin"
              ></svg-icon>
              <svg-icon
                v-else
                type="mdi"
                :path="path.mdiArrowDownThin"
              ></svg-icon>
            </v-btn>
          </th>
          <th
            style="width: 20%"
          >
            内容
            <v-btn
              class="px-1"
              variant="text"
              size="xs-small"
              @click="toggleSort(4)"
            >
              <svg-icon
                v-if="sort.note"
                type="mdi"
                :path="path.mdiArrowUpThin"
              ></svg-icon>
              <svg-icon
                v-else
                type="mdi"
                :path="path.mdiArrowDownThin"
              ></svg-icon>
            </v-btn>
          </th>
          <th
            style="width: 20%"
          >
            作成日
            <v-btn
              class="px-1"
              variant="text"
              size="xs-small"
              @click="toggleSort(5)"
            >
              <svg-icon
                v-if="sort.created_at"
                type="mdi"
                :path="path.mdiArrowUpThin"
              ></svg-icon>
              <svg-icon
                v-else
                type="mdi"
                :path="path.mdiArrowDownThin"
              ></svg-icon>
            </v-btn>
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
</template>

<style scoped>
  .word_overflow {
    width: 300px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
</style>
