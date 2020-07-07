import ProfilesAPI from './profiles-api'

const apiList = {
  profiles: ProfilesAPI
}

const Factory = {
  getApi: (target) => apiList[target]
}

export default Factory
