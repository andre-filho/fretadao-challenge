<template>

  <div id="home">
    <div>
      <v-container fluid>
        <v-row>
          <v-spacer/>
          <v-col md='6'>
            <v-form>
              <v-row>
                <v-col sm='10'>
                  <v-text-field
                    outlined
                    dense
                    placeholder='Search for github users by name, username, organizations and more'
                    v-model="searchString"
                  />
                </v-col>
                <v-col sm='2'>
                  <v-btn
                    color='primary'
                    :disabled="!searchString"
                    @click="searchUser()"
                  >
                    <v-icon dense>
                      fas fa-search
                    </v-icon>
                  </v-btn>
                </v-col>
              </v-row>
            </v-form>
          </v-col>
          <v-spacer/>
        </v-row>
      </v-container>
    </div>

    <div class="bg-darken">
      <v-container fluid>
        <results-list />
      </v-container>
    </div>

  </div>

</template>

<script>
import axios from 'axios'
import ResultsList from '@/components/ResultsList'

export default {
  name: 'Home',

  data () {
    return {
      searchString: undefined,
      searchResults: [],
      errors: []
    }
  },

  components: {
    ResultsList
  },

  methods: {
    async searchUser () {
      await axios
        .get('http://0.0.0.0:3000/api/v1/profiles/')
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
