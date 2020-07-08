import API from './api'

const endpointRoot = '/profiles'

const ProfilesAPI = {
  search (query) {
    return API.get(`${endpointRoot}/search/?query=${query}`)
  },

  getProfile (id) {
    return API.get(`${endpointRoot}/${id}/`)
  },

  updateProfile (id, profile) {
    return API.put(`${endpointRoot}/${id}/`, profile)
  },

  deleteProfile (id) {
    return API.delete(`${endpointRoot}/${id}/`)
  }
}

export default ProfilesAPI
