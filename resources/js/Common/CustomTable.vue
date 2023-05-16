<script>
import SvgIcon from '@jamescoyle/vue-icon'
import BoardSortButton from '@/Pages/Board/BoardSortButton.vue'
import { mdiArrowUpThin } from '@mdi/js';
import { mdiArrowDownThin } from '@mdi/js';

  export default {
    data () {
      return {
        customPage: {
          pageNow: 1,
          pageData: null,
          totalPage: null,
        },

        path: {
          mdiArrowUpThin,
          mdiArrowDownThin,
        },

        customSort: {
          name: null,
          order: 'asc',
        },
      }
    },

    props: {
      headers: Array,
      sort: {
        type: Object,
        default: null,
      },
      page: Object,
      contents: Object,
      pageable: Boolean,
      customPageable: Boolean,
      sortable: Boolean,
      tableClass: String,
      tdClass: String,
      perPage: Number,
    },

    emits: [
      'update:sort',
      'update:page',
      'change',
    ],

    components: {
      BoardSortButton,
      SvgIcon,
    },

    methods: {
      custom_page(resetPage) {
        if(resetPage) {
          this.customPage.pageNow = 1
        }
        let offset = this.perPage * (this.customPage.pageNow - 1)
        this.customPage.pageData = this.contents.slice(offset, offset + this.perPage)
      },

      /* sort2
      desc(a, b) {
        let value = this.customSort.name
        if(a[value] < b[value]) {
          return 1
        } else {
          return -1
        }
      },

      asc(a, b) {
        let value = this.customSort.name
        if(a[value] > b[value]) {
          return 1
        } else {
          return -1
        }
      },
      */

      // sort1
      sort1(a, b) {
        let value = this.customSort.name
        return (a[value] < b[value] ? 1 : -1) * (this.customSort.order == 'asc' ? -1 : 1)
      },
    },

    watch: {
      // 検索
      contents(newData, oldData) {
        let totalRow = this.contents.length
        this.customPage.totalPage = Math.ceil(totalRow / this.perPage)
        this.customPage.pageNow = 1
        this.custom_page()
      },

      // ページ切り替え
      'customPage.pageNow'() {
        this.custom_page()
      },

      /* sort2
      'customSort.order'() {
        if(this.customSort.order == 'desc') {
          this.contents.sort(this.desc)
          this.custom_page(true)
        } else {
          this.contents.sort(this.asc)
          this.custom_page(true)
        }
      },
      */

      // sort1
      'customSort.order'() {
        this.contents.sort(this.sort1)
        this.custom_page(true)
      },

      'customSort.name'(newName, oldName) {
        if(newName != oldName) {
          this.customPage.pageNow = 1
        }
      },
    },

    computed: {
      sortValue: {
        get() {
          if(!this.sort) {
            // カスタムソート（クライアントサイド）
            return this.customSort
          } else {
            // ソート（サーバーサイド）
            return this.sort
          }
        },
        set(value) {
          if(!this.sort) {
            // カスタムソート（クライアントサイド）
            this.customSort = value
          } else {
            // ソート（サーバーサイド）
            this.$emit('update:sort', value)
          }
        }
      },

      pagination: {
        get() {
          return this.page
        },
        set(value) {
          this.$emit('update:page', value)
        }
      },
    },
  }
</script>

<template>
  <div>
    <!-- table -->
    <v-table :class="tableClass">
      <thead>
        <tr>
          <th
            v-for="header in headers"
            :key="header.key"
          >{{ header.name }}
            <BoardSortButton
              v-if="header.sortable && sortable"
              v-model="sortValue"
              :sortName="header.value"
            ></BoardSortButton>
          </th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="content in customPageable ? customPage.pageData : contents">
          <template
            v-for="header in headers"
            :key="header.key"
          >
            <td :class="tdClass">
              <slot
                :name="header.value"
                :content="content"
              >
                {{ content[header.value] }}
              </slot>
            </td>
          </template>
        </tr>
      </tbody>
    </v-table>

    <!-- pagination -->
    <div v-if="pageable">
      <v-pagination
        v-model="pagination.page_now"
        :length="pagination.total_page"
        :total-visible="pagination.per_page"
        @update:modelValue="$emit('change', true)"
      ></v-pagination>
    </div>

    <!-- custom pagination -->
    <div v-if="customPageable">
      <v-pagination
        v-model="customPage.pageNow"
        :length="customPage.totalPage"
        :total-visible="perPage"
      ></v-pagination>
    </div>
  </div>
</template>
