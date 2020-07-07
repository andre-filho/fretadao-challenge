import API from './api'

const endpointRoot = '/profiles'

const ProfilesAPI = {
  search (query) {
    return API.get(`${endpointRoot}/search/?query=${query}`)
  },

  get (id) {
    return API.get(`${endpointRoot}/${id}/`)
  },

  update (id, profile) {
    return API.put(`${endpointRoot}/${id}/`, profile)
  },

  delete (id) {
    return API.delete(`${endpointRoot}/${id}/`)
  }
}

export default ProfilesAPI
