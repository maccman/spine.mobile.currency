Spine = require('spine')
$     = jQuery

class Currency extends Spine.Model
  @configure 'Currency', 'name', 'code', 'symbol', 'rate'

  @endpoint: 'http://currency-proxy.herokuapp.com/currencies'

  @fetch ->
    $.getJSON(@endpoint, (res) => @refresh(res, clear: true))
  
  # Create default
  @create(name: 'United States Dollar', code: 'USD', symbol: '$', rate: 1)
  @default: -> @first()

module.exports = Currency