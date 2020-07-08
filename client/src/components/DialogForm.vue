<template>
  <div>
    <v-btn
      icon
      dense
      color="blue-grey"
      @click.stop="dialog = true"
    >
      <v-icon small>fas fa-edit</v-icon>
    </v-btn>

    <v-dialog v-model="dialog" max-width="600px">
      <v-card>
        <v-card-title>
          <span class="headline">
            Edit profile
          </span>
        </v-card-title>

        <v-card-text>
          <v-container>
            <div
              v-if="errors.length > 0"
            >
              <v-alert
                v-for="err in errors"
                :key="err.id"
                dense
                dismissible
                type="error"
              >
                {{ err }}
              </v-alert>
            </div>

            <v-row>
              <v-col cols="12">
                <v-text-field
                  dense
                  outlined
                  required
                  label="Name"
                  hint="Leave unchanged to keep the previous value"
                  :placeholder="name"
                  v-model="name"
                />
              </v-col>
              <v-col cols="12">
                <v-text-field
                  dense
                  outlined
                  required
                  label="Github URL"
                  hint="Leave unchanged to keep the previous value"
                  :placeholder="url"
                  v-model="url"
                />
                <!-- <v-text-field
                  dense
                  outlined
                  required
                  label="Github URL"
                  placeholder='nanananana'
                  prefix='https://github.com/'
                /> -->
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions class="pb-6 px-6">
          <v-spacer></v-spacer>
          <v-btn
            text
            color="blue-grey"
            @click="dialog = false"
          >
            Close
          </v-btn>
          <v-btn
            depressed
            dark
            color="blue-grey"
            :loading="loading"
            @click="update()"
          >
            <v-icon small left>fas fa-save</v-icon> Save
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
      name: '',
      url: '',
      dialog: false,
      loading: false,
      errors: []
    }
  },

  props: {
    type: String,
    profile: {
      type: Object,
      required: true
    }
  },

  methods: {
    async editProfile () {
      const profileData = {
        name: this.name,
        url: this.url
      }

      await ProfileAPI.updateProfile(this.profile.id, profileData)
        .then((res) => {
          this.name = res.data.name
          this.url = res.data.url

          const updatedProfile = res.data
          // pass updated profile info to parent
          this.$emit('updatedEvent', updatedProfile)
          this.loading = false
          this.dialog = false
        })
        .catch((err) => {
          this.errors.push(err)
          this.loading = false
        })
    },

    update () {
      this.loading = true
      this.editProfile()
    }
  },

  beforeMount () {
    this.name = this.profile.name
    this.url = this.profile.url
  }
}
</script>

<style lang="sass" scoped>

</style>
