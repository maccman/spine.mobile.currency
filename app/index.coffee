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

module.exports = App