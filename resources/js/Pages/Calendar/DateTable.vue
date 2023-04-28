<script>
import SvgIcon from '@jamescoyle/vue-icon'
import { mdiPlusCircle } from '@mdi/js'

  export default {
    data () {
      return {
        path: mdiPlusCircle,
      }
    },

    props: [
      'dates',
      'year',
      'month',
      'query',
      'date_board',
      'is_list',
    ],
    emits: [
      'previous',
      'next',
      'plus',
      'event',
      'update:dateBoard',
    ],

    computed: {
      dateBoard: {
        get() {
          return this.date_board
        },
        set(value) {
          this.$emit('update:dateBoard', value);
        }
      }
    },

    components: {
      SvgIcon,
    },

    methods: {

    },
  }
</script>

<template>
  <div
    class="flex text-center mb-7"
  >
    <div class="flex-grow"></div>
    <button
      class="bg-indigo-600 font-semibold text-white py-2 px-10 rounded shadow-lg shadow-indigo-500/50"
      @click="$emit('previous', true)"
    >
      先月
    </button>
    <div class="flex-grow"></div>
    <div
      class="flex-grow text-5xl font-extrabold text-sky-500"
    >
      {{ month+1 }} 月
    </div>
    <div class="flex-grow"></div>
    <button
      class="bg-indigo-600 font-semibold text-white py-2 px-10 rounded shadow-lg shadow-indigo-500/50"
      @click="$emit('next', true)"
    >
      来月
    </button>
    <div class="flex-grow"></div>
  </div>
  <div class="my-3">
    <table
      class="border-collapse border border-slate-500 w-full"
    >
      <thead>
        <tr>
          <template v-for="date in dates">
            <th
              class="border border-slate-600 h-8"
            >{{ date }}</th>
          </template>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="(week, w_idx) in dateBoard"
          :key="w_idx"
        >
          <td
            class="border border-slate-700 h-15 text-right pr-4 pb-10"
            style="vertical-align: top;"
            v-for="(day, d_idx) in week"
            :key="d_idx"
          >
            <template
              v-if="day.day"
            >
              <div
                class="flex"
              >
                <div
                  v-if="!is_list"
                >
                  <v-btn
                    color="green"
                    variant="text"
                    @click="$emit('plus', day.day)"
                  ><svg-icon type="mdi" :path="path"></svg-icon>
                  </v-btn>
                </div>
                <div class="flex-grow"></div>
                <div
                  class="mt-1"
                >
                  {{ day.day }}
                </div>
              </div>
            </template>
            <template
              v-if="query[day.day]"
            >
              <div
                v-for="event in query[day.day]"
                :key="event.event_id"
                v-show="!event.hidden"
              >
                <template
                  v-if="is_list"
                >
                  <button
                    class="bg-indigo-600 font-semibold text-white py-1 px-2 my-1 rounded"
                    :style="{backgroundColor: event.tag_color}"
                  >
                    {{ event.title }}
                  </button>
                </template>
                <template
                  v-else
                >
                  <button
                    :id="event.tag_id"
                    class="bg-indigo-600 font-semibold text-white py-1 px-2 my-1 rounded"
                    :style="{backgroundColor: event.tag_color}"
                    @click="$emit('event', event)"
                  >
                    {{ event.title }}
                  </button>
                </template>
              </div>
            </template>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

