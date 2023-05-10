<script>
import CalendarHeader from '@/Layouts/CalendarHeader.vue'
import ErrorSnackbar from '@/Common/ErrorSnackbar.vue'
import SuccessSnackbar from '@/Common/SuccessSnackbar.vue'
import BoardConfirmDialog from './BoardConfirmDialog.vue'

export default {
  components: {
    CalendarHeader,
    ErrorSnackbar,
    SuccessSnackbar,
    BoardConfirmDialog,
  },

  props: {
    board: Object,
    board_comments: Object,
    user_id: Number,
  },

  data() {
    return {
      form: {
        valid: false,
        note: null,
      },

      rules: {
        required: value => !!value || '必須項目です。',
      },

      snackbar: {
        error: Object.keys(this.$page.props.errors).length > 0,
        success: !!this.$page.props.message,
      },

      active: {
        boardEditDialog: false,
        boardDeleteDialog: false,
        commentCreateDialog: false,
        commentDeleteDialog: false,
        commentEditDialog: false,
      }
    }
  },

  methods: {
    board_delete() {
      this.$inertia.post(route('board.delete'), {
        board_id: this.board.board_id,
      }, {
          headers: {
          'Content-Type': 'application/json'
          }
      })
    },

    comment_edit(event) {
      event.editing = true
    },

    comment_edit_cancel(event) {
      event.editing = false
    },

    comment_update(event) {
      if(this.$refs.form.validate()) {
        this.$inertia.post(route('comment.update'), {
          note: event.note,
          comment_id: event.comment_id,
        }, {
            headers: {
            'Content-Type': 'application/json'
            },

            onFinish: () => {
              this.snackbar.success = true
            },
        })
      } else {
        return
      }
    },

    comment_create() {
      if(this.$refs.form.validate()) {
        this.$inertia.post(route('comment.store'), {
          note: this.form.note,
          board_id: this.board.board_id,
        }, {
            headers: {
            'Content-Type': 'application/json'
            },

            onFinish: () => {
              this.snackbar.success = true
            },

            // 再レンダリング
            preserveState: false,
        })
      } else {
        return
      }
    },

    comment_delete(event) {
      if(this.$refs.form.validate()) {
        this.$inertia.post(route('comment.delete'), {
          comment_id: event.comment_id,
          board_id: this.board.board_id,
        }, {
            headers: {
            'Content-Type': 'application/json'
            },

            onFinish: () => {
              this.snackbar.success = true
            },
        })
      } else {
        return
      }
    },

    toEdit() {
      this.$inertia.get(route('board.boardEdit', {board_id: this.board.board_id}))
    }
  },
};
</script>

<template>
  <!-- ヘッダー -->
  <CalendarHeader></CalendarHeader>

  <SuccessSnackbar
    v-model:show="snackbar.success"
  ></SuccessSnackbar>

  <ErrorSnackbar
    v-model:show="snackbar.error"
  ></ErrorSnackbar>

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
    <div
      v-if="this.board.user_id == this.user_id"
    >
      <v-btn
        class="white--text mx-5"
        style="font-weight: bold"
        color="green"
        size="large"
        @click="active.boardEditDialog = true"
      >
        編集
      </v-btn>
    </div>
    <div
      v-if="this.board.user_id == this.user_id"
    >
      <v-btn
          class="white--text mx-5"
          style="font-weight: bold"
          color="red"
          size="large"
          @click="active.boardDeleteDialog = true"
      >
          削除
      </v-btn>
    </div>
  </div>

  <!-- 新規コメント作成 -->
  <v-form
    v-model="form.valid"
    ref="form"
    @submit.prevent
  >
    <v-card
      class="text-center px-5 py-5 my-5 mx-5"
      style="border-radius: 15px;"
      elevation="5"
    >
      <v-row>
        <v-col>
          <v-textarea
            label="新規コメント作成"
            v-model="form.note"
            :rules="[rules.required]"
            row-height="15"
            rows="3"
          ></v-textarea>
        </v-col>
      </v-row>
      <div
        class="d-flex justify-end"
      >
        <v-btn
          class="font-weight-bold"
          size="default"
          color="green"
          @click="comment_create"
        >
          作成
        </v-btn>
      </div>
    </v-card>
  </v-form>

  <!-- コメント -->
  <v-form
    v-model="form.valid"
    ref="form"
    @submit.prevent
  >
    <div
      v-for="comment in board_comments"
    >
      <v-card
        class="text-center px-5 py-5 my-5 mx-5"
        elevation="5"
      >
        <div
          class="d-flex justify-space-between"
        >
          <div>
            <v-card-title
              class="text-body-2"
            >作成者：{{ comment.user_id }}</v-card-title>
          </div>
          <div
            class="mt-4"
          >
            <v-card-subtitle>作成日：{{ comment.updated_at }}</v-card-subtitle>
          </div>
        </div>
        <hr>
        <v-row
          class="my-2"
        >
          <v-col
            v-if="!comment.editing"
            style="text-align: left;"
          >
            {{ comment.note }}
          </v-col>
          <v-col
            v-else
          >
            <v-textarea
              label="コメント編集"
              v-model="comment.note"
              :rules="[rules.required]"
            ></v-textarea>
          </v-col>
        </v-row>
        <hr>
        <div
          class="d-flex justify-end"
          v-if="comment.user_id == this.user_id"
        >
          <div
            v-if="!comment.editing"
          >
            <v-btn
              class="mt-4 font-weight-bold mx-1"
              size="small"
              color="red"
              @click="comment_delete(comment)"
            >
              削除
            </v-btn>
            <v-btn
              class="mt-4 font-weight-bold mx-1"
              size="small"
              color="info"
              @click="comment_edit(comment)"
            >
              編集
            </v-btn>
          </div>
          <div
            v-else
          >
            <v-btn
              class="mt-4 font-weight-bold mx-1"
              size="small"
              color="grey"
              @click="comment_edit_cancel(comment)"
            >
              取り消し
            </v-btn>
            <v-btn
              class="mt-4 font-weight-bold mx-1"
              size="small"
              color="green"
              @click="comment_update(comment)"
            >
              保存
            </v-btn>
          </div>
        </div>
      </v-card>
    </div>
  </v-form>

  <!-- ボード確認ダイアログ -->
  <BoardConfirmDialog
    v-model:show="active.boardEditDialog"
    @confirm="toEdit"
  >
    <template v-slot:body>
      編集しますか？
    </template>
  </BoardConfirmDialog>

  <BoardConfirmDialog
    v-model:show="active.boardDeleteDialog"
    @confirm="board_delete"
  >
    <template v-slot:body>
      削除しますか？
    </template>
  </BoardConfirmDialog>
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
