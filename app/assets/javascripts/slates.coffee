# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

	$("button[name='fp_calc_button']").click ->
		total_fp = 0.0
		div = $(this).parent().parent()

		k = div.find("input#kills").val()
		d = div.find("input#deaths").val()
		a = div.find("input#assists").val()

		total_fp = ((2.5 * k) + (1.5 * a)) - 1.0 * d
		fp = div.find("input#total_fp")
		fp.attr('value', total_fp)