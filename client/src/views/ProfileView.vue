<template>
  <div>
    {{ profile }}
  </div>
</template>

<script>
import Factory from '@/api/factory'

const ProfilesAPI = Factory.getApi('profiles')

export default {
  name: 'ProfileView',

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

    getProfile () {
      ProfilesAPI.getProfile(this.$route.params.id)
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
