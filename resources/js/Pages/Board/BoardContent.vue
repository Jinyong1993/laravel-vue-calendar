<script>
import CalendarHeader from '@/Layouts/CalendarHeader.vue'

export default {
  components: {
    CalendarHeader,
  },

  props: {
    board: Object,
  },

  data() {
    return {

    }
  },

  methods: {
    board_delete() {
      console.log('d')
      this.$inertia.post(route('board.delete'), {
        board_id: this.board.board_id,
      }, {
          headers: {
          'Content-Type': 'application/json'
          }
      }).then((response) => {

      }).catch((error) => {
        console.log(error)
      })
    },
  },
};
</script>

<template>
  <!-- ヘッダー -->
  <CalendarHeader></CalendarHeader>

  <!-- コンテンツ -->
  <v-card
    class="text-center px-5 py-5 my-5 mx-5"
    style="border-radius: 15px;"
    elevation="5"
  >
    <hr>
    <v-row
      class="my-5"
    >
      <v-col>
        作成者：{{ board.user_id }}
      </v-col>
      <v-col
        class="text-body-1"
        style="font-weight: bold"
      >
        {{ board.title }}
      </v-col>
      <v-col>
        作成日：{{ board.created_at }}
      </v-col>
    </v-row>
    <hr>
    <v-row
      class="my-5"
    >
      <v-col>
        {{ board.note }}
      </v-col>
    </v-row>
    <hr>
  </v-card>

  <!-- ボタン -->
  <div
    class="d-flex justify-center"
  >
    <div>
      <inertia-link
        :href="route('board.list')"
      >
        <v-btn
          class="white--text mx-5"
          style="font-weight: bold"
          color="grey"
          size="large"
        >
          戻る
        </v-btn>
      </inertia-link>
    </div>
    <div>
      <inertia-link
        :href="route('board.boardEdit', {board_id: board.board_id})"
      >
        <v-btn
          class="white--text mx-5"
          style="font-weight: bold"
          color="green"
          size="large"
        >
          編集
        </v-btn>
      </inertia-link>
    </div>
    <div>
      <v-btn
          class="white--text mx-5"
          style="font-weight: bold"
          color="red"
          size="large"
          @click="board_delete"
      >
          削除
      </v-btn>
    </div>
  </div>
</template>

<style scoped>
  .word_overflow {
    display: block;
    width: 300px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
</style>
