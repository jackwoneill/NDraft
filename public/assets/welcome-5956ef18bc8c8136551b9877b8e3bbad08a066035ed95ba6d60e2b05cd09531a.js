(function() {
  var ready;

  ready = function() {
    var btn, close, email, login_modal, modal, password, signup_modal;
    login_modal = document.getElementById('login-modal');
    signup_modal = document.getElementById('signup-modal');
    modal = null;
    btn = document.getElementById('login-button');
    close = document.getElementsByClassName('close')[0];
    email = document.getElementById('user_email');
    password = document.getElementById('user_password');
    modal = login_modal;
    modal.style.display = 'none';
    modal = null;
    $("#login-button").click(function() {
      modal = login_modal;
      modal.style.display = 'block';
      $("#notice").text("");
      return false;
    });
    $("#signup-button").click(function() {
      modal = signup_modal;
      modal.style.display = 'block';
      $("#notice").text("");
      return false;
    });
    return window.onclick = function(event) {
      if (event.target === modal) {
        modal.style.display = 'none';
      }
    };
  };

  $(document).ready(function() {
    $.ajaxSetup({
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    });
    $('#new_user').submit(function() {
      return $('#notice').text("");
    });
    $('#new_registration').submit(function() {
      return $('#notice').text("");
    });
    $('#new_registration').bind('ajax:success', function(evt, data, status, xhr) {
      console.log('success');
      window.location.href = "/contests";
    }).bind('ajax:error', function(evt, xhr, status, error) {
      $("#notice").text("Invalid Email/Password Combination");
    });
    $('#new_user').bind('ajax:success', function(evt, data, status, xhr) {
      console.log('success');
      window.location.href = "/contests";
    }).bind('ajax:error', function(evt, xhr, status, error) {
      $("#notice").text("Invalid Email/Password Combination");
    });
  });

  $(document).ready(ready);

  $(document).on('page:load', ready);

}).call(this);
