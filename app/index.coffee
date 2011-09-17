require('lib/setup')

$          = jQuery
Spine      = require('spine')
{Stage}    = require('spine.mobile')
Currencies = require('controllers/currencies')

class App extends Stage.Global
  constructor: ->
    super
    @currencies = new Currencies
    
    $('body').bind 'click', (e) -> 
      e.preventDefault()

module.exports = App