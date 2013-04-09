class Weather
  init: () ->
    console.log "initializing"
    if !window.navigator.standalone
      if navigator.userAgent.match(/like Mac OS X/i)
        $('body').addClass('install').html('<div id="install"><div id="homescreen"><span></span><h2 id="add">Add to your <strong>Home Screen</strong></h2></div></div>');     
    else
      $('body').addClass('weather').html('Checking the weather...');
      @forcastApikey = "0fe656d926f844bc4c0745ac4ea9814f"
      @forcastURL = "https://api.forecast.io/forecast/"
      @yahooAppId = "pmQ_VnzV34FddFT6do_XVxcjzkrjmeKzNpJjLP1MqfPSEN6yCN0vunwBt8QbZYWEc65EPzD6o8VVmDYXTQZbPY0DkXSGUO4-"
      @yahooURL = "http://where.yahooapis.com/v1/places.q('[place')?appid=[appid]"
      @timezone = jstz.determine().name()
      this.setupCache()
      this.checkForecast()
      this.setupSideMenu()
    true
  
  setupCache: () ->
    console.log "setting up cache"
    localStorage.clear()
    if localStorage.getItem("initialized") != "true"
      localStorage.setItem "initialized" , "true"
      localStorage.setItem "unit" , "c"

      localStorage.setItem "city1" , "Canterbury"
      localStorage.setItem "latitude1" , "51.275970"
      localStorage.setItem "longitude1" , "1.075610"

      localStorage.setItem "city2" , "Cairo"
      localStorage.setItem "latitude2" , "30.049950"
      localStorage.setItem "longitude2" , "31.248600"

      localStorage.setItem "city3" , "New York"
      localStorage.setItem "latitude3" , "40.714550"
      localStorage.setItem "longitude3" , "-74.007118"
    true
  
  checkForecast: () ->
    console.log "checking forecast "
    @checkForecastURL = @forcastURL + @forcastApikey + '/' + localStorage.getItem("latitude1") + ',' + localStorage.getItem("longitude1") + "&callback=?"
    $.getJSON @checkForecastURL,
        (data) ->
          Weather::setupMainView(data)
          true
    true
  
  setupMainView: (data) ->
    console.log "setting up main View"
    console.log(data)
    $('body').addClass('weather').html('<h2>' + data.currently.summary + '</h2><h1>' +  data.currently.temperature  + '</h1><p>' + localStorage.getItem("city1") + '</p>')
    true
  
  setupSideMenu: () ->
    console.log "setting up sidemenu"
    true
  
  convertUnits: (unit, degree) ->
    if @unit == 'f'
      return Math.round( ( degree * 1.8 ) + 32 )
    else
      return Math.round( ( degree - 32 ) / 1.8 )
    
  

window.weather = new Weather

jQuery ->
  window.weather.init()

