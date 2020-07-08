<template>
  <div>
    <div>
      <!-- src="https://baazarproductions.com/wp-content/uploads/2018/02/background-horizontal-dark-wood.jpg" -->
      <!-- src="https://cdn.vuetifyjs.com/images/backgrounds/vbanner.jpg" -->
      <v-container>
        <v-row
          align="center"
          justify="center"
        >
          <v-col class="text-center" cols="12">
            <v-avatar size="150" class="mb-5">
              <v-img
                :src="profile.image_url"
                lazy-src="https://via.placeholder.com/50.png"
              />
            </v-avatar>

            <h1 class="display-1  mb-4">
              {{ profile.name }}
            </h1>

            <h4 class="subheading">
              @{{ profile.username }}
            </h4>

            <div class="mt-5">
              <v-btn
                dense
                icon
                class="mx-2"
                :href="profile.url"
              >
                <v-icon small>fab fa-github</v-icon>
              </v-btn>

              <dialog-form :profile="profile" @updatedEvent="treatEvent"/>

              <v-btn
                dense
                icon
                class="mx-2"
                @click="deleteProfile()"
              >
                <v-icon small>fas fa-times</v-icon>
              </v-btn>
            </div>
          </v-col>
        </v-row>

      </v-container>
    </div>

  </div>
</template>

<script>
import Factory from '@/api/factory'

import DialogForm from '@/components/DialogForm'

const ProfilesAPI = Factory.getApi('profiles')

export default {
  name: 'ProfileView',

  components: { DialogForm },

  data () {
    return {
      profile: {},
      errors: []
    }
  },

  methods: {
    checkRouteGivenProfile () {
      if (this.$route.params.profile === undefined) {
        return false
      }
      this.profile = this.$route.params.profile
      return true
    },

    async getProfile () {
      await ProfilesAPI.getProfile(this.$route.params.id)
        .then((res) => {
          this.profile = res.data
        })
        .catch((err) => {
          this.errors.push(err)
          this.$router.push({
            name: 'home',
            params: { error: err }
          })
        })
    },

    treatEvent (value) {
      this.profile = value
    }
  },

  beforeMount () {
    if (!this.checkRouteGivenProfile()) {
      this.getProfile()
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
