module UiHelpers
  def fill_in_editor element_id, contents
    page.execute_script("$('#{element_id}').html('#{contents}');")
    page.execute_script("$('#{element_id}').trigger('blur');")
  end

  def wait_until &block
    count = 0
    while count < 10
      return if block.call
      sleep 0.1
      count += 1
    end
    raise "Time out"
  end

  def wait_for name, value
    selector = "body[data-#{name}=#{value}]"
    wait_until { page.has_css? selector }
  end
end
