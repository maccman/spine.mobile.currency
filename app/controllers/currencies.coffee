Spine    = require('spine')
{Panel}  = require('spine.mobile')
Currency = require('models/currency')

class CurrenciesList extends Panel
  title: 'Currencies'
  
  className:
    'currencies list'
  
  events:
    'tap .content .item': 'click'
  
  constructor: (@controller, @callback) ->
    super()
    @addButton('Back', @back)
    Currency.bind('refresh change', @render)
    @render()
    @active(trans: 'right')
    
  render: =>
    items = Currency.all()
    @html require('views/currency/item')(items)
    
  click: (e) ->
    item = $(e.currentTarget).item()
    @callback?(item)
    @back()
    
  back: ->
    @controller.active(trans: 'left')

  # Cleanup panel once it's deactivated
  deactivate: ->
    super
    @content.queueNext =>
      @destroy()

class Currencies extends Panel
  className:
    'currencies'
    
  elements:
    '.input h1': 'inputEl'
    '.output h1': 'outputEl'
    
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
    @setRate()
    
    @active()
    Currency.fetch()

  setRate: ->
    @rate = (@from.rate * (1 / @to.rate)).toFixed(4)
  
  render: =>
    # Calculate currency conversion
    @output = @input and (@input * @rate).toFixed(2) or 0
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
    new CurrenciesList @, (res) => 
      @from = res
      @setRate()
      @render()
    
  changeTo: ->
    new CurrenciesList @, (res) => 
      @to = res
      @setRate()
      @render()
      
  flip: ->
    [@to, @from] = [@from, @to]
    @setRate()
    @render()

  helper:
    format: (num, addPoint) ->
      num = num.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",")
      num + (addPoint and '.' or '')
    
module.exports = Currencies