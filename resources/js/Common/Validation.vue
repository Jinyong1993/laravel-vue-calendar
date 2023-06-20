<script>
  export default {
    data () {
      return {

      }
    },

    props: [
      'show',
      'errorMessages'
    ],
    emits: [
      'update:show',
    ],

    components: {

    },

    methods: {

    },

    computed: {
      alertShow: {
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
  <v-alert
    v-model="alertShow"
    type="error"
    closable
    class="mt-0"
  >
    <div
      v-for="(errors, errors_idx) in errorMessages"
      :key="errors_idx"
    >
      <span
        v-for="(error, error_idx) in errors"
        :key="error_idx"
      >
        {{ error }}
      </span>
    </div>
  </v-alert>
</template>

