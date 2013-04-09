class Weather
  init: () ->
    console.log "initializing"
    if !window.navigator.standalone
      if navigator.userAgent.match(/like Mac OS X/i)
        $('body').addClass('install').html('<div id="install"><div id="homescreen"><span></span><h2 id="add">Add to your <strong>Home Screen</strong></h2></div></div>');     
    else
      $('body').addClass('weather').html('Checking the weather...');
      @forcastURL = "http://weather-shaker.herokuapp.com/forcast/"
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
    @checkForecastURL = @forcastURL + '/' + localStorage.getItem("latitude1") + '/' + localStorage.getItem("longitude1")
    $.getJSON @checkForecastURL,
        (data) ->
          Weather::setupMainView(data)
          true
    true
  
  setupMainView: (data) ->
    console.log "setting up main View"
    console.log(data)
    $('body').addClass('weather').html('<canvas id="weather-icon" width="240" height="240"></canvas><h2>' + localStorage.getItem("city1") + '</h2><h1 class="temperature">' +  Weather::convertTemperature('c', data.currently.temperature)  + '°</h1>')
    Weather::addIcon("weather-icon", data.currently.icon)
    true
  
  setupSideMenu: () ->
    console.log "setting up sidemenu"
    true
  
  convertTemperature: (unit, degree) ->
    if @unit == 'f'
      return Math.round( ( degree * 1.8 ) + 32 )
    else
      return Math.round( ( degree - 32 ) / 1.8 )
    
  
  addIcon: (canvas, condition) ->
    console.log "adding icon"
    skycons = new Skycons({"color": "white"})
    switch condition
      when "clear-day" then skycons.add(canvas, Skycons.CLEAR_DAY)
      when "clear-night" then skycons.add(canvas, Skycons.CLEAR_NIGHT)
      when "partly-cloudy-day" then skycons.add(canvas, Skycons.PARTLY_CLOUDY_DAY)
      when "partly-cloudy-night" then skycons.add(canvas, Skycons.PARTLY_CLOUDY_NIGHT)
      when "cloudy" then skycons.add(canvas, Skycons.CLOUDY)
      when "rain" then skycons.add(canvas, Skycons.RAIN)
      when "sleet" then skycons.add(canvas, Skycons.SLEET)
      when "snow" then skycons.add(canvas, Skycons.SNOW)
      when "wind" then skycons.add(canvas, Skycons.WIND)
      when "fog" then skycons.add(canvas, Skycons.FOG)
    skycons.play()
    true
    
  

window.weather = new Weather

jQuery ->
  window.weather.init()


