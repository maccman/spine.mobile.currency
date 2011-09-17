Spine = require('spine')
$     = jQuery

class Currency extends Spine.Model
  @configure 'Currency', 'name', 'code', 'symbol', 'rate'

  @default: -> 
    new @(name: 'United States Dollar', code: 'USD', symbol: '$', rate: 1)
  
  @endpoint: 'http://currency-proxy.herokuapp.com/currencies'
  @fetch ->
    $.getJSON(@endpoint, (res) => @refresh(res, clear: true))

module.exports = Currency