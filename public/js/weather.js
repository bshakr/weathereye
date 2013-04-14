// Generated by CoffeeScript 1.3.3
(function() {
  var Weather,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Weather = (function() {

    function Weather() {}

    Weather.prototype.init = function() {
      var callback;
      console.log("initializing");
      if (!window.navigator.standalone) {
        if (navigator.userAgent.match(/like Mac OS X/i)) {
          $('body').addClass('install').html('<div id="install"><div id="homescreen"><span></span><h2 id="add">Add to your <strong>Home Screen</strong></h2></div></div>');
        }
      } else {
        $('body').addClass('weather').html('<div id="container"><div id="frame"><div id="layer"><div class="slide"><h3>Checking the weather...</h3><div class="loading" /></div></div></div></div>');
        this.yahooAppId = "pmQ_VnzV34FddFT6do_XVxcjzkrjmeKzNpJjLP1MqfPSEN6yCN0vunwBt8QbZYWEc65EPzD6o8VVmDYXTQZbPY0DkXSGUO4-";
        this.yahooURL = "http://where.yahooapis.com/v1/places.q('[place')?appid=[appid]";
        this.timezone = jstz.determine().name();
        this.setupCache();
        callback = function(data) {
          $('body').html('<div id="container"><div id="sidebar"></div><div id="mainView"></div></div>');
          Weather.prototype.setupMainView(data, localStorage.getItem("city1"));
          return Weather.prototype.setupSideMenu();
        };
        this.checkForecast(localStorage.getItem("latitude1"), localStorage.getItem("longitude1"), callback);
      }
      return true;
    };

    Weather.prototype.setupCache = function() {
      console.log("setting up cache");
      localStorage.clear();
      if (localStorage.getItem("initialized") !== "true") {
        localStorage.setItem("initialized", "true");
        localStorage.setItem("unit", "c");
        localStorage.setItem("city1", "Canterbury");
        localStorage.setItem("latitude1", "51.275970");
        localStorage.setItem("longitude1", "1.075610");
        localStorage.setItem("city2", "London");
        localStorage.setItem("latitude2", "51.506321");
        localStorage.setItem("longitude2", "-0.127140");
        localStorage.setItem("city3", "Cairo");
        localStorage.setItem("latitude3", "30.049950");
        localStorage.setItem("longitude3", "31.248600");
        localStorage.setItem("city4", "New York");
        localStorage.setItem("latitude4", "40.714550");
        localStorage.setItem("longitude4", "-74.007118");
      }
      return true;
    };

    Weather.prototype.checkForecast = function(latitude, longitude, callback) {
      console.log("checking forecast ");
      this.checkForecastURL = "http://weathereye.co/forecast/" + latitude + '/' + longitude;
      $.getJSON(this.checkForecastURL, callback);
      return true;
    };

    Weather.prototype.setupMainView = function(data, city) {
      var temperature, unit;
      console.log("setting up main View");
      window.forecast = data;
      unit = localStorage.getItem("unit");
      console.log(data);
      if (unit === 'c') {
        temperature = Weather.prototype.convertTemperature(unit, data.currently.temperature);
      } else {
        temperature = Math.round(data.currently.temperature);
      }
      $('#mainView').html('<canvas id="weather-icon" width="140" height="140"></canvas><h2 id="theCity">' + city.toUpperCase() + '</h2><h1><span class="temperature">' + temperature + '</span><span>°</span></h1><ul id="daily"></ul>');
      Weather.prototype.addIcon("weather-icon", data.currently.icon);
      Weather.prototype.addDailyForecast(data.daily.data);
      return true;
    };

    Weather.prototype.updateMainView = function(data, city) {
      var container, oldTemp, temperature, unit;
      console.log("updating up main View");
      window.forecast = data;
      unit = localStorage.getItem("unit");
      console.log(data);
      if (unit === 'c') {
        temperature = Weather.prototype.convertTemperature(unit, data.currently.temperature);
      } else {
        temperature = Math.round(data.currently.temperature);
      }
      $('#theCity').html(city.toUpperCase());
      oldTemp = $('span.temperature').html();
      container = $('span.temperature');
      Weather.prototype.updateTemperatures(container, oldTemp, temperature);
      Weather.prototype.addIcon("weather-icon", data.currently.icon);
      Weather.prototype.updateDailyForecast(data.daily.data);
      return true;
    };

    Weather.prototype.updateDailyForecast = function(daily) {
      var unit;
      console.log("updating up daily forecast");
      unit = localStorage.getItem("unit");
      return $.each(daily, function(index, value) {
        var container, max, min, newTemp, oldTemp;
        if (__indexOf.call([1, 2, 3, 4, 5], index) >= 0) {
          if (unit === 'c') {
            min = Weather.prototype.convertTemperature(unit, this.temperatureMin);
            max = Weather.prototype.convertTemperature(unit, this.temperatureMax);
          } else {
            min = Math.round(this.temperatureMin);
            max = Math.round(this.temperatureMax);
          }
          oldTemp = $('ul#daily li:nth-child(' + index + ') div.summary span.daily-temperature').html();
          newTemp = Weather.prototype.getDailyTemperature(min, max);
          container = $('ul#daily li:nth-child(' + index + ') div.summary span.daily-temperature');
          return Weather.prototype.updateTemperatures(container, oldTemp, newTemp);
        }
      });
    };

    Weather.prototype.addDailyForecast = function(daily) {
      var unit;
      console.log("setting up daily forecast");
      unit = localStorage.getItem("unit");
      return $.each(daily, function(index, value) {
        var max, min;
        if (__indexOf.call([1, 2, 3, 4, 5], index) >= 0) {
          if (unit === 'c') {
            min = Weather.prototype.convertTemperature(unit, this.temperatureMin);
            max = Weather.prototype.convertTemperature(unit, this.temperatureMax);
          } else {
            min = Math.round(this.temperatureMin);
            max = Math.round(this.temperatureMax);
          }
          return $('ul#daily').append('<li><canvas id="" height="30" width="30"></canvas><div class="day">' + Weather.prototype.getDay(this.time) + '</div><div class="summary"><span class="daily-temperature">' + Weather.prototype.getDailyTemperature(min, max) + '</span><span>°</span></div></li>');
        }
      });
    };

    Weather.prototype.setupSideMenu = function() {
      var self;
      console.log("setting up sidemenu");
      Weather.prototype.setupSidebarCities();
      $('#sidebar').append('<h2>Temperature</h2><ul id="temperature"><li><a href="#" ontouchstart="weather.changeTemperature(this)">fahrenheit</a></li><li><a href="#" ontouchstart="weather.changeTemperature(this)">celsius</a></li></ul>');
      this.sidemenu = new SlidingView('sidebar', 'mainView');
      this.sidemenu.sidebarWidth = 220;
      this.sidemenu.sidebar.oriDomi({
        hPanels: 1,
        vPanels: 2,
        speed: 1,
        perspective: 800,
        shadingIntensity: 7
      });
      this.sidemenu.sidebar.oriDomi('accordion', 90);
      self = this;
      this.sidemenu.sidebar.bind("slidingViewProgress", function(event, data) {
        var af, angle, fudge, half;
        fudge = 1;
        half = data.max / 2;
        if (data.current < half) {
          fudge = data.current / half;
        } else if (data.current > half) {
          fudge = (half - (data.current - half)) / half;
        }
        fudge *= 15;
        angle = 90 - (90 * (data.current / data.max));
        af = angle + fudge;
        if (af > 0) {
          self.sidemenu.sidebar.oriDomi('restoreOriDomi');
          self.sidemenu.sidebar.oriDomi('accordion', af);
        } else {
          self.sidemenu.sidebar.oriDomi('restoreDOM');
        }
        return true;
      });
      return true;
    };

    Weather.prototype.setupSidebarCities = function() {
      var city, cityCount, count, _i;
      $('#sidebar').html('<h2>Cities</h2><ul id="cities"></ul>');
      cityCount = localStorage.getItem('cityCount');
      for (count = _i = 1; _i < cityCount; count = _i += 1) {
        city = localStorage.getItem('city' + count);
        $('ul#cities').append('<li><a href="#" ontouchstart="weather.changeCity(this)">' + city + '</a></li>');
        true;
      }
      return true;
    };

    Weather.prototype.changeCity = function(ref) {
      var callback, city, cityID, latitude, longitude;
      cityID = $('ul#cities li').index($(ref).parent()) + 1;
      city = localStorage.getItem('city' + cityID);
      latitude = localStorage.getItem('latitude' + cityID);
      longitude = localStorage.getItem('longitude' + cityID);
      callback = function(data) {
        Weather.prototype.updateMainView(data, city);
        return true;
      };
      Weather.prototype.checkForecast(latitude, longitude, callback);
      this.sidemenu.close();
      return true;
    };

    Weather.prototype.addCity = function(ref) {
      var callback;
      return callback = function(data) {
        var newCityCount, oldCityCount;
        oldCityCount = localStorage.getItem('cityCount');
        newCityCount = oldCityCount + 1;
        localStorage.setItem("cityCount", newCityCount);
        localStorage.setItem("city" + newCityCount, data.city);
        localStorage.setItem("latitude" + newCityCount, data.latitude);
        return localStorage.setItem("longitude" + newCityCount, data.longitude);
      };
    };

    Weather.prototype.changeTemperature = function(ref) {
      var container, existingUnit, newTemp, oldTemp, unit;
      unit = $('ul#temperature li').index($(ref).parent());
      existingUnit = localStorage.getItem("unit");
      if (unit === 0) {
        if (existingUnit !== "f") {
          localStorage.setItem("unit", "f");
          $('ul#temperature li.current').removeClass("current");
          $(ref).parent().addClass("current");
          oldTemp = $('span.temperature').html();
          console.log(oldTemp);
          newTemp = Weather.prototype.convertTemperature("f", oldTemp);
          console.log(newTemp);
          container = $('span.temperature');
          console.log(container);
          Weather.prototype.updateTemperatures(container, oldTemp, newTemp);
          $('ul#daily li').each(function(index, element) {
            container = $('div.summary span.daily-temperature', element);
            oldTemp = container.html();
            newTemp = Weather.prototype.convertTemperature("f", oldTemp);
            return Weather.prototype.updateTemperatures(container, oldTemp, newTemp);
          });
        }
      } else if (unit === 1) {
        if (existingUnit !== "c") {
          localStorage.setItem("unit", "c");
          $('ul#temperature li.current').removeClass("current");
          $(ref).parent().addClass("current");
          oldTemp = $('span.temperature').html();
          console.log(oldTemp);
          newTemp = Weather.prototype.convertTemperature("c", oldTemp);
          console.log(newTemp);
          container = $('span.temperature');
          Weather.prototype.updateTemperatures(container, oldTemp, newTemp);
          $('ul#daily li').each(function(index, element) {
            container = $('div.summary span.daily-temperature', element);
            oldTemp = container.html();
            newTemp = Weather.prototype.convertTemperature("c", oldTemp);
            return Weather.prototype.updateTemperatures(container, oldTemp, newTemp);
          });
        }
      }
      this.sidemenu.close();
      return true;
    };

    Weather.prototype.updateTemperatures = function(container, oldTemp, newTemp) {
      oldTemp = parseInt(oldTemp);
      newTemp = parseInt(newTemp);
      container.countTo({
        from: oldTemp,
        to: newTemp,
        speed: 700
      });
      return true;
    };

    Weather.prototype.convertTemperature = function(unit, degree) {
      if (unit === 'f') {
        return Math.round((degree * 1.8) + 32);
      } else {
        return Math.round((degree - 32) / 1.8);
      }
    };

    Weather.prototype.addIcon = function(canvas, condition) {
      var leCanvas, skycons;
      console.log("adding icon");
      skycons = new Skycons({
        "color": "white"
      });
      switch (condition) {
        case "clear-day":
          skycons.add(canvas, Skycons.CLEAR_DAY);
          break;
        case "clear-night":
          skycons.add(canvas, Skycons.CLEAR_NIGHT);
          break;
        case "partly-cloudy-day":
          skycons.add(canvas, Skycons.PARTLY_CLOUDY_DAY);
          break;
        case "partly-cloudy-night":
          skycons.add(canvas, Skycons.PARTLY_CLOUDY_NIGHT);
          break;
        case "cloudy":
          skycons.add(canvas, Skycons.CLOUDY);
          break;
        case "rain":
          skycons.add(canvas, Skycons.RAIN);
          break;
        case "sleet":
          skycons.add(canvas, Skycons.SLEET);
          break;
        case "snow":
          skycons.add(canvas, Skycons.SNOW);
          break;
        case "wind":
          skycons.add(canvas, Skycons.WIND);
          break;
        case "fog":
          skycons.add(canvas, Skycons.FOG);
      }
      skycons.play();
      leCanvas = document.getElementById(canvas);
      leCanvas.width = 280;
      leCanvas.height = 280;
      leCanvas.style.width = "140px";
      leCanvas.style.height = "140px";
      return true;
    };

    Weather.prototype.getDailyTemperature = function(min, max) {
      return max;
    };

    Weather.prototype.getDay = function(timestamp) {
      var date, dayNumber;
      date = new Date(timestamp * 1000);
      dayNumber = date.getDay();
      switch (dayNumber) {
        case 0:
          return "SUN";
        case 1:
          return "MON";
        case 2:
          return "TUES";
        case 3:
          return "WED";
        case 4:
          return "THURS";
        case 5:
          return "FRI";
        case 6:
          return "SAT";
        case 7:
          return "SUN";
      }
    };

    return Weather;

  })();

  window.weather = new Weather;

  jQuery(function() {
    return window.weather.init();
  });

}).call(this);
