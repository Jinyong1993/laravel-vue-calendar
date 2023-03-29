<script>
import { Head, Link, router } from '@inertiajs/vue3';

export default {
  props: {
    cur_date: String,
    year: Number,
  },
  methods: {
    logout() {
      router.post(route("logout"));
    },
  },
};
</script>
<template>
  <div
    class="flex w-full bg-red-500 py-3 text-white text-xl font-bold justify-between"
  >
    <div class="px-3 py-3 shadow hover:shadow-inner">
      <a
        href="#"
      >
        カレンダー
      </a>
    </div>
    <div class="px-3 py-3 shadow hover:shadow-inner">
      今日：{{ cur_date }}
    </div>
    <div class="px-3 py-3 shadow hover:shadow-inner">
      {{ year }} 年
    </div>
    <div class="px-3 py-3 shadow hover:shadow-inner">
      <a>info</a>
    </div>
    <div class="px-3 py-3 shadow hover:shadow-inner">
      <form
        @submit.prevent="logout"
      >
        <button
          type="submit"
        >
          ログアウト
        </button>
      </form>
    </div>
  </div>
</template>

