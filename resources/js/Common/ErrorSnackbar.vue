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
  <v-snackbar
    v-model="alertShow"
  >
    <ul>
      <li
        v-for="error in $page.props.errors"
      >
        {{ error }}
      </li>
    </ul>
    <template v-slot:actions>
      <v-btn
        color="red"
        variant="text"
        @click="alertShow = false"
      >
        Close
      </v-btn>
    </template>
  </v-snackbar>
</template>

