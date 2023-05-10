<script>
import SvgIcon from '@jamescoyle/vue-icon';
import { mdiArrowUpThin } from '@mdi/js';
import { mdiArrowDownThin } from '@mdi/js';

  export default {
    data () {
      return {

      }
    },

    props: [
      'modelValue', // v-model default
      'sortName',
    ],

    emits: [
      'update:modelValue',
    ],

    components: {
      SvgIcon,
    },

    methods: {
      onClick() {
        // value = sort
        this.value = {
          name: this.sortName,
          order: this.selected && this.modelValue.order == 'desc' ? 'asc' : 'desc'
        }
      }
    },

    computed: {
      value: {
          get() {
            return this.modelValue
          },
          set(value) {
            this.$emit('update:modelValue', value)
          }
      },
      selected() {
        return this.modelValue.name == this.sortName
      },
      path() {
        return !this.selected || this.modelValue.order == 'asc' ? mdiArrowUpThin : mdiArrowDownThin
      },
      color() {
        return this.selected ? 'black' : 'lightgrey'
      },

    },
  }
</script>

<template>
  <v-btn
    class="px-1"
    variant="text"
    size="xs-small"
    @click="onClick"
  >
    <svg-icon
      type="mdi"
      :path="path"
      :color="color"
    ></svg-icon>
  </v-btn>
</template>

