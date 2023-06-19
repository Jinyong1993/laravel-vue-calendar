<script>
import CustomTable from '@/Common/CustomTable.vue'
import SvgIcon from '@jamescoyle/vue-icon';
import { mdiCalendar } from '@mdi/js';

  export default {
    data () {
      return {
        searchDialog: false,
        searchResultData: [],

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
            name: '操作',
            value: 'actions',
            sortable: false
          },
        ],

        path: {
          mdiCalendar,
        },
      }
    },

    props: {

    },

    components: {
      CustomTable,
      SvgIcon,
    },

    emits: [
      'eventDateClick'
    ],

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
          this.searchResultData = response.data
        }).catch((error) => {
          console.log(error)
        })
      },

      eventData(event) {
        this.$emit('eventDateClick', event.content)
        this.searchDialog = false
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
        <CustomTable
          :headers="headers"
          :contents="searchResultData"
          customPageable
          :perPage="5"
          sortable
        >
          <template v-slot:actions="item">
            <v-btn
              variant="text"
              @click="eventData(item)"
            >
              <svg-icon type="mdi" :path="path.mdiCalendar"></svg-icon>
            </v-btn>
          </template>
        </CustomTable>
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

