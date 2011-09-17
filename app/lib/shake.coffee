$ = jQuery 

$ ->
  threshold = 20
  x1 = y1 = z1 = x2 = y2 = z2 = 0
  
  checkShake = (e) -> 
    current = e.accelerationIncludingGravity
    
    x1 = current.x
    y1 = current.y
    z1 = current.z
  
  setInterval ->
    change = Math.abs(x1-x2+y1-y2+z1-z2)
    
    if change > threshold
      $('body, window').trigger('shake')
      x2 = x1
      y2 = y1
      z2 = z1
  , 200

  window.addEventListener 'devicemotion', checkShake, false