<script>
import CalendarHeader from '@/Layouts/CalendarHeader.vue'
import BoardConfirmDialog from './BoardConfirmDialog.vue'

export default {
  components: {
    CalendarHeader,
    BoardConfirmDialog,
  },

  props: {
    board: Object,
  },

  data() {
    return {
      form: {
        valid: false,
        title: null,
        note: null,
        board_id: null
      },

      rules: {
        required: value => !!value || '必須項目です。',
      },

      active: {
        saveDialog: false,
        backDialog: false,
      },
    }
  },

  methods: {
    submit() {
      if(this.$refs.form.validate()) {
        this.$inertia.post(route('board.save'), {
          title: this.form.title,
          note: this.form.note,
          board_id: this.form.board_id,
        }, {
            headers: {
            'Content-Type': 'application/json'
            },
            onFinish: () => {
              this.active.saveDialog = false
            },
        })
      } else {
        this.active.saveDialog = false
        return
      }
    },

    back() {
      this.$inertia.get(route('board.list'))
    },
  },

  created() {
    if(this.board){
      this.form.title = this.board.title
      this.form.note = this.board.note
      this.form.board_id = this.board.board_id
    }
  }
}
</script>

<template>
  <!-- ヘッダー -->
  <CalendarHeader></CalendarHeader>
  <!-- コンテンツ -->
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
      <v-text-field
        v-model="form.title"
        label="タイトル"
        type="text"
        :rules="[rules.required]"
        required
      ></v-text-field>
      <v-textarea
        v-model="form.note"
        label="内容"
        :rules="[rules.required]"
        required
      ></v-textarea>
    </v-card>
  </v-form>

  <!-- ボタン -->
  <div
    class="d-flex justify-center"
  >
    <div>
      <v-btn
        class="white--text mx-5"
        style="font-weight: bold"
        color="grey"
        size="large"
        @click="active.backDialog = true"
      >
        戻る
      </v-btn>
    </div>
    <div>
      <v-btn
        class="white--text mx-5"
        style="font-weight: bold"
        color="green"
        size="large"
        @click="active.saveDialog = true"
      >
        保存
      </v-btn>
    </div>
  </div>

  <BoardConfirmDialog
    v-model:show="active.backDialog"
    @confirm="back"
  >
    <template v-slot:body>
      戻りますか？
    </template>
  </BoardConfirmDialog>

  <BoardConfirmDialog
    v-model:show="active.saveDialog"
    @confirm="submit"
  >
    <template v-slot:body>
      保存しますか？
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
