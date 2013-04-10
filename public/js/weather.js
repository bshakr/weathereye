// Generated by CoffeeScript 1.3.3
(function() {
  var Weather;

  Weather = (function() {

    function Weather() {}

    Weather.prototype.init = function() {
      console.log("initializing");
      if (!window.navigator.standalone) {
        if (navigator.userAgent.match(/like Mac OS X/i)) {
          $('body').addClass('install').html('<div id="install"><div id="homescreen"><span></span><h2 id="add">Add to your <strong>Home Screen</strong></h2></div></div>');
        }
      } else {
        $('body').addClass('weather').html('Checking the weather...');
        this.forcastURL = "http://weather-shaker.herokuapp.com/forcast/";
        this.yahooAppId = "pmQ_VnzV34FddFT6do_XVxcjzkrjmeKzNpJjLP1MqfPSEN6yCN0vunwBt8QbZYWEc65EPzD6o8VVmDYXTQZbPY0DkXSGUO4-";
        this.yahooURL = "http://where.yahooapis.com/v1/places.q('[place')?appid=[appid]";
        this.timezone = jstz.determine().name();
        this.setupCache();
        this.checkForecast();
        this.setupSideMenu();
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
      this.checkForecastURL = this.forcastURL + '/' + localStorage.getItem("latitude1") + '/' + localStorage.getItem("longitude1");
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
      $('body').addClass('weather').html('<canvas id="weather-icon" width="140" height="140"></canvas><h2>' + localStorage.getItem("city1").toUpperCase() + '</h2><h1 class="temperature">' + Weather.prototype.convertTemperature('c', data.currently.temperature) + '°</h1><ul id="daily"></ul>');
      Weather.prototype.addIcon("weather-icon", data.currently.icon);
      Weather.prototype.addDailyForecast(data.daily.data);
      return true;
    };

    Weather.prototype.addDailyForecast = function(daily) {
      var forecast, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = daily.length; _i < _len; _i++) {
        forecast = daily[_i];
        _results.push((function(forecast) {
          $('ul#daily').append('<li><canvas id="" height="30" width="30"></canvas><div class="day">' + forecast.time(+'</div><div class="summary">' + forecast.summary(+'</div></li>')));
          return true;
        })(forecast));
      }
      return _results;
    };

    Weather.prototype.setupSideMenu = function() {
      console.log("setting up sidemenu");
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

    return Weather;

  })();

  window.weather = new Weather;

  jQuery(function() {
    return window.weather.init();
  });

}).call(this);
