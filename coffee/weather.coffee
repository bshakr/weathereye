class Weather
  init: () ->
    console.log "initializing"
    @forcastApikey = "0fe656d926f844bc4c0745ac4ea9814f"
    @yahooAppId = "pmQ_VnzV34FddFT6do_XVxcjzkrjmeKzNpJjLP1MqfPSEN6yCN0vunwBt8QbZYWEc65EPzD6o8VVmDYXTQZbPY0DkXSGUO4-"
    @yahooURL = "http://where.yahooapis.com/v1/places.q('[place')?appid=[appid]"
    this.setupCache()
    this.checkForecast()
    this.setupMainView()
    this.setupSideMenu()
    true
  setupCache: () ->
    console.log "setting up cache"
    if localStorage.getItem "initialized" != "false"
      localStorage.setItem "initialized" , "false"
      localStorage.setItem "unit" , "c"
      localStorage.setItem "city1" , "Canterbury"
      localStorage.setItem "city2" , "Cairo"
      localStorage.setItem "city3" , "New York"
      
    true
  
  checkForecast: () ->
    console.log "checking forecast "
    true
  
  setupMainView: () ->
    console.log "setting up main View"
    true
  
  setupSideMenu: () ->
    console.log "setting up sidemenu"
    true
  

window.weather = new Weather

jQuery ->
  window.weather.init()


