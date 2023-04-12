<script>
  export default {
    data () {
      return {
        colorSettingDialog: false,

        myColorDialogData: {
          tag_id: null,
          tag_name: null,
          tag_note: null,
          tag_color: null,
        },
      }
    },

    props: {

    },

    components: {

    },

    methods: {
      myColorDelete(){
        axios.post(route('calendar.colorDelete'), {
          tag_id: this.myColorDialogData.tag_id,
          tag_name: this.myColorDialogData.tag_name,
          tag_note: this.myColorDialogData.tag_note,
          tag_color: this.myColorDialogData.tag_color,
        },
        {
          headers: {
            'Content-Type': 'application/json'
          }
        }).then((response) => {
          this.colorSettingDialog = false

          this.$parent.getDateBoard(0, true)
          this.$parent.getMyColor()
        }).catch(function (error) {

        })
      },

      myColorConfirm(){
        axios.post(route('calendar.colorUpdate'), {
          tag_id: this.myColorDialogData.tag_id,
          tag_name: this.myColorDialogData.tag_name,
          tag_note: this.myColorDialogData.tag_note,
          tag_color: this.myColorDialogData.tag_color,
        },
        {
          headers: {
            'Content-Type': 'application/json'
          }
        }).then((response) => {
          this.colorSettingDialog = false

          this.$parent.getDateBoard(0, true)
          this.$parent.getMyColor()
        }).catch(function (error) {
          console.log(error)
        })
      },


    },
  }
</script>

<template>
  <v-row justify="center">
    <v-dialog
      v-model="colorSettingDialog"
      persistent
      width="500px"
    >
      <v-card
       class="px-5"
      >
        <div
          class="flex justify-between"
        >
          <div
            class="text-h5 my-2"
          >
            <v-card-title>
              マイカラー設定
            </v-card-title>
          </div>
        </div>
        <v-text-field
          v-model="myColorDialogData.tag_name"
          label="カラー名"
          hide-details="auto"
          required
        ></v-text-field>
        <hr>
        <v-textarea
          v-model="myColorDialogData.tag_note"
          label="カラー説明"
          required
        ></v-textarea>
        <div>
          <v-select
            v-model="myColorDialogData"
            :items="this.$parent.myColorQuery"
            label="マイカラー設定"
            item-title="tag_name"
            item-value="tag_id"
            return-object
          >
          </v-select>
        </div>
        <div
          class="px-20 py-5"
        >
          <v-color-picker
            v-model="myColorDialogData.tag_color"
            elevation="5"
          ></v-color-picker>
        </div>
        <div>
          {{ myColorDialogData.tag_color }}
        </div>
        <div
          class="mt-5"
        >
          <hr>
        </div>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="grey-darken-5"
            variant="text"
            @click="colorSettingDialog = false"
          >
            閉じる
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn
            color="red-darken-1"
            variant="text"
            @click="myColorDelete"
          >
            削除
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn
            color="green-darken-1"
            variant="text"
            @click="myColorConfirm"
          >
            確定
          </v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

