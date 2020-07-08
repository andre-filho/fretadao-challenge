<template>
  <v-app>
    <v-app-bar
      app
      dense
      dark
      color="blue-grey"
      class="px-3"
    >
      <div class="d-flex align-center">
        <v-btn
          depressed
          dense
          color="blue-grey"
          :to="{ name: 'home' }"
        >
          THE PROFILE INDEXER
        </v-btn>
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

    <v-main>
      <router-view/>
    </v-main>
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
