<script>
import Validation from '@/Common/Validation.vue'

  export default {
    data () {
      return {
        isError: false,
      }
    },

    props: [
      'show',
      'error',
      'data',
      'errorMessages',
      'colors',
    ],
    emits: [
      'update:show',
      'update:error',
      'update:data',
      'colorDelete',
      'colorConfirm',
    ],

    computed: {
      dialogShow: {
        get() {
          return this.show
        },
        set(value) {
          this.$emit('update:show', value)
        },
      },

      dialogData: {
        get() {
          return this.data
        },
        set(value) {
          this.$emit('update:data', value);
        },
      },

      errorShow: {
        get() {
          return this.error
        },
        set(value) {
          this.$emit('update:error', value)
        },
      },
    },

    components: {
      Validation,
    },

    methods: {

    },
  }
</script>

<template>
  <v-row justify="center">
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
            <v-card-title>
              マイカラー設定
            </v-card-title>
          </div>
        </div>

        <div v-if="isError">
          <Validation
            v-model:show="errorShow"
            :errorMessages="errorMessages"
          ></Validation>
        </div>

        <v-text-field
          v-model="dialogData.tag_name"
          label="カラー名"
          hide-details="auto"
          required
        ></v-text-field>
        <hr>
        <v-textarea
          v-model="dialogData.tag_note"
          label="カラー説明"
          required
        ></v-textarea>
        <div>
          <v-select
            v-model="dialogData"
            :items="colors"
            label="マイカラー設定"
            item-title="tag_name"
            item-value="tag_id"
            return-object
          >
          </v-select>
        </div>
        <div
          class="px-20 py-5"
        >
          <v-color-picker
            v-model="dialogData.tag_color"
            elevation="5"
          ></v-color-picker>
        </div>
        <div>
          {{ dialogData.tag_color }}
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
            color="red-darken-1"
            variant="text"
            @click="$emit('colorDelete', true)"
          >
            削除
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn
            color="green-darken-1"
            variant="text"
            @click="$emit('colorConfirm', true)"
          >
            確定
          </v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

