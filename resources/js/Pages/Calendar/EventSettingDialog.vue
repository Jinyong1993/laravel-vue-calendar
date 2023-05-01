<script>
import VueDatePicker from '@vuepic/vue-datepicker'
import '@vuepic/vue-datepicker/dist/main.css'

  export default {
    data () {
      return {

      }
    },

    props: [
      'show',
      'data',
      'colors',
    ],
    emits: [
      'update:show',
      'update:data',
      'confirm',
      'delete',
    ],

    components: {
      VueDatePicker,
    },

    methods: {

    },

    computed: {
      dialogShow: {
          get() {
            return this.show
          },
          set(value) {
            this.$emit('update:show', value)
          }
      },
      dialogData: {
        get() {
          return this.data
        },
        set(value) {
          this.$emit('update:data', value);
        }
      }
    },
  }
</script>

<template>
  <v-dialog
    v-model="dialogShow"
    persistent
    width="500px"
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
          <v-card-title
            v-if="!data.is_new"
          >
            イベント編集
          </v-card-title>
          <v-card-title
            v-else
          >
            新規イベント追加
          </v-card-title>
        </div>
        <div
          class="text-h5 my-2"
          v-if="!data.is_new"
        >
          <v-card-title
          >
            <v-btn
              :style="{backgroundColor: dialogData.tag_color}"
              style="color: white; font-weight: bold"
              elevation="2"
            >
              {{ dialogData.tag_name }}
            </v-btn>
          </v-card-title>
        </div>
      </div>
      <v-text-field
        v-model="dialogData.title"
        label="タイトル"
        hide-details="auto"
        required
      ></v-text-field>
      <hr>
      <v-textarea
        v-model="dialogData.text"
        label="内容"
        required
      ></v-textarea>
      <div>
        <v-select
          v-model="dialogData.tag_id"
          :items="colors"
          label="マイカラー設定"
          item-title="tag_name"
          item-value="tag_id"
        >
      </v-select>
      </div>
      <div
        class="flex justify-between"
      >
        <VueDatePicker
          v-model="dialogData.date_from"
          :month-change-on-scroll="false"
          model-type="yyyy-MM-dd"
          :format="dialogData.date_from"
          auto-apply
          placeholder="日付を選択する"
          show-now-button
          required
          :enable-time-picker="false"
          now-button-label="本日"
          :esc-close="true"
          teleport-center
        ></VueDatePicker>
        <span>&nbsp;~&nbsp;</span>
        <VueDatePicker
          v-model="dialogData.date_to"
          :month-change-on-scroll="false"
          model-type="yyyy-MM-dd"
          :format="dialogData.date_to"
          auto-apply
          placeholder="日付を選択する"
          required
          :enable-time-picker="false"
          :esc-close="true"
          teleport-center
        ></VueDatePicker>
      </div>
      <div
        class="mt-5"
      >
        <hr>
      </div>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn
          color="grey-darken-5"
          variant="text"
          @click="dialogShow = false"
        >
          閉じる
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn
          v-if="!data.is_new"
          color="red-darken-1"
          variant="text"
          @click="$emit('delete', true)"
        >
          削除
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn
          color="green-darken-1"
          variant="text"
          @click="$emit('confirm', true)"
        >
          確定
        </v-btn>
        <v-spacer></v-spacer>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

