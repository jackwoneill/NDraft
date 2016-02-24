# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
	Array::unique = ->
	  output = {}
	  output[@[key]] = @[key] for key in [0...@length]
	  value for key, value of output

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


	$(".position-select > li > a").click (evt) ->
		pos = $(this).data('position-filter')

		$(".player-select > tbody > tr").hide()
		$(".position-select > li > a").css backgroundColor: '#273034'
		$(this).css backgroundColor: '#E95144'

		$("h2[name='salary']").text(pos)
		if pos == "all"
			$(".player-select > tbody > tr").show()
		else
			p = "lineup-"+pos
			$("."+p).show()


	false

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