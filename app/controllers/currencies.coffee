Spine            = require('spine')
{Panel}          = require('spine.mobile')
Currency         = require('models/currency')
CurrenciesPicker = require('controllers/currencies.picker')

class Currencies extends Panel
  className:
    'currencies'
    
  events:
    'touchstart .pad div': 'enter'
    'touchstart .pad .clear': 'clear'
    'touchstart .pad .point': 'point'
    'tap .input': 'changeFrom'
    'tap .output': 'changeTo'
    'tap .flip': 'flip'
    
  constructor: ->
    super
    @el.bind 'touchmove', (e) -> e.preventDefault()
    @from = @to = Currency.default()
    @clear()

  rate: ->
    @from.rate * (1 / @to.rate)
  
  render: =>
    # Calculate currency conversion
    @output = @input and (@input * @rate()).toFixed(2) or 0
    @html require('views/currency')(@)
    
  enter: (e) ->
    num = $(e.currentTarget).data('num')
    return unless num?
    
    # Stop overflows
    return if (@input + '').length  > 8 
    return if (@output + '').length > 8

    # Convert to string
    num += ''
    
    # Prefix with decimal
    if @addPoint
      @addPoint = false
      num = ".#{num}"
    
    # Simple way of combining numbers
    @input = parseFloat(@input + num)
    @render()
    
  clear: ->
    @input     = 0.0
    @output    = 0.0
    @addPoint = false
    @render()
    
  point: ->
    # Return if already has point
    return if @input % 1 isnt 0
    @addPoint = true
    @render()
    
  changeFrom: ->
    new CurrenciesPicker @, (res) => 
      @from = res
      @render()
    
  changeTo: ->
    new CurrenciesPicker @, (res) => 
      @to = res
      @render()
      
  flip: ->
    [@to, @from] = [@from, @to]
    @render()

  helper:
    format: (num, addPoint) ->
      num = num.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",")
      num + (addPoint and '.' or '')
    
module.exports = Currencies