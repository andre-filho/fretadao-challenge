<template>
  <v-app>
    <v-app-bar
      app
      flat
      dense
      dark
      color="blue-grey"
      class="px-3"
    >
      <div class="d-flex align-center">
        THE PROFILE INDEXER
      </div>
      <v-spacer></v-spacer>

      <v-btn
        href="https://github.com/andre-filho/fretadao-challenge"
        target="_blank"
        icon
      >
        <v-icon>fab fa-github</v-icon>
      </v-btn>
    </v-app-bar>

    <v-content>
      <router-view/>
    </v-content>
  </v-app>
</template>

<script>

export default {
  name: 'App',

  data: () => ({
    //
  })
}
</script>
