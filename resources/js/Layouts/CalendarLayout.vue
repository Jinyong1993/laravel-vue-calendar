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
  <v-app>
    <div
      class="flex w-full bg-red-500 py-3 text-white text-xl font-bold justify-between"
    >
      <div class="px-3 py-3 shadow hover:shadow-inner">
        <inertia-link
          :href="route('calendar.list')"
        >カレンダー</inertia-link>
      </div>
      <div class="px-3 py-3 shadow hover:shadow-inner">
        <inertia-link
          :href="route('board.list')"
        >掲示板</inertia-link>
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

    <v-main>
      <v-container>
        <slot></slot>
      </v-container>
    </v-main>

  </v-app>
</template>

