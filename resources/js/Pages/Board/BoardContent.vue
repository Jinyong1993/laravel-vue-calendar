<script>
import CalendarHeader from '@/Layouts/CalendarHeader.vue'

export default {
  components: {
    CalendarHeader,
  },

  props: {

  },

  data() {
    return {

    }
  },

  methods: {

  },

  created() {

  },
}
</script>

<template>
  <!-- ヘッダー -->
  <CalendarHeader></CalendarHeader>

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
