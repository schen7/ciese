$(document).on "click", "#main_menu .menu_item-toggle", (evt) ->
  $(@).parents(".main_menu-item").toggleClass("show_menu_item hide_menu_item")
