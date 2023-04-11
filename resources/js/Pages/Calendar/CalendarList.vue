<script>
import CalendarMain from './CalendarMain.vue'

export default {
  components: {
    CalendarMain,
  },

  props: {
    is_list: Boolean,
  },

  data() {
    return {
    }
  }
}
</script>

<template>
  <CalendarMain
    :is_list="is_list"
  ></CalendarMain>
</template>
