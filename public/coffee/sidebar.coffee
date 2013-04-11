class Sidebar
  constructor: (sidebarID, mainViewID) ->
    @gestureStarted = false
    @bodyOffset = 0
    @sidebarWidth = 150
    @sidebar = $('#'+sidebarID)
    @mainView = $('#'+mainViewID)
    @.setupEvents();
  
  setupEvents: () ->
    @START_EVENT = 'touchstart'
    @MOVE_EVENT = 'touchmove'
    @END_EVENT = 'touchend'
    
    body = @.body.get()[0]
    body.AddEventListener(@.START_EVENT, @.onTouchStart(event), false)
    true
  
  onTouchStart: (event) ->
     @.gestureStartPosition = @.getTouchCoordinates( event )
     self = @
     @.touchMoveHandler = (event) -> 
       self.onTouchMove(event)
       true
     true