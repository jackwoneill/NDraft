# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
    Array::unique = ->
      output = {}
      output[@[key]] = @[key] for key in [0...@length]
      value for key, value of output

    lineup = 
        top: top 
        topSal: topSal 
        mid: mid
        midSal: midSal
        adc: adc
        adcSal: adcSal
        support: support
        supportSal: supportSal
        jungler: jungler
        junglerSal: junglerSal
        flex_1: flex_1
        flex_1Sal: flex_1Sal
        flex_2: flex_2
        flex_2Sal: flex_2Sal
        flex_3: flex_3
        flex_3Sal: flex_3Sal

    top = top
    topSal = topSal

    mid = mid
    midSal = midSal

    adc = adc
    adcSal = adcSal

    support = support
    supportSal = supportSal

    jungler = jungler
    junglerSal = junglerSal

    flex_1 = flex_1
    flex_1Sal = flex_1Sal

    flex_2 = flex_2
    flex_2Sal = flex_2Sal

    flex_3 = flex_3
    flex_3Sal = flex_3Sal

    clearFields = () ->
        $("input[type=radio]").removeAttr('checked')

    clearFields()

    checkDuplicates = () ->
        arr = [top, 
        mid, 
        adc, 
        support, 
        jungler, 
        flex_1, 
        flex_2, 
        flex_3]
        arr.unique()
        true if arr.length = 8

    checkPlayers = () ->
        $("input[name='commit']").attr("disabled", false) if top? and
        mid? and
        adc? and
        support? and
        jungler? and
        flex_1? and
        flex_2? and
        flex_3? and
        salary >= 0 and
        checkDuplicates() == true

    salary = parseInt($("h2[name='salary']").text(), 10)

    checkPlayers()

    enableRows = (enable_pos) ->
        alert "hello"

    disableRows = (disable_pos) ->
        if flex_1? and flex_2? and flex_3?
            f1 = $('.player-select').find('[data-id="'+flex_1+'\"]')
            f2 = $('.player-select').find('[data-id="'+flex_2+'\"]')
            f3 = $('.player-select').find('[data-id="'+flex_3+'\"]')

            switch disable_pos
                when "top"
                    t = $('.player-select').find('[data-id="'+top+'\"]')
                    $('.lineup-top').find('.add-player-button').attr("disabled", true)
                    $('.lineup-top').css backgroundColor: "red"
                    $('.lineup-top').css opacity: 0.3
                    t.parent().parent().parent().css backgroundColor: "white"
                    t.parent().parent().parent().css opacity: 1.0
                    t.find('.add-player-button').attr("disabled", false)


            f1.parent().parent().parent().css backgroundColor: "white"
            f1.parent().parent().parent().css opacity: 1.0
            f1.find('.add-player-button').attr("disabled", false)

            f2.parent().parent().parent().css backgroundColor: "white"
            f2.parent().parent().parent().css opacity: 1.0
            f2.find('.add-player-button').attr("disabled", false)

            f3.parent().parent().parent().css backgroundColor: "white"
            f3.parent().parent().parent().css opacity: 1.0
            f3.find('.add-player-button').attr("disabled", false)


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

    false


    $(".add-player-button").click (evt) ->
        player = $(this).parent().find('.player-name')
        name = player.text()
        id = player.data('id')
        pos = player.data('position')
        player_salary = player.data('salary')
        lineup[pos] #Dynamic position var
        lineup[(pos + "Sal").toString()] #Dynamic salary var

        # if $(this).text() == "+"

        # else if $(this).text() == "-"

        #FOR LOOP THE FLEXES
        #BREAK IF FLEX BECOMES FILLED


        if $(this).text() == "+"
            if (lineup[pos])?
                if !lineup[("flex_1")]?

                    lineup[("flex_1Sal")] = player_salary
                    salary -= lineup[("flex_1Sal").toString()]

                    lineup[("flex_1")] = id

                    $(this).text("-")

                    $(this).parent().parent().parent().css backgroundColor: 'white'
                    $(this).parent().parent().parent().css opacity: 1.0
                    $(".current-lineup-flex-1-player-name").text(name)
                    $(".current-lineup-flex-1-player-name").attr("data-id", id)
                    $(".current-lineup-flex-1-player-name").attr("data-salary", salary)

                else if !lineup[("flex_2")]?

                    lineup[("flex_2Sal")] = player_salary
                    salary -= lineup[("flex_2Sal").toString()]

                    lineup[("flex_2")] = id

                    $(this).text("-")

                    $(this).parent().parent().parent().css backgroundColor: 'white'
                    $(this).parent().parent().parent().css opacity: 1.0
                    $(".current-lineup-flex-2-player-name").text(name)
                    $(".current-lineup-flex-2-player-name").attr("data-id", id)
                    $(".current-lineup-flex-2-player-name").attr("data-salary", salary)

                else if !lineup[("flex_3")]?

                    lineup[("flex_3Sal")] = player_salary
                    salary -= lineup[("flex_3Sal").toString()]

                    lineup[("flex_3")] = id

                    $(this).text("-")

                    $(this).parent().parent().parent().css backgroundColor: 'white'
                    $(this).parent().parent().parent().css opacity: 1.0
                    $(".current-lineup-flex-3-player-name").text(name)
                    $(".current-lineup-flex-3-player-name").attr("data-id", id)
                    $(".current-lineup-flex-3-player-name").attr("data-salary", salary)
                    
            else

                lineup[(pos + "Sal").toString()] = player_salary

                lineup[pos] = id

                $(this).text("-")

                $(this).parent().parent().parent().css backgroundColor: 'white'
                $(this).parent().parent().parent().css opacity: 1.0

                $(".current-lineup-"+pos+"-player-name").text(name)
                $(".current-lineup-"+pos+"-top-player-name").attr("data-id", id)
                $(".current-lineup-"+pos+"-player-name").attr("data-salary", salary)



        else if $(this).text() == "-"
            switch id
                when top
                    salary += topSal if topSal?
                    d_sal = null


                    $(this).parent().parent().parent().css backgroundColor: '#273034'
                    $(this).parent().parent().parent().css opacity: 1.0

                    d_pos = null

                    $(this).text("+")
                    $(".current-lineup-top-player-name").empty()
                    $(".current-lineup-top-player-name").attr("data-id", "")
                    $(".current-lineup-top-player-name").attr("data-salary", "")
                    

                when flex_1
                    salary += flex_1Sal if flex_1Sal?
                    flex_1Sal = null

                    $(this).parent().parent().parent().css backgroundColor: '#273034'
                    $(this).parent().parent().parent().css opacity: 1.0

                    flex_1 = null

                    $(this).text("+")
                    $(".current-lineup-flex-1-player-name").empty()
                    $(".current-lineup-flex-1-player-name").attr("data-id", "")
                    $(".current-lineup-flex-1-player-name").attr("data-salary", "")

                when flex_2
                    salary += flex_2Sal if flex_2Sal?
                    flex_2Sal = null

                    $(this).parent().parent().parent().css backgroundColor: '#273034'
                    $(this).parent().parent().parent().css opacity: 1.0

                    flex_2 = null

                    $(this).text("+")
                    $(".current-lineup-flex-2-player-name").empty()
                    $(".current-lineup-flex-2-player-name").attr("data-id", "")
                    $(".current-lineup-flex-2-player-name").attr("data-salary", "")

                when flex_3
                    salary += flex_3Sal if flex_3Sal?
                    flex_3Sal = null

                    $(this).parent().parent().parent().css backgroundColor: '#273034'
                    $(this).parent().parent().parent().css opacity: 1.0

                    flex_3 = null

                    $(this).text("+")
                    $(".current-lineup-flex-3-player-name").empty()
                    $(".current-lineup-flex-3-player-name").attr("data-id", "")
                    $(".current-lineup-flex-3-player-name").attr("data-salary", "")







    $("input[name='lineup[top]']").change ->

        salary += topSal if topSal?

        topSal = $(this).data('salary')

        salary -= topSal
        $("h2[name='salary']").text(salary)

        $("#lineup_flex_1_"+top).attr("disabled", false)
        $("#lineup_flex_2_"+top).attr("disabled", false)
        $("#lineup_flex_3_"+top).attr("disabled", false)

        arr = $(this).attr('id').split "_"
        id = arr.pop()
        top = id

        $("#lineup_flex_1_"+top).attr("disabled", true)
        $("#lineup_flex_2_"+top).attr("disabled", true)
        $("#lineup_flex_3_"+top).attr("disabled", true)

        checkPlayers()

    $("input[name='lineup[mid]']").change ->

        salary += midSal if midSal?

        midSal = $(this).data('salary')

        salary -= midSal
        $("h2[name='salary']").text(salary)
    
        $("#lineup_flex_1_"+mid).attr("disabled", false)
        $("#lineup_flex_2_"+mid).attr("disabled", false)
        $("#lineup_flex_3_"+mid).attr("disabled", false)

        arr = $(this).attr('id').split "_"
        id = arr.pop()
        mid = id

        $("#lineup_flex_1_"+mid).attr("disabled", true)
        $("#lineup_flex_2_"+mid).attr("disabled", true)
        $("#lineup_flex_3_"+mid).attr("disabled", true) 

        checkPlayers()

    $("input[name='lineup[adc]']").change ->

        salary += adcSal if adcSal?

        adcSal = $(this).data('salary')

        salary -= adcSal
        $("h2[name='salary']").text(salary)
    
        $("#lineup_flex_1_"+adc).attr("disabled", false)
        $("#lineup_flex_2_"+adc).attr("disabled", false)
        $("#lineup_flex_3_"+adc).attr("disabled", false)

        arr = $(this).attr('id').split "_"
        id = arr.pop()
        adc = id

        $("#lineup_flex_1_"+adc).attr("disabled", true)
        $("#lineup_flex_2_"+adc).attr("disabled", true)
        $("#lineup_flex_3_"+adc).attr("disabled", true)

        checkPlayers()

    $("input[name='lineup[support]']").change ->

        salary += supportSal if supportSal?

        supportSal = $(this).data('salary')

        salary -= supportSal
        $("h2[name='salary']").text(salary)
    
        $("#lineup_flex_1_"+support).attr("disabled", false)
        $("#lineup_flex_2_"+support).attr("disabled", false)
        $("#lineup_flex_3_"+support).attr("disabled", false)

        arr = $(this).attr('id').split "_"
        id = arr.pop()
        support = id

        $("#lineup_flex_1_"+support).attr("disabled", true)
        $("#lineup_flex_2_"+support).attr("disabled", true)
        $("#lineup_flex_3_"+support).attr("disabled", true)

        checkPlayers()

    $("input[name='lineup[jungler]']").change ->

        salary += junglerSal if junglerSal?

        junglerSal = $(this).data('salary')

        salary -= junglerSal
        $("h2[name='salary']").text(salary)
    
        $("#lineup_flex_1_"+jungler).attr("disabled", false)
        $("#lineup_flex_2_"+jungler).attr("disabled", false)
        $("#lineup_flex_3_"+jungler).attr("disabled", false)

        arr = $(this).attr('id').split "_"
        id = arr.pop()
        jungler = id

        $("#lineup_flex_1_"+jungler).attr("disabled", true)
        $("#lineup_flex_2_"+jungler).attr("disabled", true)
        $("#lineup_flex_3_"+jungler).attr("disabled", true)

        checkPlayers()


    $("input[name='lineup[flex_1]']").change ->

        salary += flex_1Sal if flex_1Sal?

        flex_1Sal = $(this).data('salary')

        salary -= flex_1Sal
        $("h2[name='salary']").text(salary)

        if document.getElementById("lineup_top_"+flex_1)?
            $("#lineup_top_"+flex_1).attr("disabled", false)
        else if document.getElementById("lineup_mid_"+flex_1)
            $("#lineup_mid_"+flex_1).attr("disabled", false)
        else if document.getElementById("lineup_adc_"+flex_1)
            $("#lineup_adc_"+flex_1).attr("disabled", false)
        else if document.getElementById("lineup_support_"+flex_1)
            $("#lineup_support_"+flex_1).attr("disabled", false)
        else if document.getElementById("lineup_jungler_"+flex_1)
            $("#lineup_jungler_"+flex_1).attr("disabled", false)

        $("#lineup_flex_2_"+flex_1).attr("disabled", false)
        $("#lineup_flex_3_"+flex_1).attr("disabled", false)

        arr = $(this).attr('id').split "_"
        id = arr.pop()
        flex_1 = id

        $("#lineup_flex_2_"+flex_1).attr("disabled", true)
        $("#lineup_flex_3_"+flex_1).attr("disabled", true)

        if document.getElementById("lineup_top_"+flex_1)?
            $("#lineup_top_"+flex_1).attr("disabled", true)
        else if document.getElementById("lineup_mid_"+flex_1)
            $("#lineup_mid_"+flex_1).attr("disabled", true)
        else if document.getElementById("lineup_adc_"+flex_1)
            $("#lineup_adc_"+flex_1).attr("disabled", true)
        else if document.getElementById("lineup_support_"+flex_1)
            $("#lineup_support_"+flex_1).attr("disabled", true)
        else if document.getElementById("lineup_jungler_"+flex_1)
            $("#lineup_jungler_"+flex_1).attr("disabled", true)

        checkPlayers()


    $("input[name='lineup[flex_2]']").change ->

        salary += flex_2Sal if flex_2Sal?

        flex_2Sal = $(this).data('salary')

        salary -= flex_2Sal
        $("h2[name='salary']").text(salary)

        if document.getElementById("lineup_top_"+flex_2)?
            $("#lineup_top_"+flex_2).attr("disabled", false)
        else if document.getElementById("lineup_mid_"+flex_2)
            $("#lineup_mid_"+flex_2).attr("disabled", false)
        else if document.getElementById("lineup_adc_"+flex_2)
            $("#lineup_adc_"+flex_2).attr("disabled", false)
        else if document.getElementById("lineup_support_"+flex_2)
            $("#lineup_support_"+flex_2).attr("disabled", false)
        else if document.getElementById("lineup_jungler_"+flex_2)
            $("#lineup_jungler_"+flex_2).attr("disabled", false)

        $("#lineup_flex_1_"+flex_2).attr("disabled", false)
        $("#lineup_flex_3_"+flex_2).attr("disabled", false)

        arr = $(this).attr('id').split "_"
        id = arr.pop()
        flex_2 = id

        $("#lineup_flex_1_"+flex_2).attr("disabled", true)
        $("#lineup_flex_3_"+flex_2).attr("disabled", true)

        if document.getElementById("lineup_top_"+flex_2)?
            $("#lineup_top_"+flex_2).attr("disabled", true)
        else if document.getElementById("lineup_mid_"+flex_2)
            $("#lineup_mid_"+flex_2).attr("disabled", true)
        else if document.getElementById("lineup_adc_"+flex_2)
            $("#lineup_adc_"+flex_2).attr("disabled", true)
        else if document.getElementById("lineup_support_"+flex_2)
            $("#lineup_support_"+flex_2).attr("disabled", true)
        else if document.getElementById("lineup_jungler_"+flex_2)
            $("#lineup_jungler_"+flex_2).attr("disabled", true)

        checkPlayers()

    $("input[name='lineup[flex_3]']").change ->

        salary += flex_3Sal if flex_3Sal?

        flex_3Sal = $(this).data('salary')

        salary -= flex_3Sal
        $("h2[name='salary']").text(salary)

        if document.getElementById("lineup_top_"+flex_3)?
            $("#lineup_top_"+flex_3).attr("disabled", false)
        else if document.getElementById("lineup_mid_"+flex_3)
            $("#lineup_mid_"+flex_3).attr("disabled", false)
        else if document.getElementById("lineup_adc_"+flex_3)
            $("#lineup_adc_"+flex_3).attr("disabled", false)
        else if document.getElementById("lineup_support_"+flex_3)
            $("#lineup_support_"+flex_3).attr("disabled", false)
        else if document.getElementById("lineup_jungler_"+flex_3)
            $("#lineup_jungler_"+flex_3).attr("disabled", false)

        $("#lineup_flex_1_"+flex_3).attr("disabled", false)
        $("#lineup_flex_2_"+flex_3).attr("disabled", false)

        arr = $(this).attr('id').split "_"
        id = arr.pop()
        flex_3 = id

        $("#lineup_flex_1_"+flex_3).attr("disabled", true)
        $("#lineup_flex_2_"+flex_3).attr("disabled", true)

        if document.getElementById("lineup_top_"+flex_3)?
            $("#lineup_top_"+flex_3).attr("disabled", true)
        else if document.getElementById("lineup_mid_"+flex_3)
            $("#lineup_mid_"+flex_3).attr("disabled", true)
        else if document.getElementById("lineup_adc_"+flex_3)
            $("#lineup_adc_"+flex_3).attr("disabled", true)
        else if document.getElementById("lineup_support_"+flex_3)
            $("#lineup_support_"+flex_3).attr("disabled", true)
        else if document.getElementById("lineup_jungler_"+flex_3)
            $("#lineup_jungler_"+flex_3).attr("disabled", true)

        checkPlayers()

$(document).ready(ready)
$(document).on('page:load', ready)