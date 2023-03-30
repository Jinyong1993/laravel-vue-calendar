<template>
    <teleport to="body">
      <div class="modal" id="sample-modal" v-show="isVisible" @click="close"></div>
      <div class="modal-content" v-show="isVisible">ああああああああああああ内容です内容です</div>
    </teleport>
    </template>

    <script>
    export default {
      props: {
        isVisible: {
          required: true,
          type: Boolean,
          default: false,
        }
      },
      data() {
        return {
        }
      },
      methods: {
        close() {
          this.$emit('close')
        }
      }
    }
    </script>

<style scoped>

</style>
