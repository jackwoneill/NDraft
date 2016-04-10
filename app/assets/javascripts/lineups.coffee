# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
    Array::unique = ->
        output = {}
        output[@[key]] = @[key] for key in [0...@length]
        value for key, value of output

    gametype =  $(".gametype").attr("data-gametype")
    switch gametype
      when "1" then  numPositions = 5
      when "2" then numPositions = 1 


    ###lineup object that holds player variables so they can be dynamically accessed###
    lineup = 
        player_1: null  
        player_1Sal: null 
        player_2: null  
        player_2Sal: null
        player_3: null  
        player_3Sal: null   
        player_4: null  
        player_4Sal: null
        player_5: null  
        player_5Sal: null
        player_6: null  
        player_6Sal: null
        player_7: null  
        player_7Sal: null
        player_8: null  
        player_8Sal: null

    checkDuplicates = () ->
        arr = [lineup["player_1"], 
        lineup["player_2"], 
        lineup["player_3"], 
        lineup["player_4"], 
        lineup["player_5"], 
        lineup["player_6"], 
        lineup["player_7"], 
        lineup["player_8"]]
        arr = arr.unique()
        true if arr.length == 8

    checkPlayers = () ->
        $("input[name='commit']").attr("disabled", false) if lineup["player_1"]? and
        lineup["player_2"]? and
        lineup["player_3"]? and
        lineup["player_4"]? and 
        lineup["player_5"]? and 
        lineup["player_6"]? and 
        lineup["player_7"]? and 
        lineup["player_8"]? and
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
        if (!lineup[("player_" + (numPositions + i)).toString()]?) 
            lineup[("player_" + (numPositions + i) + "Sal").toString()] = player_salary
            salary -= player_salary
            lineupRow = $(".player-info").find("[data-id='" + id + "']")


            #SET VARIABLE VALUE EQUAL TO ID
            lineup[("player_" + (numPositions + i)).toString()] = id

            #UPDATE HTML
            $('.player-select').find('[data-id="'+id+'\"]').parent().find(".add-player-button").text("-")

            $(".current-lineup-player_" + (numPositions + i) + "-player-name").text(name)
            $(".current-lineup-player_" + (numPositions + i) + "-player-name").attr("data-id", id)
            $(".current-lineup-player_" + (numPositions + i) + "-player-name").attr("data-salary", salary)

            #UPDATE CSS
            lineupRow.parent().parent().parent().css backgroundColor: 'white'
            lineupRow.parent().parent().parent().css opacity: 1.0


            checkPlayers()
            $(".salary").text(salary.toString())


            return true

    handleRemoveFlex = (i, id, player_salary, name) ->
        if lineup[("player_" + (numPositions + i)).toString()] == id
            salary += lineup[("player_" + (numPositions + i) + "Sal").toString()]
            lineupRow = $(".player-info").find("[data-id='" + id + "']")


            lineup[("player_" + (numPositions + i)).toString()] = null
            lineup[("player_" + (numPositions + i) + "Sal").toString()] = null


            lineupRow.parent().parent().parent().css backgroundColor: '#273034'
            lineupRow.parent().parent().parent().css opacity: 1.0

            $('.player-select').find('[data-id="'+id+'\"]').parent().find(".add-player-button").text("+")
            $(".current-lineup-player_" + (numPositions + i) + "-player-name").empty()
            $(".current-lineup-player_" + (numPositions + i) + "-player-name").attr("data-id", "")
            $(".current-lineup-player_" + (numPositions + i) + "-player-name").attr("data-salary", "")
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

        ### Stop form from submitting ###
        e.preventDefault()

        ### Send the data using post and redirect to contest###
        $.post '/lineups', 
            lineup:
                player_1: lineup["player_1"],
                player_2: lineup["player_2"],
                player_3: lineup["player_3"],
                player_4: lineup["player_4"],
                player_5: lineup["player_5"],
                player_6: lineup["player_6"],
                player_7: lineup["player_7"],
                player_8: lineup["player_8"]
            contest_id: cid
        success:
            window.location.href = "/contests/"+ cid
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
        id = player.data('id')
        pos = player.data('position')
        player_salary = player.data('salary')
        lineup["player_" + pos] #Dynamic position var
        lineup["player_" + (pos + "Sal").toString()] #Dynamic salary var

        if $(this).text() == "+"
            if (lineup["player_" + pos])?
                #ADD TO FLEX PLAYERS
                for i in [1..(8 - numPositions)]
                    break if handleFlex(i, id, player_salary, name) == true
            else
                lineup["player_" + pos] = id
                lineup[("player_" + pos + "Sal").toString()] = player_salary
                salary -= player_salary

                $(this).text("-")

                $(this).parent().parent().parent().css backgroundColor: '#F2385A'
                $(this).parent().parent().parent().css opacity: 1.0

                $(".current-lineup-"+pos+"-player-name").text(name)
                $(".current-lineup-"+pos+"-player-name").attr("data-id", id)
                $(".current-lineup-"+pos+"-player-name").attr("data-salary", player_salary)

                checkPlayers()

        else if $(this).text() == "-"
            switch id
                when lineup["player_" + pos]
                    salary += lineup[("player_" + pos + "Sal").toString()]

                    lineup["player_" + pos] = null
                    lineup[("player_" + pos + "Sal").toString()] = null

                    $(this).text("+")
                    $(".current-lineup-"+pos+"-player-name").empty()
                    $(".current-lineup-"+pos+"-player-name").attr("data-id", "")
                    $(".current-lineup-"+pos+"-player-name").attr("data-salary", "")

                    $(this).parent().parent().parent().css backgroundColor: 'white'
                    $(this).parent().parent().parent().css opacity: 1.0

                    checkPlayers()
                else 
                    for i in [1..(8 - numPositions)]
                        break if handleRemoveFlex(i, id, player_salary, name) == true

        $(".salary").text(salary.toString())
    ### END ADD PLAYER EVENT ####

    ### BEGIN REMOVE PLAYER FROM CURR LINE ###

    $(".remove-player-button").click (evt) ->
        player = $(this).parent().children('[class$="player-name"]')
        name = player.text()
        if name != "" 
            id = player.data('id')
            pos = player.data('position')
            player_salary = player.data('salary')

            if pos > numPositions
                for i in [1..(8 - numPositions)]
                    return if handleRemoveFlex(i, id, player_salary, name) == true

            switch id
                when lineup["player_" + pos]
                    lineupRow = $(".player-info").find("[data-id='" + id + "']")

                    salary += lineup[("player_" + pos + "Sal").toString()]

                    lineup["player_" + pos] = null 
                    lineup[("player_" + pos + "Sal").toString()] = null

                    $(".current-lineup-" + pos + "-player-name").empty() ##THIS LINE
                    $(".current-lineup-" + pos + "-player-name").attr("data-id", "")
                    $(".current-lineup-" + pos + "-player-name").attr("data-salary", "")

                    lineupRow.parent().parent().parent().css  backgroundColor: 'white'
                    lineupRow.parent().parent().parent().css  opacity: 1.0

                    lineupRow.parent().find("button").text("+")

                    checkPlayers()
                else
                    

        $(".salary").text(salary.toString())

    ### END REMOVE PLAYER FROM CURR LINE ###

$(document).ready(ready)
$(document).on('page:load', ready)