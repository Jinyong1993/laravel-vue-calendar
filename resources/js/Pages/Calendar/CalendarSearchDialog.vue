<script>
import CustomTable from '@/Common/CustomTable.vue'

  export default {
    data () {
      return {
        searchDialog: false,
        searchData: [],

        options: {
          search: {
            title: null
          },
          page: {
            per_page: 10,
            page_now: 1,
            total_page: null,
            total_row: null,
          },
          sort: {
            name: 'event_id',
            order: 'desc',
          },
        },

        headers: [
          {
            name: 'イベントID',
            value: 'event_id',
            key: 'event_id',
            sortable: true
          },
          {
            name: 'タイトル',
            value: 'title',
            sortable: true
          },
          {
            name: '期間 (from)',
            value: 'date_from',
            sortable: true
          },
          {
            name: '期間 (to)',
            value: 'date_to',
            sortable: true
          },
          {
            name: '',
            value: 'actions',
            sortable: false
          },
        ],
      }
    },

    props: {

    },

    components: {
      CustomTable,
    },

    methods: {
      search(){
        axios.get(route('calendar.searchEvent'), {
          params: this.options,
        },
        {
        headers: {
          'Content-Type': 'application/json'
        }
        }).then((response) => {
          this.searchData = response.data
        }).catch((error) => {
          console.log(error)
        })
      },
    },

    watch: {
      // 内容が変更されるたびに、関数が実行されます。
      'options.sort'(newSort, oldSort) {
        this.search()
      },
    },
  }
</script>

<template>
  <v-row justify="center">
    <v-dialog
      v-model="searchDialog"
      persistent
      width="800px"
    >
      <v-card
       class="px-5"
      >
        <div
          class="flex justify-between"
        >
          <div
            class="text-h5 my-2"
          >
            <v-card-title>
              イベント検索
            </v-card-title>
          </div>
        </div>
        <div>
          <v-text-field
            v-model="options.search.title"
            label="イベント名"
            hide-details="auto"
          ></v-text-field>
        </div>
        <div
          class="d-flex my-2"
        >
          <v-spacer></v-spacer>
          <v-btn
            type="submit"
            @click="search"
          >
            検索
          </v-btn>
          <v-spacer></v-spacer>
        </div>
        <custom-table
          :headers="headers"
          :contents="searchData"
          customPageable
          :perPage="5"
        >
        </custom-table>
        <div
          class="mt-2"
        >
          <hr>
        </div>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="grey-darken-5"
            variant="text"
            @click="searchDialog = false"
          >
            閉じる
          </v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

