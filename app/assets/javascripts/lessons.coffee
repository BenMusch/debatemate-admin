$ ->
  # show the form to edit a goal when the edit button is clicked
  $("#edit-goal-button").click ->
    $("#edit-goal-button").parent().toggle()
    $("#edit-goal-button").parent().next().toggle()
