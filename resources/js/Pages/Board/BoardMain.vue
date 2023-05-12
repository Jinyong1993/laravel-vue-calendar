<script>
import CalendarLayout from '@/Layouts/CalendarLayout.vue'
import SvgIcon from '@jamescoyle/vue-icon'
import { mdiApplication } from '@mdi/js'
import BoardSortButton from './BoardSortButton.vue'
import ErrorSnackbar from '@/Common/ErrorSnackbar.vue'
import SuccessSnackbar from '@/Common/SuccessSnackbar.vue'
import CustomTable from '@/Common/CustomTable.vue'

export default {
  components: {
    CalendarLayout,
    SvgIcon,
    BoardSortButton,
    ErrorSnackbar,
    SuccessSnackbar,
    CustomTable,
  },

  props: {

  },

  data() {
    return {
      styleObject: {
        color: 'red',
        fontSize: '13px'
      },

      headers: [
        {
          name: 'ID',
          key: 'board_id',
          value: 'board_id',
          sortable: true,
        },
        {
          name: 'タイトル',
          value: 'title',
          sortable: true,
        },
        {
          name: '作成者',
          value: 'user_id',
          sortable: true,
        },
        {
          name: '内容',
          value: 'note',
          sortable: true,
        },
        {
          name: '作成日',
          value: 'created_at',
          sortable: true,
        },
        {
          name: '操作',
          value: 'action',
          sortable: false,
        },
      ],

      boards: [],

      options: {
        page: {
          per_page: 10,
          page_now: 1,
          total_page: null,
          total_row: null,
        },
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
        this.options.page.page_now = 1
      }

      axios.get(route('board.getBoard'),{
        params: this.options
      }, {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then((response) => {
        this.boards = response.data.data
        this.options.page.total_page = response.data.total_page
        this.options.page.total_row = response.data.total_row

      }).catch((error) => {
        console.log(error)
      })
    },
  },

  watch: {
    // 内容が変更されるたびに、関数が実行されます。
    'options.sort'(newSort, oldSort) {
      this.getBoard(true)
    },
  },

  created() {
    this.getBoard()
  },
}
</script>

<template>
  <!-- ヘッダー -->
  <CalendarLayout>

    <!-- テーブル -->
    <CustomTable
      :headers="headers"
      :contents="boards"
      v-model:sort="options.sort"
      v-model:page="options.page"
      pageable
      sortable
      @change="getBoard()"
    >
      <template v-slot:title="item">
        <inertia-link
          :href="route('board.getBoardContent',
          {board_id: item.content.board_id})"
        >
        <v-btn
          variant="plain"
          color="primary"
        >
          {{ item.content.title }}
        </v-btn>
        </inertia-link>
      </template>
      <template v-slot:note="item">
        <div class="word-overflow">
          {{ item.content.note }}
        </div>
      </template>
      <template v-slot:action="item">
        <inertia-link
          :href="route('board.getBoardContent',
          {board_id: item.content.board_id})"
        >
          <svg-icon
            type="mdi"
            :path="path.mdiApplication"
          ></svg-icon>
        </inertia-link>
      </template>
    </CustomTable>

    <!-- アラート -->
    <SuccessSnackbar
      v-model:show="snackbar.success"
    ></SuccessSnackbar>

    <ErrorSnackbar
      v-model:show="snackbar.error"
    ></ErrorSnackbar>

    <div
      class="d-flex justify-end mx-5 my-5"
    >
      <div>
        <inertia-link
          :href="route('board.boardEdit')"
        >
          <v-btn
            color="green"
            style="font-weight: bold"
          >
            作成
          </v-btn>
        </inertia-link>
      </div>
    </div>
  </CalendarLayout>
</template>

<!-- scoped => local -->
<style scoped>
  .word-overflow {
    /* オーバーした要素を非表示にする*/
    overflow: hidden;

    /* 改行を半角スペースに変換することで、1行にする */
    white-space: nowrap;

    /* 幅を指定しないとテキストの長さによって要素の幅が変わるため指定 */
    max-width: 150px;

    /* オーバーしたテキストを３点リーダーにする */
    text-overflow: ellipsis;
  }
</style>
