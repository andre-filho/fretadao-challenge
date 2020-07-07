<template>

  <v-list two-line>
    <v-subheader>Search results for: "{{ search }}"</v-subheader>

    <v-list-item
      v-for="profile in results"
      :key="profile.username"
    >
      <v-list-item-avatar>
        <v-img :src="profile.image_url"></v-img>
      </v-list-item-avatar>

      <v-list-item-content>
        <v-list-item-title class="text-capitalize" v-text="profile.name"/>
        <v-list-item-title class="grey--text" v-text="profile.username"/>
        <v-list-item-subtitle>
          <a
            class="text-decoration-none"
            :href="profile.url"
          >
            <v-icon small>fab fa-github</v-icon> {{ profile.url }}
          </a>
        </v-list-item-subtitle>
      </v-list-item-content>

      <v-list-item-action>
        <v-row dense>
          <v-col>
            <v-btn
              icon
              dense
            >
              <v-icon small>fas fa-edit</v-icon>
            </v-btn>
          </v-col>
          <v-col>
            <v-btn
              icon
              dense
              :to="{ name: 'profileView', params: { id: profile.id }}"
            >
              <v-icon small>fas fa-eye</v-icon>
            </v-btn>
          </v-col>
        </v-row>
      </v-list-item-action>

    </v-list-item>
  </v-list>

</template>

<script>
export default {
  name: 'ResultsList',

  props: {
    results: Array,
    search: String
  }
}
</script>

<style lang="scss" scoped>

</style>
