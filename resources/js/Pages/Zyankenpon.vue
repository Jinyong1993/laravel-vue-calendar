
<template>
  <div class="zyankenpon">
    <button
      style="background-color: coral;"
      type="button"
      v-bind:value="scissors"
      @click="processing(scissors)"
    >
      チョキ
    </button>
    <button
      style="background-color: aquamarine;"
      type="button"
      v-bind:value="rock"
      @click="processing(rock)"
    >
      グー
    </button>
    <button
      style="background-color: greenyellow;"
      type="button"
      v-bind:value="papper"
      @click="processing(papper)"
    >
      パー
    </button>
  </div><br>

  <div
    style="text-align: center;
    font-weight: bold;"
  >
    相手：{{ results.random }}
  </div><br>

  <div
    style="text-align: center;
    font-weight: bold;"
  >
    ジャンケンポン結果
  </div>
  <div
    style="text-align: center;
    font-weight: bold;"
  >
    {{ results.judge }}
  </div><br>

  <template>
    <div>
      <table
        style="border: 1px;
        border-style: solid;"
      >
        <thead>
          <tr>
            <th>{{ results.judge }}</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>{{ results.random }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </template>
</template>

<script>
  export default {
    data() {
      return {
        scissors: 1,
        rock: 2,
        papper: 3,
        results: {
          random: null,
          judge: null,
        },
      }
    },
    methods: {
      processing(value) {
        var ran_arr = [1, 2, 3]
        var judge = ['無勝負', '勝ち', '負け']
        var random = Math.floor( Math.random() * ran_arr.length + 1);

        if(random == 1) {
          this.results.random = 'チョキ'
        } else if(random == 2) {
          this.results.random = 'グー'
        } else {
          this.results.random = 'パー'
        }

        if(value == random) {
          return this.results.judge = judge[0]
        }

        switch(value){
          case 1 :
            if(random == 3){
              return this.results.judge = judge[1]
            } else {
              return this.results.judge = judge[2]
            }

          case 2 :
            if(random == 1){
              return this.results.judge = judge[1]
            } else {
              return this.results.judge = judge[2]
            }

          case 3 :
            if(random == 2){
              return this.results.judge = judge[1]
            } else {
              return this.results.judge = judge[2]
            }
        }
      },
    },
  }
</script>

<style scoped>
.zyankenpon button {
  border-color: black;
  border-width: 2px;
  width: 100%;
  text-align: center;
  padding: 20px;
  font-size: xx-large;
  color: white;
  font-weight: bold;
  text-shadow: 1px 1px 0 black,-1px 1px 0 black,1px -1px 0 black,-1px -1px 0 black;
  margin: 5px;
}
</style>
