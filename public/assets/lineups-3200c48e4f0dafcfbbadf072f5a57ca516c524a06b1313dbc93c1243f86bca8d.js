(function() {
  var ready;

  ready = function() {
    var $rows, checkDuplicates, checkPlayers, gametype, handleFlex, i, j, k, l, lineup, m, n, num_dif_positions, num_flex, num_total_positions, positions, ref, ref1, ref2, ref3, salary;
    alert("hello");
    Array.prototype.unique = function() {
      var k, key, output, ref, results, value;
      output = {};
      for (key = k = 0, ref = this.length; 0 <= ref ? k < ref : k > ref; key = 0 <= ref ? ++k : --k) {
        output[this[key]] = this[key];
      }
      results = [];
      for (key in output) {
        value = output[key];
        results.push(value);
      }
      return results;
    };
    gametype = gon.gametype;
    num_dif_positions = gon.num_dif_positions;
    num_total_positions = gon.num_total_positions;
    num_flex = gon.num_flex;

    /*lineup object that holds player variables so they can be dynamically accessed */
    positions = {};
    lineup = {};
    for (i = k = 1, ref = num_dif_positions; 1 <= ref ? k <= ref : k >= ref; i = 1 <= ref ? ++k : --k) {
      positions["position_" + i] = gon.players_hash["position_" + i];
    }

    /*
    ACCOUNT FOR FLEX SOMEHOW
     */
    for (i = l = 1, ref1 = num_total_positions; 1 <= ref1 ? l <= ref1 : l >= ref1; i = 1 <= ref1 ? ++l : --l) {
      for (j = m = 1, ref2 = gon.players_hash["position_" + i]; 1 <= ref2 ? m <= ref2 : m >= ref2; j = 1 <= ref2 ? ++m : --m) {
        lineup["pos_" + i + "_" + j] = 0;
        lineup["pos_" + i + "_" + j + "Sal"] = 0;
      }
    }
    for (i = n = 1, ref3 = num_flex; 1 <= ref3 ? n <= ref3 : n >= ref3; i = 1 <= ref3 ? ++n : --n) {
      lineup["pos_0_" + i] = 0;
      lineup["pos_0_" + i + "Sal"] = 0;
    }
    checkDuplicates = function() {
      var arr;
      arr = [lineup["player_1"], lineup["player_2"], lineup["player_3"], lineup["player_4"], lineup["player_5"], lineup["player_6"], lineup["player_7"], lineup["player_8"]];
      arr = arr.unique();
      if (arr.length === 8) {
        return true;
      }
    };
    checkPlayers = function() {
      if ((lineup["player_1"] != null) && (lineup["player_2"] != null) && (lineup["player_3"] != null) && (lineup["player_4"] != null) && (lineup["player_5"] != null) && (lineup["player_6"] != null) && (lineup["player_7"] != null) && (lineup["player_8"] != null) && salary >= 0 && checkDuplicates() === true) {
        return $("input[name='commit']").attr("disabled", false);
      }
    };

    /*
        ON PLAYER SELECT
        IF LINEUP[PLAYER.POSITION] EXISTS AND
            ALL FLEXES EXIST
        CHANGE OPACITY OF ROWS IDENTIFIED BY PLAYER.POSITION
     */
    salary = parseInt($(".salary").text(), 10);
    checkPlayers();
    handleFlex = function(i, id, player_salary, name) {
      var lineupRow;
      if (lineup["pos_0_" + i] == null) {
        lineup["pos_0_" + i + "Sal"] = player_salary;
        salary -= player_salary;
        lineupRow = $(".player-info").find("[data-id='" + id + "']");
        lineup["pos_0_" + i] = id;
        alert(lineup["pos_0_" + i]);
        $('.player-select').find('[data-id="' + id + '\"]').parent().find(".add-player-button").text("-");
        $(".current-lineup-" + ((num_total_positions - num_flex) + i) + "-player-name").text(name);
        $(".current-lineup-" + ((num_total_positions - num_flex) + i) + "-player-name").attr("data-id", id);
        $(".current-lineup-" + ((num_total_positions - num_flex) + i) + "-player-name").attr("data-salary", salary);
        lineupRow.parent().parent().parent().css({
          backgroundColor: '#F2385A'
        });
        lineupRow.parent().parent().parent().css({
          color: 'white'
        });
        lineupRow.parent().parent().parent().css({
          opacity: 1.0
        });
        checkPlayers();
        $(".salary").text(salary.toString());
        return true;
      }
    };

    /* SEARCH PLAYERS */
    $rows = $('.player-select tr');
    $('#search').keyup(function() {
      var reg, text, val;
      val = '^(?=.*\\b' + $.trim($(this).val()).split(/\s+/).join('\\b)(?=.*\\b') + ').*$';
      reg = RegExp(val, 'i');
      text = void 0;
      $rows.show().filter(function() {
        text = $(this).text().replace(/\s+/g, ' ');
        return !reg.test(text);
      }).hide();
    });

    /* END SEARCH */

    /* SUBMIT HANDLER */
    $('#new_lineup').submit(function(e) {
      var cid;
      cid = $("#contest_id").val();

      /* Stop form from submitting */
      e.preventDefault();

      /* Send the data using post and redirect to contest */
      $.post('/lineups', {
        lineup: {
          player_1: lineup["player_1"],
          player_2: lineup["player_2"],
          player_3: lineup["player_3"],
          player_4: lineup["player_4"],
          player_5: lineup["player_5"],
          player_6: lineup["player_6"],
          player_7: lineup["player_7"],
          player_8: lineup["player_8"]
        },
        contest_id: cid
      });
      return {
        success: window.location.href = "/contests/" + cid
      };
    });

    /* END SUBMIT HANDLER */

    /*BEGIN EVENT HANDLING */

    /* BEGIN SELECT FILTER EVENT */
    $(".position-select > li > button").click(function() {
      var p, pos;
      pos = $(this).data('position-filter');
      $('.position-select').animate({
        scrollTop: 0
      }, 'fast');
      $(".player-select > tbody > tr").hide();
      $(".position-select > li > button").css({
        backgroundColor: 'white'
      });
      $(".position-select > li").css({
        backgroundColor: 'white'
      });
      $(".position-select > li > button").css({
        color: '#F2385A'
      });
      $(this).css({
        backgroundColor: '#F2385A'
      });
      $(this).css({
        color: 'white'
      });
      $(this).parent().css({
        backgroundColor: '#F2385A'
      });
      if (pos === "all") {
        return $(".player-select > tbody > tr").show();
      } else {
        p = "lineup-" + pos;
        return $("." + p).show();
      }
    });

    /* END SELECT FILTER EVENT */

    /* BEGIN ADD PLAYER EVENT */
    $(".add-player-button").click(function(evt) {
      var id, name, o, player, player_num, player_salary, pn, pos, ref4;
      player = $(this).parent().find('.player-name');
      name = player.text();
      id = player.data('id');
      pos = player.data('position');
      player_salary = player.data('salary');
      player_num = gon.players_hash["position_" + pos] - positions["position_" + pos] + 1;
      if ($(this).text() === "+") {
        alert(positions["position_" + pos]);
        if (positions["position_" + pos] === 0) {
          alert("a");
          for (i = o = 1, ref4 = num_flex; 1 <= ref4 ? o <= ref4 : o >= ref4; i = 1 <= ref4 ? ++o : --o) {
            if (handleFlex(i, id, player_salary, name) === true) {
              break;
            }
          }
        } else {

          /*
          For Assignment 
          ((Number of total players allowed at a position) - (Number of slots open at that position) + 1)
           */
          lineup["pos_" + pos + "_" + player_num] = id;
          lineup["pos_" + pos + "_" + player_num + "Sal"] = player_salary;
          salary -= player_salary;
          $(this).text("-");
          $(this).parent().parent().parent().css({
            backgroundColor: '#F2385A'
          });
          $(this).parent().parent().parent().css({
            opacity: 1.0
          });
          player.css({
            color: 'white'
          });
          $(".current-lineup-pos-" + pos + "-" + player_num + "-player-name").text(name);
          $(".current-lineup-pos-" + pos + "-" + player_num + "-player-name").attr("data-id", id);
          $(".current-lineup-pos-" + pos + "-" + player_num + "-player-name").attr("data-salary", player_salary);
          player.data('pnum', player_num);
          positions["position_" + pos] -= 1;
          checkPlayers();
        }
      } else if ($(this).text() === "-") {
        pn = player.data('pnum');
        switch (id) {
          case lineup["pos_" + pos + "_" + pn]:
            salary += lineup["pos_" + pos + "_" + pn + "Sal"];
            lineup["pos_" + pos + "_" + pn] = null;
            lineup["pos_" + pos + "_" + pn + "Sal"] = null;
            $(this).text("+");
            $(".current-lineup-pos-" + pos + "-" + pn + "-player-name").empty();
            $(".current-lineup-pos-" + pos + "-" + pn + "-player-name").attr("data-id", "");
            $(".current-lineup-pos-" + pos + "-" + pn + "-player-name").attr("data-salary", "");
            $(this).parent().parent().parent().css({
              backgroundColor: 'white'
            });
            player.css({
              color: '#F2385A'
            });
            $(this).parent().parent().parent().css({
              opacity: 1.0
            });
            positions["position_" + pos]++;
            checkPlayers();
            break;
        }
      }
      return $(".salary").text(salary.toString());
    });

    /* END ADD PLAYER EVENT */

    /* BEGIN REMOVE PLAYER FROM CURR LINE */
    return $(".remove-player-button").click(function(evt) {
      var id, lineupRow, name, o, player, player_salary, pos, ref4;
      player = $(this).parent().children('[class$="player-name"]');
      name = player.text();
      if (name !== "") {
        id = player.data('id');
        pos = player.data('position');
        player_salary = player.data('salary');
        if (pos > (num_total_positions - num_flex)) {
          for (i = o = 1, ref4 = 8 - (num_total_positions - num_flex); 1 <= ref4 ? o <= ref4 : o >= ref4; i = 1 <= ref4 ? ++o : --o) {
            if (handleRemoveFlex(i, id, player_salary, name) === true) {
              return;
            }
          }
        }
        switch (id) {
          case lineup["player_" + pos]:
            lineupRow = $(".player-info").find("[data-id='" + id + "']");
            salary += lineup[("player_" + pos + "Sal").toString()];
            lineup["player_" + pos] = null;
            lineup[("player_" + pos + "Sal").toString()] = null;
            $(".current-lineup-" + pos + "-player-name").empty();
            $(".current-lineup-" + pos + "-player-name").attr("data-id", "");
            $(".current-lineup-" + pos + "-player-name").attr("data-salary", "");
            lineupRow.parent().parent().parent().css({
              backgroundColor: 'white'
            });
            lineupRow.parent().parent().parent().css({
              opacity: 1.0
            });
            lineupRow.parent().find("button").text("+");
            checkPlayers();
            break;
        }
      }
      return $(".salary").text(salary.toString());
    });

    /* END REMOVE PLAYER FROM CURR LINE */
  };

  $(".lineups_new").ready(ready);

  $(".lineups_new").on('page:load', ready);

}).call(this);
