(function() {
  var ready;

  ready = function() {
    var $rows, action, checkDuplicates, checkPlayers, createPlayers, gametype, handleFlex, handleRemoveFlex, i, j, k, l, lineup, m, n, num_dif_positions, num_flex, num_total_positions, positions, ref, ref1, ref2, ref3, salary;
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
    action = gon.action;
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
    if (num_flex !== 0) {
      for (i = n = 1, ref3 = num_flex; 1 <= ref3 ? n <= ref3 : n >= ref3; i = 1 <= ref3 ? ++n : --n) {
        lineup["pos_0_" + i] = 0;
        lineup["pos_0_" + i + "Sal"] = 0;
      }
    }
    checkDuplicates = function() {
      var arr, o, q, r, ref4, ref5, ref6;
      arr = [];
      for (i = o = 1, ref4 = num_dif_positions; 1 <= ref4 ? o <= ref4 : o >= ref4; i = 1 <= ref4 ? ++o : --o) {
        for (j = q = 1, ref5 = gon.players_hash["position_" + i]; 1 <= ref5 ? q <= ref5 : q >= ref5; j = 1 <= ref5 ? ++q : --q) {
          arr.push(lineup["pos_" + i + "_" + j]);
        }
      }
      if (num_flex !== 0) {
        for (i = r = 1, ref6 = num_flex; 1 <= ref6 ? r <= ref6 : r >= ref6; i = 1 <= ref6 ? ++r : --r) {
          arr.push(lineup["pos_0_" + i]);
        }
      }
      arr = arr.unique();
      if (arr.length === num_total_positions + num_flex) {
        return true;
      }
    };
    checkPlayers = function() {
      var filled, o, q, r, ref4, ref5, ref6;
      filled = true;
      for (i = o = 1, ref4 = num_dif_positions; 1 <= ref4 ? o <= ref4 : o >= ref4; i = 1 <= ref4 ? ++o : --o) {
        for (j = q = 1, ref5 = gon.players_hash["position_" + i]; 1 <= ref5 ? q <= ref5 : q >= ref5; j = 1 <= ref5 ? ++q : --q) {
          if (lineup["pos_" + i + "_" + j] === 0 || lineup["pos_" + i + "_" + j] === null) {
            filled = false;
          }
        }
      }
      if (num_flex !== 0) {
        for (i = r = 1, ref6 = num_flex; 1 <= ref6 ? r <= ref6 : r >= ref6; i = 1 <= ref6 ? ++r : --r) {
          if (lineup["pos_0_" + i] === 0 || lineup["pos_" + i + "_" + j] === null) {
            filled = false;
          }
        }
      }
      if (filled === true && salary >= 0 && checkDuplicates() === true) {
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
      if (lineup["pos_0_" + i] === 0) {
        lineup["pos_0_" + i + "Sal"] = player_salary;
        salary -= player_salary;
        lineupRow = $(".player-info").find("[data-id='" + id + "']");
        lineup["pos_0_" + i] = id;
        $('.player-select').find('[data-id="' + id + '\"]').parent().find(".add-player-button").text("-");
        $(".current-lineup-pos-0-" + i + "-player-name").text(name);
        $(".current-lineup-pos-0-" + i + "-player-name").attr("data-id", id);
        $(".current-lineup-pos-0-" + i + "-player-name").attr("data-salary", salary);
        $(".current-lineup-pos-0-" + i + "-player-name").attr("data-pnum", i);
        lineupRow.parent().parent().parent().css({
          backgroundColor: '#F2385A'
        });
        lineupRow.css({
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
    handleRemoveFlex = function(i, id, player_salary, name) {
      var lineupRow;
      if (lineup["pos_0_" + i] === id) {
        salary += lineup["pos_0_" + i + "Sal"];
        lineupRow = $(".player-info").find("[data-id='" + id + "']");
        lineup["pos_0_" + i] = 0;
        lineup["pos_0_" + i + "Sal"] = null;
        lineupRow.parent().parent().parent().css({
          backgroundColor: 'white'
        });
        lineupRow.css({
          color: '#F2385A'
        });
        lineupRow.parent().parent().parent().css({
          opacity: 1.0
        });
        $('.player-select').find('[data-id="' + id + '\"]').parent().find(".add-player-button").text("+");
        $(".current-lineup-pos-0-" + i + "-player-name").empty();
        $(".current-lineup-pos-0-" + i + "-player-name").attr("data-id", 0);
        $(".current-lineup-pos-0-" + i + "-player-name").attr("data-salary", "");
        $(".current-lineup-pos-0-" + i + "-player-name").attr("data-pnum", 0);
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
      var cid, lid;
      cid = $("#contest_id").val();
      lid = -1;

      /* Stop form from submitting */
      e.preventDefault();

      /* Send the data using post and redirect to contest */
      if (action === 1) {
        return $.post('/lineups.json', {
          contest_id: cid
        }).success(function(data) {
          lid = data.id;
          if (createPlayers(lid, cid) === true) {
            window.location.href = "/contests/" + cid;
          }
        });
      }
    });
    $('.edit_lineup').submit(function(e) {
      var cid, lid;
      lid = gon.lid;
      cid = $("#contest_id").val();
      e.preventDefault();
      return $.get('/lineups/' + lid + '/edit?contest_id=' + cid).success(function(data) {
        if (createPlayers(lid, cid) === true) {
          window.location.href = "/contests/" + cid;
        }
      });

      /* Stop form from submitting */
    });
    createPlayers = function(lid) {
      var o, q, r, ref4, ref5, ref6, success;
      success = true;
      for (i = o = 1, ref4 = num_dif_positions; 1 <= ref4 ? o <= ref4 : o >= ref4; i = 1 <= ref4 ? ++o : --o) {
        for (j = q = 1, ref5 = gon.players_hash["position_" + i]; 1 <= ref5 ? q <= ref5 : q >= ref5; j = 1 <= ref5 ? ++q : --q) {
          $.post('/lineup_players.json', {
            lineup_player: {
              lineup_id: lid,
              player_id: lineup["pos_" + i + "_" + j]
            }
          }).error(function() {
            return success = false;
          });
        }
      }
      if (num_flex !== 0) {
        for (i = r = 1, ref6 = num_flex; 1 <= ref6 ? r <= ref6 : r >= ref6; i = 1 <= ref6 ? ++r : --r) {
          $.post('/lineup_players.json', {
            lineup_player: {
              lineup_id: lid,
              player_id: lineup["pos_0_" + i]
            }
          }).error(function() {
            return success = false;
          });
        }
      }
      if (success === true) {
        return true;
      }
    };

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
      var id, name, o, player, player_salary, pn, pos, q, r, ref4, ref5, ref6, results, results1;
      player = $(this).parent().find('.player-name');
      name = player.text();
      id = parseInt(player.attr("data-id"));
      pos = parseInt(player.attr("data-position"));
      player_salary = parseInt(player.attr("data-salary"));
      alert(player_salary);
      if ($(this).text() === "+") {
        alert("b");
        if (positions["position_" + pos] === 0) {
          if (num_flex !== 0) {
            results = [];
            for (i = o = 1, ref4 = num_flex; 1 <= ref4 ? o <= ref4 : o >= ref4; i = 1 <= ref4 ? ++o : --o) {
              if (handleFlex(i, id, player_salary, name) === true) {
                break;
              } else {
                results.push(void 0);
              }
            }
            return results;
          }
        } else {
          for (i = q = 1, ref5 = gon.players_hash["position_" + pos]; 1 <= ref5 ? q <= ref5 : q >= ref5; i = 1 <= ref5 ? ++q : --q) {
            if (lineup["pos_" + pos + "_" + i] === 0) {
              lineup["pos_" + pos + "_" + i] = id;
              lineup["pos_" + pos + "_" + i + "Sal"] = player_salary;
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
              $(".current-lineup-pos-" + pos + "-" + i + "-player-name").text(name);
              $(".current-lineup-pos-" + pos + "-" + i + "-player-name").attr("data-id", id);
              $(".current-lineup-pos-" + pos + "-" + i + "-player-name").attr("data-salary", player_salary);
              $(".current-lineup-pos-" + pos + "-" + i + "-player-name").attr('data-pnum', i);
              player.attr('data-pnum', i);
              positions["position_" + pos] -= 1;
              checkPlayers();
              $(".salary").text(salary.toString());
              return;
            }
          }

          /*
          For Assignment 
          ((Number of total players allowed at a position) - (Number of slots open at that position) + 1)
           */
        }
      } else if ($(this).text() === "-") {
        alert("a");
        pn = player.attr('data-pnum');
        alert(pn);
        switch (id) {
          case lineup["pos_" + pos + "_" + pn]:
            salary += lineup["pos_" + pos + "_" + pn + "Sal"];
            lineup["pos_" + pos + "_" + pn] = 0;
            lineup["pos_" + pos + "_" + pn + "Sal"] = null;
            $(this).text("+");
            $(".current-lineup-pos-" + pos + "-" + pn + "-player-name").empty();
            $(".current-lineup-pos-" + pos + "-" + pn + "-player-name").attr("data-id", 0);
            $(".current-lineup-pos-" + pos + "-" + pn + "-player-name").attr("data-salary", "0");
            $(".current-lineup-pos-" + pos + "-" + pn + "-player-name").attr("data-pnum", "0");
            $(this).parent().parent().parent().css({
              backgroundColor: 'white'
            });
            player.css({
              color: '#F2385A'
            });
            $(this).parent().parent().parent().css({
              opacity: 1.0
            });
            positions["position_" + pos] += 1;
            player.attr('data-pnum', "0");
            checkPlayers();
            return $(".salary").text(salary.toString());
          default:
            if (num_flex !== 0) {
              results1 = [];
              for (i = r = 1, ref6 = num_flex; 1 <= ref6 ? r <= ref6 : r >= ref6; i = 1 <= ref6 ? ++r : --r) {
                if (handleRemoveFlex(i, id, player_salary, name) === true) {
                  break;
                } else {
                  results1.push(void 0);
                }
              }
              return results1;
            }
        }
      }
    });

    /* END ADD PLAYER EVENT */

    /* BEGIN REMOVE PLAYER FROM CURR LINE */
    return $(".remove-player-button").click(function(evt) {
      var id, lineupRow, name, o, player, player_salary, pn, pos, ref4;
      player = $(this).parent().children('[class$="player-name"]');
      name = player.text();
      id = parseInt(player.attr("data-id"));
      if (name !== "") {
        pos = parseInt(player.attr("data-position"));
        player_salary = parseInt(player.attr("data-salary"));
        pn = parseInt(player.attr("data-pnum"));
        if (pos === 0) {
          if (num_flex !== 0) {
            for (i = o = 1, ref4 = num_flex; 1 <= ref4 ? o <= ref4 : o >= ref4; i = 1 <= ref4 ? ++o : --o) {
              if (handleRemoveFlex(i, id, player_salary, name) === true) {
                return;
              }
            }
          }
        }
        switch (id) {
          case lineup["pos_" + pos + "_" + pn]:
            lineupRow = $(".player-info").find("[data-id='" + id + "']");
            salary += lineup["pos_" + pos + "_" + pn + "Sal"];
            lineup["pos_" + pos + "_" + pn] = 0;
            lineup["pos_" + pos + "_" + pn + "Sal"] = null;
            $(".current-lineup-pos-" + pos + "-" + pn + "-player-name").empty();
            $(".current-lineup-pos-" + pos + "-" + pn + "-player-name").attr("data-id", "");
            $(".current-lineup-pos-" + pos + "-" + pn + "-player-name").attr("data-salary", "");
            $(".current-lineup-pos-" + pos + "-" + pn + "-player-name").attr("data-pnum", 0);
            lineupRow.parent().parent().parent().css({
              backgroundColor: 'white'
            });
            lineupRow.css({
              color: '#F2385A'
            });
            lineupRow.parent().parent().parent().css({
              opacity: 1.0
            });
            lineupRow.parent().find("button").text("+");
            lineupRow.data('pnum', 0);
            positions["position_" + pos]++;
            checkPlayers();
            break;
        }
      }
      $(".salary").text(salary.toString());
      return true;
    });

    /* END REMOVE PLAYER FROM CURR LINE */
  };

  $(".lineups_new").ready(ready);

  $(".lineups_new").on('page:load', ready);

}).call(this);
