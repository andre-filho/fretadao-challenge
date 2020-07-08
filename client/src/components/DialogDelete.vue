<template>
  <div>
    <v-btn
      icon
      dense
      color="error"
      @click.stop="dialog = true"
    >
      <v-icon small>fas fa-times</v-icon>
    </v-btn>

    <v-dialog v-model="dialog" max-width="350px">
      <v-card>
        <v-card-title class="headline">
          Delete profile
        </v-card-title>

        <v-card-text>
          You're about to delete {{ profile.name + "'s" }} profile from this
          application. Are you sure?
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>

          <v-btn text dense color="blue-grey" @click="dialog = false">
            cancel
          </v-btn>

          <v-btn
            depressed
            dense
            color="error"
            :loading="loading"
            @click="deleteProfile()"
          >
            <v-icon small left>fas fa-trash</v-icon> delete
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import Factory from '@/api/factory'

const ProfileAPI = Factory.getApi('profiles')

export default {
  name: 'DialogForm',

  data () {
    return {
      dialog: false,
      loading: false,
      errors: []
    }
  },

  props: {
    profile: {
      type: Object,
      required: true
    }
  },

  methods: {
    async deleteProfile () {
      await ProfileAPI.deleteProfile(this.profile.id)
        .then((res) => {
          // pass deleted profile info to parent
          this.$emit('deletedEvent')
          this.loading = false
          this.dialog = false
        })
        .catch((err) => {
          this.errors.push(err)
          this.loading = false
        })
    },

    delete () {
      this.loading = true
      this.deleteProfile()
    }
  }
}
</script>

<style lang="sass" scoped>

</style>
