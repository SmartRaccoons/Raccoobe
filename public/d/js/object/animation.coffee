window.o.ObjectAnimation = class ObjectAnimation

  _animation_reset: ->
    @_animations = {}

  position_animate: (position)->
    @_animation_add({value: position, steps: 100})

  _animate: ->
    for name, params of @_animations
      if params.length is 0
        delete @_animations[name]
        continue
      if params[0].steps is 0
        @_animations[name].shift()
        return
      params[0].steps--
      params[0].callback( params[0].easing((params[0].steps_total - params[0].steps)/params[0].steps_total)
      , params[0].steps)
    requestAnimationFrame => @_animate()

  _animation_add: (params)=>
    property = params.property or 'position'
    steps = params.steps or 30
    easing = params.easing or 'linear'
    name = params.name or "#{property}"
    if !@_animations[name]
      @_animations[name] = []
    value = params.value
    value_start = @[property]
    diff = value.map (v, i)-> v - value_start[i]
    callback = (m, steps)=>
      if steps is 0
        @["#{property}_set"](value)
        return @trigger "animation:#{property}:end"
      @["#{property}_set"]( diff.map( (v, i)-> value_start[i] + v * m  ) )

    @_animations[name].push {
      callback: callback
      steps: steps
      steps_total: steps
      easing: {
        'linear': (m)-> m
        'linearOut': (m)-> 1 - m
        'sin': (m)-> Math.sin(m * Math.PI/2)
        'sinOut': (m)-> Math.sin((1 - m) * Math.PI/2)
      }[easing]
    }
    @_animate()
