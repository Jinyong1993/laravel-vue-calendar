<script>
import VueDatePicker from '@vuepic/vue-datepicker'
import '@vuepic/vue-datepicker/dist/main.css'

  export default {
    data () {
      return {
        eventDialog: false,
      }
    },

    props: {

    },

    components: {
      VueDatePicker,
    },

    methods: {

    },
  }
</script>

<template>
  <v-row justify="center">
    <v-dialog
      v-model="eventDialog"
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
            <v-card-title>
              イベント設定
            </v-card-title>
          </div>
          <div
            class="text-h5 my-2"
          >
            <v-card-title
              v-if="this.$parent.eventDialogData.tag_name"
            >
              <v-btn
                elevation="2"
              >
                {{ this.$parent.eventDialogData.tag_name }}
              </v-btn>
            </v-card-title>
          </div>
        </div>
        <v-text-field
          v-model="this.$parent.eventDialogData.title"
          label="タイトル"
          hide-details="auto"
          required
        ></v-text-field>
        <hr>
        <v-textarea
          v-model="this.$parent.eventDialogData.text"
          label="内容"
          required
        ></v-textarea>
        <div>
          <v-select
            v-model="this.$parent.eventDialogData.tag_id"
            :items="this.$parent.myColorQuery"
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
            v-model="this.$parent.eventDialogData.date_from"
            :month-change-on-scroll="false"
            model-type="yyyy-MM-dd"
            :format="this.$parent.eventDialogData.date_from"
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
            v-model="this.$parent.eventDialogData.date_to"
            :month-change-on-scroll="false"
            model-type="yyyy-MM-dd"
            :format="this.$parent.eventDialogData.date_to"
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
            @click="eventDialog = false"
          >
            閉じる
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn
            color="red-darken-1"
            variant="text"
            @click="this.$parent.eventDelete"
          >
            削除
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn
            color="green-darken-1"
            variant="text"
            @click="this.$parent.eventConfirm"
          >
            確定
          </v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

