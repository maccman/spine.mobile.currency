Spine = require('spine')
$     = jQuery

class Currency extends Spine.Model
  @configure 'Currency', 'name', 'code', 'symbol', 'rate'

  @default: -> 
    new @(name: 'United States Dollar', code: 'USD', symbol: '$', rate: 1)
  
  @endpoint: 'http://currency-proxy.herokuapp.com/currencies'

  @fetch ->
    $.getJSON(@endpoint, (res) => @refresh(res, clear: true))
    
  load: ->
    super
    # USD Rate is always 1
    @rate = 1 if @code is 'USD'

module.exports = Currency