<template>
  <div class="grey lighten-3 py-md-8 py-sm-4">

    <v-container>
      <div
        class="text-h4 grey--text lighten-1 text-center py-md-10 py-sm-3"
        v-if="searchResults.length === 0"
      >
        No results found
      </div>

      <results-list v-else
        :search="searchString"
        :results="searchResults"
        @updatedProfile="makeSearch"
      />
    </v-container>

  </div>
</template>

<script>
export default {

}
</script>

<style lang="scss" scoped>

</style>
