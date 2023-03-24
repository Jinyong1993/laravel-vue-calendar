<script>
export default {
  props: {
    date: String,
    year: Number,
  }
};
</script>
<template>
  <div
    class="flex w-full bg-red-500 py-3 text-white text-2xl font-bold justify-between"
  >
    <div class="px-3 py-3 shadow hover:shadow-inner">
      <a
        href="#"
      >
        カレンダー
      </a>
    </div>
    <div class="px-3 py-3 shadow hover:shadow-inner">
      今日：{{ date }}
    </div>
    <div class="px-3 py-3 shadow hover:shadow-inner">
      {{ year }} 年
    </div>
    <div class="px-3 py-3 shadow hover:shadow-inner">
      <a>info</a>
    </div>
  </div>
</template>

