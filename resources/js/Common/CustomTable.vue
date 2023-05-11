<script>
import SvgIcon from '@jamescoyle/vue-icon'
import BoardSortButton from '@/Pages/Board/BoardSortButton.vue'

  export default {
    data () {
      return {

      }
    },

    props: {
      headers: Array,
      sort: Object,
      page: Object,
      contents: Object,
      pageable: Boolean,
      tableClass: String,
      tdClass: String,
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
              v-if="header.sortable"
              v-model="sortValue"
              :sortName="header.value"
            ></BoardSortButton>
          </th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="content in contents">
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
  </div>
</template>
