class Weather
  init: () ->
    console.log "initializing"
    if !window.navigator.standalone
      if navigator.userAgent.match(/like Mac OS X/i)
        $('body').addClass('install').html('<div id="install"><div id="homescreen"><span></span><h2 id="add">Add to your <strong>Home Screen</strong></h2></div></div>')     
    else
      $('body').addClass('weather').html('<div id="container"><div id="frame"><div id="layer"><div class="slide"><h3>Checking the weather...</h3><div class="loading" /></div></div></div></div>')
      @yahooAppId = "pmQ_VnzV34FddFT6do_XVxcjzkrjmeKzNpJjLP1MqfPSEN6yCN0vunwBt8QbZYWEc65EPzD6o8VVmDYXTQZbPY0DkXSGUO4-"
      @yahooURL = "http://where.yahooapis.com/v1/places.q('[place')?appid=[appid]"
      @timezone = jstz.determine().name()
      @.setupCache()
      callback = (data) -> 
        $('body').html('<div id="container"><div id="sidebar"></div><div id="mainView"></div></div>')
        Weather::setupMainView(data, localStorage.getItem("city1"))
        Weather::setupSideMenu()
      @.checkForecast(localStorage.getItem("latitude1"), localStorage.getItem("longitude1"), callback)
      window.addEventListener('orientationchange', @.updateOrientation, false);
    true
  
  setupCache: () ->
    console.log "setting up cache"
    localStorage.clear()
    if localStorage.getItem("initialized") != "true"
      localStorage.setItem "initialized" , "true"
      localStorage.setItem "unit" , "c"
      localStorage.setItem "cityCount", 4

      localStorage.setItem "city1" , "Canterbury"
      localStorage.setItem "latitude1" , "51.275970"
      localStorage.setItem "longitude1" , "1.075610"

      localStorage.setItem "city2" , "London"
      localStorage.setItem "latitude2" , "51.506321"
      localStorage.setItem "longitude2" , "-0.127140"

      localStorage.setItem "city3" , "Cairo"
      localStorage.setItem "latitude3" , "30.049950"
      localStorage.setItem "longitude3" , "31.248600"

      localStorage.setItem "city4" , "New York"
      localStorage.setItem "latitude4" , "40.714550"
      localStorage.setItem "longitude4" , "-74.007118"

    true
  
  checkForecast: (latitude, longitude, callback) ->
    console.log "checking forecast "
    @checkForecastURL = "http://weathereye.co/forecast/"  + latitude + '/' + longitude
    $.getJSON(@checkForecastURL, callback)
    true
  
  setupMainView: (data, city) ->
    console.log "setting up main View"
    window.forecast = data
    unit = localStorage.getItem "unit"
    console.log(data)
    if unit == 'c'
      temperature = Weather::convertTemperature(unit, data.currently.temperature)
    else
      temperature = Math.round(data.currently.temperature)
    $('#mainView').html('<canvas id="weather-icon" width="140" height="140"></canvas><h2 id="theCity">' + city.toUpperCase() + '</h2><h1><span class="temperature">' +  temperature  + '</span><span>°</span></h1><ul id="daily"></ul>')
    Weather::addIcon("weather-icon", data.currently.icon)
    Weather::addDailyForecast(data.daily.data)
    true
  
  updateMainView: (data, city) ->
    console.log "updating up main View"
    window.forecast = data
    unit = localStorage.getItem "unit"
    console.log(data)
    if unit == 'c'
      temperature = Weather::convertTemperature(unit, data.currently.temperature)
    else
      temperature = Math.round(data.currently.temperature)
    $('#theCity').html(city.toUpperCase())
    oldTemp = $('span.temperature').html()
    container = $('span.temperature')
    Weather::updateTemperatures(container, oldTemp, temperature)
    Weather::addIcon("weather-icon", data.currently.icon)
    Weather::updateDailyForecast(data.daily.data)
    true
  
  updateDailyForecast: (daily) ->
    console.log "updating up daily forecast"
    unit = localStorage.getItem "unit"
    $.each(daily, (index, value) -> 
      if index in [1...6]
        if unit == 'c'
          min = Weather::convertTemperature(unit,@.temperatureMin)
          max = Weather::convertTemperature(unit,@.temperatureMax)
        else
          min = Math.round(@.temperatureMin)
          max = Math.round(@.temperatureMax)
        oldTemp = $('ul#daily li:nth-child('+index+') div.summary span.daily-temperature').html()
        newTemp = Weather::getDailyTemperature(min, max)
        container = $('ul#daily li:nth-child('+index+') div.summary span.daily-temperature')
        Weather::updateTemperatures(container, oldTemp, newTemp)
        )
  
  addDailyForecast: (daily) ->
    console.log "setting up daily forecast"
    unit = localStorage.getItem "unit"
    $.each(daily, (index, value) -> 
      if index in [1...6]
        if unit == 'c'
          min = Weather::convertTemperature(unit,@.temperatureMin)
          max = Weather::convertTemperature(unit,@.temperatureMax)
        else
          min = Math.round(@.temperatureMin)
          max = Math.round(@.temperatureMax)
        $('ul#daily').append('<li><canvas id="" height="30" width="30"></canvas><div class="day">'+Weather::getDay(@.time)+'</div><div class="summary"><span class="daily-temperature">' +Weather::getDailyTemperature(min, max)+'</span><span>°</span></div></li>')
        )
  
  setupSideMenu: () ->
    console.log "setting up sidemenu"
    Weather::setupSidemenuCities()
    $('#sidebar').append('<h2>Temperature</h2><ul id="temperature"><li><a href="#" ontouchstart="weather.changeTemperature(this)">fahrenheit</a></li><li><a href="#" ontouchstart="weather.changeTemperature(this)">celsius</a></li></ul>')
    @sidemenu = new SlidingView( 'sidebar', 'mainView' )
    @sidemenu.sidebarWidth = 220
    @sidemenu.sidebar.oriDomi({ hPanels: 1, vPanels: 2, speed:1, perspective:800, shadingIntensity:7 })
    @sidemenu.sidebar.oriDomi( 'accordion', 90 )
    self = @
    @sidemenu.sidebar.bind( "slidingViewProgress", (event, data) ->
	    fudge = 1
	    half = data.max/2
	    if data.current < half 
	      fudge = (data.current)/half
	    else if data.current > half
	      fudge = ( half - ( data.current- half) ) / half
	    fudge *= 15
	    angle = 90 - ( ( 90 * ( data.current/ data.max)))
	    af = angle + fudge
	    if af > 0
        self.sidemenu.sidebar.oriDomi 'restoreOriDomi' 
        self.sidemenu.sidebar.oriDomi 'accordion', af 
	    else
        self.sidemenu.sidebar.oriDomi 'restoreDOM' 
      true
    )
    true
  
  setupSidemenuCities: () ->
    $('#sidebar').html('<h2>Cities</h2><ul id="cities"></ul><input type="text" id="addCity"></input>')
    $("#addCity").keydown((event) ->
      if event.which == 13
        city = $('#addCity').val()
        console.log "adding city trigger with value " + city
        event.preventDefault()
        $('#addCity').blur()
        Weather::addCity($('#addCity').val())
        true
    )
    cityCount = localStorage.getItem 'cityCount'
    for count in [0...cityCount] by 1
      cityIndex = count + 1
      city = localStorage.getItem 'city' + cityIndex
      $('ul#cities').append('<li><a href="#" ontouchstart="weather.changeCity(this)">'+ city+'</a></li>')
      true
    true

  updateSidemenuCities: () ->
    cityCount = localStorage.getItem 'cityCount'
    $('ul#cities').html(' ')
    for count in [0...cityCount] by 1
      cityIndex = count + 1
      city = localStorage.getItem 'city' + cityIndex
      $('ul#cities').append('<li><a href="#" ontouchstart="weather.changeCity(this)">'+ city+'</a></li>')
      true
    true
  
  changeCity: (ref) ->
    cityID = $('ul#cities li').index($(ref).parent()) + 1
    $('ul#cities li.current').removeClass('current')
    $(ref).parent().addClass('current')
    city = localStorage.getItem('city'+cityID)
    latitude = localStorage.getItem('latitude'+ cityID)
    longitude = localStorage.getItem('longitude'+cityID)
    callback = (data) ->
      Weather::updateMainView(data, city)
      true
    Weather::checkForecast(latitude, longitude, callback)
    @.sidemenu.close()
    true
  
  addCity: () ->
    cityName = $('#addCity').val()
    callback = (data) ->
      oldCityCount = localStorage.getItem 'cityCount'
      newCityCount = parseInt(oldCityCount) + 1
      localStorage.setItem "cityCount", newCityCount
      localStorage.setItem "city" + newCityCount, data.city
      localStorage.setItem "latitude" + newCityCount, data.latitude
      localStorage.setItem "longitude" + newCityCount, data.longitude
      Weather::updateSidemenuCities()
      true
    addCityURL = 'http://weathereye.co/find/city/' + cityName
    $.getJSON(addCityURL, callback)
    true
    
  changeTemperature: (ref) ->
    unit = $('ul#temperature li').index($(ref).parent())
    $('ul#temperature li.current').removeClass('current')
    $(ref).parent().addClass('current')
    existingUnit = localStorage.getItem "unit"
    if unit == 0
      if existingUnit != "f"
        localStorage.setItem "unit" , "f"
        oldTemp = $('span.temperature').html()
        console.log oldTemp
        newTemp = Weather::convertTemperature("f", oldTemp)
        console.log newTemp
        container = $('span.temperature')
        console.log container
        Weather::updateTemperatures(container, oldTemp, newTemp)
        $('ul#daily li').each((index, element) ->
          container = $('div.summary span.daily-temperature', element)
          oldTemp = container.html()
          newTemp = Weather::convertTemperature("f", oldTemp)
          Weather::updateTemperatures(container, oldTemp, newTemp)
        )
    else if unit == 1
      if existingUnit != "c"
        localStorage.setItem "unit" , "c"
        oldTemp = $('span.temperature').html()
        console.log oldTemp
        newTemp = Weather::convertTemperature("c", oldTemp)
        console.log newTemp
        container = $('span.temperature')
        Weather::updateTemperatures(container, oldTemp, newTemp)
        $('ul#daily li').each((index, element) ->
          container = $('div.summary span.daily-temperature', element)
          oldTemp = container.html()
          newTemp = Weather::convertTemperature("c", oldTemp)
          Weather::updateTemperatures(container, oldTemp, newTemp)
        )
    @.sidemenu.close()
    true

  
  updateTemperatures: (container, oldTemp, newTemp) ->
    oldTemp = parseInt(oldTemp)
    newTemp = parseInt(newTemp)
    container.countTo
        from: oldTemp,
        to: newTemp,
        speed: 700
    true
  convertTemperature: (unit, degree) ->
    if unit == 'f'
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
  updateOrientation: () ->
    switch window.orientation
      when 0 then console.log Weather::hideLandscapeView()
      when 90 then console.log Weather::showLandscapeView()
      when -90 then console.log Weather::showLandscapeView()
    true
  showLandscapeView: () ->
    $('body').addClass('hide')
  hideLandscapeView: () ->
    $('body').removeClass('hide')
window.weather = new Weather

jQuery ->
  window.weather.init()
  
  true