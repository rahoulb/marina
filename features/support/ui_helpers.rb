module UiHelpers
  def fill_in_editor element_id, contents
    page.execute_script("$('#{element_id}').html('#{contents}');")
    page.execute_script("$('#{element_id}').trigger('blur');")
  end

  def wait_for name, value
    count = 0
    selector = "body[data-#{name}=#{value}]"
    while count < 10
      return if page.has_css? selector
      sleep(0.1)
      count += 1
    end
    raise "Time out waiting for #{selector}"
  end
end
