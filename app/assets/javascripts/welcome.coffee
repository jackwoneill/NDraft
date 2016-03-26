ready = ->
  # Get the modal
  login_modal = document.getElementById('login-modal')
  modal = null
  # Get the button that opens the modal
  btn = document.getElementById('login-button')
  # Get the <span> element that closes the modal
  close = document.getElementsByClassName('close')[0]
  email = document.getElementById('user_email')
  password = document.getElementById('user_password')
  # When the user clicks on the button, open the modal 

  $("#login-button").click ->
    modal = login_modal
    modal.style.display = 'block'
    $("#notice").text("")
    return false

  # When the user clicks on <span> (x), close the modal
  # close.onclick = (e) ->
  #   modal.style.display = 'none'
  #   return

  # When the user clicks anywhere outside of the modal, close it

  window.onclick = (event) ->
    if event.target == modal
      modal.style.display = 'none'
    return

  # ---





$(document).ready ->
  $.ajaxSetup headers: 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

  $('#new_user').submit ->
    $('#notice').text("")

  #form id
  $('#new_user').bind('ajax:success', (evt, data, status, xhr) ->
    #function called on status: 200 (for ex.)
    console.log 'success'
    window.location.href = "/contests"
    return
  ).bind 'ajax:error', (evt, xhr, status, error) ->
    #function called on status: 401 or 500 (for ex.)
    #UPDATE A NOTICE THING IN MODAL TO SAY INVALID PASSWORD}}
    $("#notice").text("Invalid Email/Password Combination")
    return
  return


$(document).ready(ready)
$(document).on('page:load', ready)