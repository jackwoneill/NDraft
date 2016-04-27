# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
    Array::unique = ->
        output = {}
        output[@[key]] = @[key] for key in [0...@length]
        value for key, value of output

    action = gon.action
    gametype =  gon.gametype
    num_dif_positions = gon.num_dif_positions
    num_total_positions = gon.num_total_positions
    num_flex = gon.num_flex

    ###lineup object that holds player variables so they can be dynamically accessed###

    positions = {} 
    lineup = {} 

    for i in [1..num_dif_positions]
        positions["position_"+i] = gon.players_hash["position_" + i]

    ###
    ACCOUNT FOR FLEX SOMEHOW 
    ###
    for i in [1..num_total_positions]
        for j in [1..gon.players_hash["position_" + i]]
            lineup["pos_" + i + "_" + j] = 0
            lineup["pos_" + i + "_" + j + "Sal"] = 0

    if num_flex != 0
        for i in [1..num_flex]
            lineup["pos_0_" + i] = 0
            lineup["pos_0_" + i + "Sal"] = 0

    checkDuplicates = () ->
        arr = []
        for i in [1..num_dif_positions]
            for j in [1..gon.players_hash["position_" + i]]
                arr.push(lineup["pos_" + i + "_" + j])

        if num_flex != 0
            for i in [1..num_flex]
                arr.push(lineup["pos_0_" + i])

        arr = arr.unique()
        true if arr.length == num_total_positions + num_flex

    checkPlayers = () ->
        filled = true

        for i in [1..num_dif_positions]
            for j in [1..gon.players_hash["position_" + i]]
                filled = false if lineup["pos_" + i + "_" + j] == 0 or lineup["pos_" + i + "_" + j] == null

        if num_flex != 0
            for i in [1..num_flex]
                filled = false if lineup["pos_0_" + i] == 0 or lineup["pos_" + i + "_" + j] == null

        $("input[name='commit']").attr("disabled", false) if filled == true and 
        salary >= 0 and
        checkDuplicates() == true

    ###
        ON PLAYER SELECT
        IF LINEUP[PLAYER.POSITION] EXISTS AND
            ALL FLEXES EXIST
        CHANGE OPACITY OF ROWS IDENTIFIED BY PLAYER.POSITION
    ###

    salary = parseInt($(".salary").text(), 10)

    checkPlayers()

    handleFlex = (i, id, player_salary, name) ->
        if (lineup["pos_0_" + i] == 0) 
            lineup["pos_0_" + i + "Sal"] = player_salary
            salary -= player_salary
            lineupRow = $(".player-info").find("[data-id='" + id + "']")

            lineup["pos_0_" + i] = id

            #UPDATE HTML
            $('.player-select').find('[data-id="'+id+'\"]').parent().find(".add-player-button").text("-")

            $(".current-lineup-pos-0-" + i + "-player-name").text(name)
            $(".current-lineup-pos-0-" + i + "-player-name").attr("data-id", id)
            $(".current-lineup-pos-0-" + i + "-player-name").attr("data-salary", salary)
            $(".current-lineup-pos-0-" + i + "-player-name").attr("data-pnum", i)

            #UPDATE CSS
            lineupRow.parent().parent().parent().css backgroundColor: '#F2385A'
            lineupRow.css color: 'white'
            lineupRow.parent().parent().parent().css opacity: 1.0

            checkPlayers()
            $(".salary").text(salary.toString())

            return true

    handleRemoveFlex = (i, id, player_salary, name) ->
        if lineup["pos_0_" + i] == id
            salary += lineup["pos_0_" + i + "Sal"]
            lineupRow = $(".player-info").find("[data-id='" + id + "']")

            lineup["pos_0_" + i] = 0
            lineup["pos_0_" + i + "Sal"] = null

            lineupRow.parent().parent().parent().css backgroundColor: 'white'
            lineupRow.css color: '#F2385A'
            lineupRow.parent().parent().parent().css opacity: 1.0

            $('.player-select').find('[data-id="'+id+'\"]').parent().find(".add-player-button").text("+")
            $(".current-lineup-pos-0-" + i + "-player-name").empty()
            $(".current-lineup-pos-0-" + i + "-player-name").attr("data-id", 0)
            $(".current-lineup-pos-0-" + i + "-player-name").attr("data-salary", "")
            $(".current-lineup-pos-0-" + i + "-player-name").attr("data-pnum", 0)
            checkPlayers()

            $(".salary").text(salary.toString())

            return true

    ### SEARCH PLAYERS ###
    $rows = $('.player-select tr')
    $('#search').keyup ->
      val = '^(?=.*\\b' + $.trim($(this).val()).split(/\s+/).join('\\b)(?=.*\\b') + ').*$'
      reg = RegExp(val, 'i')
      text = undefined
      $rows.show().filter(->
        text = $(this).text().replace(/\s+/g, ' ')
        !reg.test(text)
      ).hide()
      return
    ### END SEARCH ###

    ### SUBMIT HANDLER ###

    $('#new_lineup').submit (e) ->

        cid = $("#contest_id").val()
        lid = -1

        ### Stop form from submitting ###
        e.preventDefault()

        ### Send the data using post and redirect to contest###
        if action == 1
            $.post('/lineups.json',
                contest_id: cid).success (data) ->
                    lid = data.id
                    window.location.href = "/contests/"+ cid if createPlayers(lid, cid) == true
                    return

    $('.edit_lineup').submit (e) ->
        lid = gon.lid
        cid = $("#contest_id").val()

        e.preventDefault()

        $.get('/lineups/' + lid + '/edit?contest_id=' + cid).success (data) ->
                window.location.href = "/contests/"+ cid if createPlayers(lid, cid) == true
                return

        ### Stop form from submitting ###

    createPlayers = (lid) ->
        success = true
        for i in [1..num_dif_positions]
            for j in [1..gon.players_hash["position_" + i]]
                $.post('/lineup_players.json',
                    lineup_player: 
                        lineup_id: lid, player_id: lineup["pos_" + i + "_" + j]).error ->
                            success = false
        if num_flex != 0
            for i in [1..num_flex]
                $.post('/lineup_players.json',
                        lineup_player: 
                            lineup_id: lid, player_id: lineup["pos_0_" + i]).error ->
                                success = false
            
        return true if success == true
          
       # window.location.href = "/contests/"+ cid
    ### END SUBMIT HANDLER ###

    ###BEGIN EVENT HANDLING ###

    ### BEGIN SELECT FILTER EVENT ###
    $(".position-select > li > button").click ->
        pos = $(this).data('position-filter')
        $('.position-select').animate { scrollTop: 0 }, 'fast'

        $(".player-select > tbody > tr").hide()
        $(".position-select > li > button").css backgroundColor: 'white'
        $(".position-select > li").css backgroundColor: 'white'
        $(".position-select > li > button").css color: '#F2385A'
        $(this).css backgroundColor: '#F2385A'
        $(this).css color: 'white'
        $(this).parent().css backgroundColor: '#F2385A'

        if pos == "all"
            $(".player-select > tbody > tr").show()
        else
            p = "lineup-"+pos
            $("."+p).show()

    ### END SELECT FILTER EVENT ####

    ### BEGIN ADD PLAYER EVENT ###

    $(".add-player-button").click (evt) ->
        player = $(this).parent().find('.player-name')
        name = player.text()
        id = parseInt(player.attr("data-id"))
        pos = parseInt(player.attr("data-position"))
        player_salary = parseInt(player.attr("data-salary"))
        alert player_salary

        # lineup["player_" + pos] #Dynamic position var
        # lineup["player_" + (pos + "Sal").toString()] #Dynamic salary var

        if $(this).text() == "+"
            alert "b"

            if positions["position_" + pos] == 0
                #ADD TO FLEX PLAYERS
                if num_flex != 0
                    for i in [1..num_flex]
                        break if handleFlex(i, id, player_salary, name) == true
            else
                for i in [1..gon.players_hash["position_" + pos]]
                    if lineup["pos_" + pos + "_" + i] == 0
                        lineup["pos_" + pos + "_" + i] = id
                        lineup["pos_" + pos + "_" + i + "Sal"] = player_salary
                            
                        salary -= player_salary

                        $(this).text("-")

                        $(this).parent().parent().parent().css backgroundColor: '#F2385A'
                        $(this).parent().parent().parent().css opacity: 1.0
                        player.css color: 'white'

                        $(".current-lineup-pos-"+pos+"-"+i+"-player-name").text(name)
                        $(".current-lineup-pos-"+pos+"-"+i+"-player-name").attr("data-id", id)
                        $(".current-lineup-pos-"+pos+"-"+i+"-player-name").attr("data-salary", player_salary)
                        $(".current-lineup-pos-"+pos+"-"+i+"-player-name").attr('data-pnum', i)

                        player.attr('data-pnum', i)

                        positions["position_" + pos] -= 1

                        checkPlayers()
                        $(".salary").text(salary.toString())

                        return

                ###
                For Assignment 
                ((Number of total players allowed at a position) - (Number of slots open at that position) + 1)
                ###
                
        else if $(this).text() == "-"
            alert "a"
            pn = player.attr('data-pnum')
            alert pn
            switch id
                when lineup["pos_" + pos + "_" + pn]

                    salary += lineup["pos_" + pos + "_" + pn + "Sal"]

                    lineup["pos_" + pos + "_" + pn] = 0
                    lineup["pos_" + pos + "_" + pn + "Sal"] = null

                    $(this).text("+")
                    $(".current-lineup-pos-"+pos+"-"+pn+"-player-name").empty()
                    $(".current-lineup-pos-"+pos+"-"+pn+"-player-name").attr("data-id", 0)
                    $(".current-lineup-pos-"+pos+"-"+pn+"-player-name").attr("data-salary", "0")
                    $(".current-lineup-pos-"+pos+"-"+pn+"-player-name").attr("data-pnum", "0")

                    $(this).parent().parent().parent().css backgroundColor: 'white'
                    player.css color: '#F2385A'
                    $(this).parent().parent().parent().css opacity: 1.0            

                    positions["position_" + pos] += 1

                    player.attr('data-pnum', "0")

                    checkPlayers()
                    $(".salary").text(salary.toString())

                else 
                    if num_flex != 0
                        for i in [1..num_flex]
                            break if handleRemoveFlex(i, id, player_salary, name) == true

    ### END ADD PLAYER EVENT ####

    ### BEGIN REMOVE PLAYER FROM CURR LINE ###

    $(".remove-player-button").click (evt) ->
        player = $(this).parent().children('[class$="player-name"]')
        name = player.text()

        id = parseInt(player.attr("data-id"))

        if name != "" 
            pos = parseInt(player.attr("data-position"))
            player_salary = parseInt(player.attr("data-salary"))
            pn = parseInt(player.attr("data-pnum"))

            if pos == 0
                if num_flex != 0
                    for i in [1..num_flex]
                        return if handleRemoveFlex(i, id, player_salary, name) == true
            switch id
                when lineup["pos_" + pos + "_" + pn]
                    lineupRow = $(".player-info").find("[data-id='" + id + "']")

                    salary += lineup["pos_" + pos + "_" + pn + "Sal"]

                    lineup["pos_" + pos + "_" + pn] = null
                    lineup["pos_" + pos + "_" + pn + "Sal"] = null

                    $(".current-lineup-pos-"+pos+"-"+pn+"-player-name").empty()
                    $(".current-lineup-pos-"+pos+"-"+pn+"-player-name").attr("data-id", "")
                    $(".current-lineup-pos-"+pos+"-"+pn+"-player-name").attr("data-salary", "")
                    $(".current-lineup-pos-"+pos+"-"+pn+"-player-name").attr("data-pnum", 0)

                    lineupRow.parent().parent().parent().css  backgroundColor: 'white'
                    lineupRow.css  color: '#F2385A'
                    lineupRow.parent().parent().parent().css  opacity: 1.0

                    lineupRow.parent().find("button").text("+")

                    lineupRow.data('pnum', 0)
                    positions["position_" + pos]++

                    checkPlayers()
                else

        $(".salary").text(salary.toString())
        return true

    ### END REMOVE PLAYER FROM CURR LINE ###

$(".lineups_new").ready(ready)
$(".lineups_new").on('page:load', ready)
