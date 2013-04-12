class Weather
  init: () ->
    console.log "initializing"
    if !window.navigator.standalone
      if navigator.userAgent.match(/like Mac OS X/i)
        $('body').addClass('install').html('<div id="install"><div id="homescreen"><span></span><h2 id="add">Add to your <strong>Home Screen</strong></h2></div></div>');     
    else
      $('body').addClass('weather').html('<div id="container"><div id="frame"><div id="layer"><div class="slide"><h3>Checking the weather...</h3><div class="loading" /></div></div></div></div>');
      @forcastURL = "http://weathereye.co/forcast/"
      @yahooAppId = "pmQ_VnzV34FddFT6do_XVxcjzkrjmeKzNpJjLP1MqfPSEN6yCN0vunwBt8QbZYWEc65EPzD6o8VVmDYXTQZbPY0DkXSGUO4-"
      @yahooURL = "http://where.yahooapis.com/v1/places.q('[place')?appid=[appid]"
      @timezone = jstz.determine().name()
      this.setupCache()
      this.checkForecast()
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
    @checkForecastURL = @forcastURL  + localStorage.getItem("latitude1") + '/' + localStorage.getItem("longitude1")
    $.getJSON @checkForecastURL,
        (data) ->
          Weather::setupMainView(data)
          true
    true
  
  setupMainView: (data) ->
    console.log "setting up main View"
    window.forecast = data
    console.log(data)
    $('body').addClass('weather').html('<div id="container"><div id="sidebar"></div><div id="mainView"><canvas id="weather-icon" width="140" height="140"></canvas><h2>' + localStorage.getItem("city1").toUpperCase() + '</h2><h1 class="temperature">' +  Weather::convertTemperature('c', data.currently.temperature)  + '°</h1><ul id="daily"></ul></div></div>')
    Weather::addIcon("weather-icon", data.currently.icon)
    Weather::addDailyForecast(data.daily.data)
    @.setupSideMenu()
    true
  
  addDailyForecast: (daily) ->
    console.log "setting up daily forecast"
    $.each(daily, (index, value) -> 
      if index in [1...6]
        min = Weather::convertTemperature('c',@.temperatureMin)
        max = Weather::convertTemperature('c',@.temperatureMax)
        $('ul#daily').append('<li><canvas id="" height="30" width="30"></canvas><div class="day">'+Weather::getDay(@.time)+'</div><div class="summary">' +Weather::getDailyTemperature(min, max)+'°</div></li>')
        )
  
  setupSideMenu: () ->
    console.log "setting up sidemenu"
    $('#sidebar').html('<h2>Cities</h2><ul class="cities"><li><a href="#">CANTERBURY</a></li><li><a href="#">LONDON</a></li><li><a href="#">CAIRO</a></li></ul><h2>Temperature</h2><ul class="temperature"><li>fahrenheit</li><li>celsius</li></ul>')
    touchmoveCallback = (e)-> e.preventDefault() 
    document.getElementById('mainView').addEventListener('touchmove', touchmoveCallback, false)
    sidebar = new SlidingView( 'sidebar', 'mainView' )
    sidebar.sidebarWidth = 220;
    sidebar.sidebar.oriDomi({ hPanels: 1, vPanels: 2, speed:1, perspective:800, shadingIntensity:7 })
    sidebar.sidebar.oriDomi( 'accordion', 90 )
    sidebar.sidebar.bind( "slidingViewProgress", (event, data) ->
	    fudge = 1
	    half = data.max/2;
	    if data.current < half 
	      fudge = (data.current)/half
	    else if data.current > half
	      fudge = ( half - ( data.current- half) ) / half
	    fudge *= 15
	    angle = 90 - ( ( 90 * ( data.current/ data.max)))
	    af = angle + fudge
	    if af > 0
        sidebar.sidebar.oriDomi 'restoreOriDomi' 
        sidebar.sidebar.oriDomi 'accordion', af 
	    else
        sidebar.sidebar.oriDomi 'restoreDOM' 
      true
    )
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
    leCanvas = document.getElementById(canvas)
    leCanvas.width = 280
    leCanvas.height = 280
    leCanvas.style.width = "140px"
    leCanvas.style.height = "140px"
    true
  
  getDailyTemperature: (min, max) ->
    max
  
  getDay: (timestamp) ->
    date = new Date(timestamp * 1000)
    dayNumber = date.getDay()
    switch dayNumber
      when 0 then "SUN"
      when 1 then "MON"
      when 2 then "TUES"
      when 3 then "WED"
      when 4 then "THURS"
      when 5 then "FRI"
      when 6 then "SAT"
      when 7 then "SUN"
  

window.weather = new Weather

jQuery ->
  window.weather.init()


