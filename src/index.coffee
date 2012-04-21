html ->
  head ->
    script type:'text/javascript', src:'akihabara/gbox.js'
    script type:'text/javascript', src:'akihabara/iphopad.js'
    script type:'text/javascript', src:'akihabara/trigo.js'
    script type:'text/javascript', src:'akihabara/toys.js'
    script type:'text/javascript', src:'akihabara/help.js'
    script type:'text/javascript', src:'akihabara/tool.js'
    script type:'text/javascript', src:'akihabara/gamecycle.js'
    link rel:'stylesheet', href:'style.css'
    
    meta
      name:'viewport'
      content:'width:device-width; initial-scale:1.0; maximum-scale:1.0; user-scalable:0;'
  body ->
    div class:'directions', ->
      span 'MOVE: LEFT/RIGHT'
      br ''
      span 'SHOOT: Z/X'
  coffeescript ->
    frand = (min, max) -> min + Math.random()*(max-min)
    window.rand = (min, max) -> Math.round(frand(min, max))
    choose = (array) -> array[rand(0,array.length-1)]

    maingame = undefined

    loadResources = ->
      help.akihabaraInit
        title: 'TINY UNIVERSE (working title)'
        width: 320
        height: 200
        zoom: 2

      gbox.setFps 60

      gbox.addImage 'logo', 'logo.png'

      gbox.addImage 'ship0', 'ship0.png'
      gbox.addTiles
        id: 'ship0_tiles'
        image: 'ship0'
        tileh: 16
        tilew: 16
        tilerow: 4
        gapx: 0
        gapy: 0

      gbox.addImage 'font', 'font.png'
      gbox.addFont
        id: 'small'
        image: 'font'
        firstletter: '!'
        tileh: 16
        tilew: 16
        tilerow: 20
        gapx: 0
        gapy: 0
      gbox.loadAll main
    
    TURN_SPEED = 0.025
    ACC = 0.05
    DEC = 0.01
    addPlayer = ->
      gbox.addObject
        id: 'player_id'
        group: 'player'
        speed: 3
        bullets: []
        init: ->
          @frame = 0
          @tileset = 'ship0_tiles'
          @w = 16
          @h = 16
          @x = gbox.getScreenW()/2 - @w/2
          @y = gbox.getScreenH()/2 - @h/2
          @vx = 0
          @vy = 0
          @ang = Math.PI/3

        first: ->
          if gbox.keyIsPressed 'up'
            @vx += Math.cos(@ang) * ACC
            @vy += Math.sin(@ang) * ACC

          if gbox.keyIsPressed 'right'
            @ang += TURN_SPEED
          else if gbox.keyIsPressed 'left'
            @ang -= TURN_SPEED
          @x += @vx
          @y += @vy

          @vx *= 1-DEC
          @vy *= 1-DEC

        initialize: ->
          @init()

        blit: ->
          gbox.blitTile gbox.getBufferContext(),
            tileset: @tileset
            tile: @frame
            dx: Math.round @x
            dy: Math.round @y

    main = ->
      gbox.setGroups ['background', 'game', 'player']
      maingame = gamecycle.createMaingame('game', 'game')
      maingame.gameMenu = -> true
 
      maingame.gameIntroAnimation = -> true

      maingame.gameTitleIntroAnimation = ->
        gbox.blitFade gbox.getBufferContext(),
          alpha:1
        gbox.blitAll gbox.getBufferContext(), gbox.getImage('logo'),
          dx:1
          dy:1

        gbox.keyIsHit 'a'

      maingame.pressStartIntroAnimation = (reset) ->
        gbox.keyIsHit 'a'

      maingame.initializeGame = ->
        player = addPlayer()

        gbox.addObject
          id: 'bg_id'
          group: 'background'
          color: 'rgb(0,0,0)'
          blit: ->
            gbox.blitFade gbox.getBufferContext(),
              color:'black'
              alpha:1
      gbox.go()

    window.addEventListener 'load', loadResources, false
