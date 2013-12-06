module UiHelpers
  def fill_in_editor element_id, contents
    page.execute_script("$('#{element_id}').html('#{contents}');")
    page.execute_script("$('#{element_id}').trigger('blur');")
  end
end
