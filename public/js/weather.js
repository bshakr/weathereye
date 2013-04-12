// Generated by CoffeeScript 1.3.3
(function() {
  var Weather,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Weather = (function() {

    function Weather() {}

    Weather.prototype.init = function() {
      console.log("initializing");
      if (!window.navigator.standalone) {
        if (navigator.userAgent.match(/like Mac OS X/i)) {
          $('body').addClass('install').html('<div id="install"><div id="homescreen"><span></span><h2 id="add">Add to your <strong>Home Screen</strong></h2></div></div>');
        }
      } else {
        $('body').addClass('weather').html('<div id="container"><div id="frame"><div id="layer"><div class="slide"><h3>Checking the weather...</h3><div class="loading" /></div></div></div></div>');
        this.forcastURL = "http://weathereye.co/forcast/";
        this.yahooAppId = "pmQ_VnzV34FddFT6do_XVxcjzkrjmeKzNpJjLP1MqfPSEN6yCN0vunwBt8QbZYWEc65EPzD6o8VVmDYXTQZbPY0DkXSGUO4-";
        this.yahooURL = "http://where.yahooapis.com/v1/places.q('[place')?appid=[appid]";
        this.timezone = jstz.determine().name();
        this.setupCache();
        this.checkForecast();
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
        localStorage.setItem("city2", "Cairo");
        localStorage.setItem("latitude2", "30.049950");
        localStorage.setItem("longitude2", "31.248600");
        localStorage.setItem("city3", "New York");
        localStorage.setItem("latitude3", "40.714550");
        localStorage.setItem("longitude3", "-74.007118");
      }
      return true;
    };

    Weather.prototype.checkForecast = function() {
      console.log("checking forecast ");
      this.checkForecastURL = this.forcastURL + localStorage.getItem("latitude1") + '/' + localStorage.getItem("longitude1");
      $.getJSON(this.checkForecastURL, function(data) {
        Weather.prototype.setupMainView(data);
        return true;
      });
      return true;
    };

    Weather.prototype.setupMainView = function(data) {
      console.log("setting up main View");
      window.forecast = data;
      console.log(data);
      $('body').addClass('weather').html('<div id="container" class="slidingview_wrapper"><div id="sidebar"></div><div id="mainView"><canvas id="weather-icon" width="140" height="140"></canvas><h2>' + localStorage.getItem("city1").toUpperCase() + '</h2><h1 class="temperature">' + Weather.prototype.convertTemperature('c', data.currently.temperature) + '°</h1><ul id="daily"></ul></div></div>');
      Weather.prototype.addIcon("weather-icon", data.currently.icon);
      Weather.prototype.addDailyForecast(data.daily.data);
      this.setupSideMenu();
      return true;
    };

    Weather.prototype.addDailyForecast = function(daily) {
      console.log("setting up daily forecast");
      return $.each(daily, function(index, value) {
        var max, min;
        if (__indexOf.call([1, 2, 3, 4, 5], index) >= 0) {
          min = Weather.prototype.convertTemperature('c', this.temperatureMin);
          max = Weather.prototype.convertTemperature('c', this.temperatureMax);
          return $('ul#daily').append('<li><canvas id="" height="30" width="30"></canvas><div class="day">' + Weather.prototype.getDay(this.time) + '</div><div class="summary">' + Weather.prototype.getDailyTemperature(min, max) + '°</div></li>');
        }
      });
    };

    Weather.prototype.setupSideMenu = function() {
      var sidebar;
      console.log("setting up sidemenu");
      sidebar = new SlidingView('sidebar', 'mainView');
      sidebar.sidebarWidth = 220;
      sidebar.sidebar.oriDomi({
        hPanels: 1,
        vPanels: 2,
        speed: 1,
        perspective: 800,
        shadingIntensity: 7
      });
      sidebar.sidebar.oriDomi('accordion', 90);
      sidebar.sidebar.bind("slidingViewProgress", function(event, data) {
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
          sidebar.sidebar.oriDomi('restoreOriDomi');
          sidebar.sidebar.oriDomi('accordion', af);
        } else {
          sidebar.sidebar.oriDomi('restoreDOM');
        }
        return true;
      });
      $('#sidebar').html('<h1>Cities</h1><ul class="cities"><li><a href="#">CANTERBURY</a></li><li><a href="#">LONDON</a></li><li><a href="#">CAIRO</a></li></ul>');
      return true;
    };

    Weather.prototype.convertTemperature = function(unit, degree) {
      if (this.unit === 'f') {
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
