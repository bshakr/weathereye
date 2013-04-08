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
        this.forcastURL = "http://weather-shaker.herokuapp.com/forecast/";
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
      console.log(data);
      $('body').addClass('weather').html('<h2>' + data.currently.summary + '</h2><h1>' + data.currently.temperature + '</h1><p>' + localStorage.getItem("city1") + '</p>');
      return true;
    };

    Weather.prototype.setupSideMenu = function() {
      console.log("setting up sidemenu");
      return true;
    };

    Weather.prototype.convertUnits = function(unit, degree) {
      if (this.unit === 'f') {
        return Math.round((degree * 1.8) + 32);
      } else {
        return Math.round((degree - 32) / 1.8);
      }
    };

    return Weather;

  })();

  window.weather = new Weather;

  jQuery(function() {
    return window.weather.init();
  });

}).call(this);
