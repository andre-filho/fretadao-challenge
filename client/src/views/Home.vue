<template>

  <div id="home">
    <div class="mb-5">
      <v-container fluid>
        <div class="text-center mt-10 mb-5 py-2 grey--text text--darken-3">
          <span class="text-h1">
            <v-icon large class="grey--text text--darken-3">fab fa-github</v-icon>
          </span>
          <h1>
            Github profile indexer
          </h1>
          <h2 class="text-h4 text-subtitle-1">
            Find your favorite Github profiles here
          </h2>
        </div>

        <v-row>
          <v-col sm='8' offset-sm='2' md='6' offset-md='3'>
            <v-form>
              <v-row no-gutters>
                <v-col sm='10'>
                  <v-text-field
                    outlined
                    dense
                    :error-messages="errors.length > 0 ? 'Some errors occured with your request!' : null"
                    class="rounded-l rounded-r-0"
                    placeholder='Search by name, username, location, etc.'
                    v-model="searchString"
                  />
                </v-col>
                <v-col sm='2'>
                  <v-btn
                    color='primary'
                    class="py-5 rounded-r rounded-l-0"
                    :disabled="!searchString"
                    @click="searchUser()"
                  >
                    Search
                    <!-- <v-icon dense>
                      fas fa-search
                    </v-icon> -->
                  </v-btn>
                </v-col>
              </v-row>
            </v-form>
          </v-col>
        </v-row>

      </v-container>
    </div>

    <div class="grey lighten-3 py-md-8 py-sm-4">
      <v-container>
        <div
          class="text-h4 grey--text lighten-1 text-center py-md-10 py-sm-3"
          v-if="searchResults === undefined"
        >
          Use the search bar to search for users
        </div>

        <div
          class="text-h4 grey--text lighten-1 text-center py-md-10 py-sm-3"
          v-else-if="searchResults.length === 0"
        >
          No results found
        </div>

        <results-list v-else
          :search='searchString'
          :results="searchResults"
        />
      </v-container>
    </div>

  </div>

</template>

<script>
import ResultsList from '@/components/ResultsList'
import Factory from '@/api/factory'

const ProfilesAPI = Factory.getApi('profiles')

export default {
  name: 'Home',

  data () {
    return {
      searchString: undefined,
      searchResults: undefined,
      errors: []
    }
  },

  components: {
    ResultsList
  },

  methods: {
    searchUser () {
      ProfilesAPI.search(this.searchString)
        .then((res) => {
          this.searchResults = res.data
        })
        .catch((err) => {
          this.errors.push(err)
        })
    }
  }
}
</script>

<style lang="scss">
</style>
