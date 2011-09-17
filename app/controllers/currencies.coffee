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
    '.input':  'inputEl'
    '.output': 'outputEl'
    
  events:
    'tap .pad div': 'enter'
    'tap .pad .clear': 'clear'
    'tap .pad .point': 'point'
    'tap .input': 'changeFrom'
    'tap .output': 'changeTo'
    'tap .flip': 'flip'
    
  constructor: ->
    super
    @from = @to = Currency.default()
    
    # Cancel scrolling on main view
    @el.bind 'touchstart', (e) -> 
      e.preventDefault()
    
    @clear()
    @active()
    Currency.fetch()

  rate: ->
    @from.rate * (1 / @to.rate)
  
  render: =>
    # Calculate currency conversion
    @output = @input and (@input * @rate()).toFixed(2) or 0
    @html require('views/currency')(@)
    
  enter: (e) ->
    num = $(e.target).data('num')
    return unless num?
    
    return if @hasOverflow()
    
    # Convert to string
    num += ''
    
    # Prefix with decimal
    if @addPoint
      @addPoint = false
      num = ".#{num}"
    
    # Simple way of combining numbers
    @input = parseFloat(@input + num)
    @render()
    
  hasOverflow: ->
    (@input + '').length > 10 or
      (@output + '').length > 8
    
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
      @render()
    
  changeTo: ->
    new CurrenciesList @, (res) => 
      @to = res
      @render()
      
  flip: ->
    [@to, @from] = [@from, @to]
    @render()

  helper:
    format: (num, addPoint) ->
      re = /(\d+)(\d{3,3})/
      [num, decimals] = ('' + num).split('.')
      num = num.replace(re, '$1,$2') while re.test(num)
      num += ".#{decimals}" if decimals
      num += "." if addPoint
      num
    
module.exports = Currencies