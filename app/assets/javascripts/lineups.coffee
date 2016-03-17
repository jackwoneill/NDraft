# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
    Array::unique = ->
      output = {}
      output[@[key]] = @[key] for key in [0...@length]
      value for key, value of output

    lineup = 
        top: null 
        topSal: null 
        mid: null
        midSal: null
        adc: null
        adcSal: null
        support: null
        supportSal: null
        jungle: null
        jungleSal: null
        flex_1: null
        flex_1Sal: null
        flex_2: null
        flex_2Sal: null
        flex_3: null
        flex_3Sal: null

    checkDuplicates = () ->
        arr = [lineup["top"], 
        lineup["mid"], 
        lineup["adc"], 
        lineup["support"], 
        lineup["jungle"], 
        lineup["flex_1"], 
        lineup["flex_2"], 
        lineup["flex_3"]]
        arr = arr.unique()
        true if arr.length == 8

    checkPlayers = () ->
        $("input[name='commit']").attr("disabled", false) if lineup["top"]? and
        lineup["mid"]? and
        lineup["adc"]? and
        lineup["support"]? and 
        lineup["jungle"]? and 
        lineup["flex_1"]? and 
        lineup["flex_2"]? and 
        lineup["flex_3"]? and
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
        if (!lineup[("flex_"+i).toString()]?) 
            lineup[("flex_"+i+"Sal").toString()] = player_salary
            salary -= player_salary

            #SET VARIABLE VALUE EQUAL TO ID
            lineup[("flex_"+i).toString()] = id

            #UPDATE HTML
            $('.player-select').find('[data-id="'+id+'\"]').parent().find(".add-player-button").text("-")

            $(".current-lineup-flex_"+i+"-player-name").text(name)
            $(".current-lineup-flex_"+i+"-player-name").attr("data-id", id)
            $(".current-lineup-flex_"+i+"-player-name").attr("data-salary", salary)

            #UPDATE CSS
            $('.player-select').find('[data-id="'+id+'\"]').parent().parent().parent().css backgroundColor: 'white'
            $('.player-select').find('[data-id="'+id+'\"]').parent().parent().parent().css opacity: 1.0
            checkPlayers()

            return true

    handleRemoveFlex = (i, id, player_salary, name) ->
        if lineup[("flex_"+i).toString()] == id
            salary += lineup[("flex_"+i+"Sal").toString()]

            lineup[("flex_"+i).toString()] = null
            lineup[("flex_"+i+"Sal").toString()] = null

            $('.player-select').find('[data-id="'+id+'\"]').parent().parent().parent().css backgroundColor: '#273034'
            $('.player-select').find('[data-id="'+id+'\"]').parent().parent().parent().css opacity: 1.0

            $('.player-select').find('[data-id="'+id+'\"]').parent().find(".add-player-button").text("+")
            $(".current-lineup-flex_"+i+"-player-name").empty()
            $(".current-lineup-flex_"+i+"-player-name").attr("data-id", "")
            $(".current-lineup-flex_"+i+"-player-name").attr("data-salary", "")
            checkPlayers()

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
                top: lineup["top"],
                mid: lineup["mid"],
                adc: lineup["adc"],
                support: lineup["support"],
                jungler: lineup["jungle"],
                flex_1: lineup["flex_1"],
                flex_2: lineup["flex_2"],
                flex_3: lineup["flex_3"]
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
        $(".position-select > li > button").css backgroundColor: '#273034'
        $(".position-select > li").css backgroundColor: '#273034'
        $(this).css backgroundColor: '#E95144'
        $(this).parent().css backgroundColor: '#E95144'

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
        lineup[pos] #Dynamic position var
        lineup[(pos + "Sal").toString()] #Dynamic salary var

        if $(this).text() == "+"
            if (lineup[pos])?
                #ADD TO FLEX PLAYERS
                for i in [1..3]
                    break if handleFlex(i, id, player_salary, name) == true
            else
                lineup[pos] = id
                lineup[(pos + "Sal").toString()] = player_salary
                salary -= player_salary

                $(this).text("-")

                $(this).parent().parent().parent().css backgroundColor: 'white'
                $(this).parent().parent().parent().css opacity: 1.0

                $(".current-lineup-"+pos+"-player-name").text(name)
                $(".current-lineup-"+pos+"-player-name").attr("data-id", id)
                $(".current-lineup-"+pos+"-player-name").attr("data-salary", player_salary)
                checkPlayers()

        else if $(this).text() == "-"
            switch id
                when lineup[pos]
                    salary += lineup[(pos + "Sal").toString()]

                    lineup[pos] = null
                    lineup[(pos + "Sal").toString()] = null

                    $(this).text("+")
                    $(".current-lineup-"+pos+"-player-name").empty()
                    $(".current-lineup-"+pos+"-player-name").attr("data-id", "")
                    $(".current-lineup-"+pos+"-player-name").attr("data-salary", "")

                    $(this).parent().parent().parent().css backgroundColor: '#273034'
                    $(this).parent().parent().parent().css opacity: 1.0
                    checkPlayers()
                else 
                    for i in [1..3]
                        break if handleRemoveFlex(i, id, player_salary, name) == true

        $(".salary").text(salary.toString())
    ### END ADD PLAYER EVENT ####

    ### BEGIN REMOVE PLAYER FROM CURR LINE ###

    ### END REMOVE PLAYER FROM CURR LINE ###

$(document).ready(ready)
$(document).on('page:load', ready)