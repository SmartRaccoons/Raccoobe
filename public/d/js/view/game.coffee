game = new window.o.Game()

window.o.ViewGame = class Game extends window.o.View
  className: 'game'
  template: """
        <div class='game-container'></div>
        <div class='game-controls'>
          <button class='game-controls-reset'>#{_l('Reset')}</button>
        </div>
  """

  events:
    'click .game-controls-reset': ->
      @trigger 'reset', {seconds_total: @_time()}

  constructor: ->
    super
    @_timeouts = []
    @load()

  load: ->
    @_timeouts.forEach (t)-> clearTimeout(t)
    @_timeouts = []
    @$el.removeClass("#{@className}-level-hide")
    @$el.attr('data-level', @options.stage)
    @_timeouts.push setTimeout =>
      @$el.addClass("#{@className}-level-hide")
      game.clear()
      game.bind 'solved', => @_solved()
      game.render({stage: @options.stage, container: @$('.game-container')})
      @_timer_start = new Date().getTime()
    , 800

  _solved: ->
    @trigger 'solved', {seconds_total: @_time()}
    @_timeouts.push setTimeout =>
      @trigger 'next'
    , 2000

  _time: -> Math.round((new Date().getTime() - @_timer_start) / 1000)

  remove: ->
    game.clear()
    super
