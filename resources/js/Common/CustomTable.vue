<script>
import SvgIcon from '@jamescoyle/vue-icon'
import BoardSortButton from '@/Pages/Board/BoardSortButton.vue'

  export default {
    data () {
      return {
        customPage: {
          pageNow: 1,
          pageData: null,
          totalPage: null,
        },
      }
    },

    props: {
      headers: Array,
      sort: Object,
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
      custom_page() {
        let offset = this.perPage * (this.customPage.pageNow - 1)
        this.customPage.pageData = this.contents.slice(offset, offset + this.perPage)
      }
    },

    watch: {
      contents(newData, oldData) {
        let totalRow = this.contents.length
        this.customPage.totalPage = Math.ceil(totalRow / this.perPage)
        this.customPage.pageNow = 1
        this.custom_page()
      },
      'customPage.pageNow'() {
        this.custom_page()
      }
    },

    computed: {
      sortValue: {
        get() {
          return this.sort
        },
        set(value) {
          this.$emit('update:sort', value)
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
