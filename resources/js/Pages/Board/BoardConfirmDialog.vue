<script>
  export default {
    data () {
      return {

      }
    },

    props: [
      'show',
    ],
    emits: [
      'confirm',
      'update:show',
    ],

    components: {

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
    },
  }
</script>

<template>
  <v-dialog
    v-model="dialogShow"
    persistent
    width="200px"
  >
    <v-card>
      <v-card-title>
        <slot name="title">確認</slot>
      </v-card-title>
      <v-card-text>
        <slot name="body"></slot>
      </v-card-text>
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

