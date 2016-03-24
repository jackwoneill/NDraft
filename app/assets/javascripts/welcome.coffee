ready = ->
  # Get the modal
  modal = document.getElementById('myModal')
  # Get the button that opens the modal
  btn = document.getElementById('login-button')
  # Get the <span> element that closes the modal
  span = document.getElementsByClassName('close')[0]
  # When the user clicks on the button, open the modal 

  $("#login-button").click ->
    modal.style.display = 'block'
    return

  # When the user clicks on <span> (x), close the modal

  span.onclick = ->
    modal.style.display = 'none'
    return

  # When the user clicks anywhere outside of the modal, close it

  window.onclick = (event) ->
    if event.target == modal
      modal.style.display = 'none'
    return

  # ---

$(document).ready(ready)
$(document).on('page:load', ready)