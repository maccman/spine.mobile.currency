Spine = require('spine')
$     = jQuery

class Currency extends Spine.Model
  @configure 'Currency', 'name', 'code', 'symbol', 'rate'

  @extend Spine.Model.Local

  @endpoint: 'http://currency-proxy.herokuapp.com/currencies'
  
  @fetch ->
    $.getJSON @endpoint, (res) => 
      @refresh(res, clear: true)
      @saveLocal()
  
  # Create default
  @default: -> new @(name: 'United States Dollar', code: 'USD', symbol: '$', rate: 1)

module.exports = Currency