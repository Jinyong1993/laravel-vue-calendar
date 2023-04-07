<script>
import { VDataTable } from 'vuetify/labs/VDataTable'

  export default {
    data () {
      return {
        searchDialog: false,
        search_title: null,
        searchData: [],
        itemsPerPage: 0,
        headers: [
          {title: 'イベントID', value: 'event_id', sortable: true},
          {title: 'タイトル', value: 'title', sortable: true},
          {title: '期間 (from)', value: 'date_from', sortable: true},
          {title: '期間 (to)', value: 'date_to', sortable: true},
        ],
      }
    },

    components: {
      VDataTable,
    },

    methods: {
      search(){
        axios.get(route('calendar.searchEvent'), {
          search_title: this.search_title,
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
            v-model="search_title"
            label="イベント名"
            hide-details="auto"
            required
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
        <v-data-table
          v-model:items-per-page="itemsPerPage"
          :headers="headers"
          :items="searchData"
          item-value="event_id"
          class="elevation-1"
          no-data-text="検索したいキーワードを入力してください。"
        ></v-data-table>
        {{ search_title }}
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

