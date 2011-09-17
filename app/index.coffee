require('lib/setup')

$          = jQuery
Spine      = require('spine')
{Stage}    = require('spine.mobile')
Currencies = require('controllers/currencies')
Currency   = require('models/currency')

class App extends Stage.Global
  constructor: ->
    super
    
    # Activate controller
    @currencies = new Currencies
    @currencies.active()
    
    # Fetch remote currencies
    Currency.fetch()
    
    # Disable click events
    $('body').bind 'click', (e) -> 
      e.preventDefault()
    
    $('body').bind 'orientationchange', (e) ->
      orientation = if Math.abs(window.orientation) is 90 then 'landscape' else 'portrait'
      $('body').removeClass('portrait landscape')
               .addClass(orientation)
               .trigger('turn', orientation: orientation)

module.exports = App