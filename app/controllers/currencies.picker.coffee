Spine    = require('spine')
{Panel}  = require('spine.mobile')
Currency = require('models/currency')

class CurrenciesPicker extends Panel
  title: 'Currencies'
  
  className:
    'currenciesPicker list'
  
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
    Currency.unbind('refresh change', @render)
    @content.queueNext =>
      @destroy()
      
module.exports = CurrenciesPicker