class Spinach::Features::ManagingSiteAssets < Spinach::FeatureSteps
  include Logins
  include UiHelpers

  step 'I visit the dashboard and look at the site assets' do
    visit '/'
    click_link I18n.t(:site_assets)
    wait_for 'stylesheets', 'loaded'
    wait_for 'javascripts', 'loaded'
  end

  step 'I should see the javascripts and stylesheets' do
    within '.stylesheets' do
      page.has_content?('first.css').must_equal true
      page.has_content?('second.css').must_equal true
    end
    within '.javascripts' do
      page.has_content?('first.js').must_equal true
      page.has_content?('second.js').must_equal true
    end
  end

  step 'I add a stylesheet' do
    click_link I18n.t(:add_a_stylesheet)
    wait_until { page.has_css? 'form.stylesheet' }
    fill_in 'name', with: 'new.css'
    fill_in 'contents', with: 'p { font-family: Arial; }'
    click_button I18n.t(:save)
    wait_for 'stylesheet', 'saved'
  end

  step 'the stylesheet should be added to the site assets' do
    within '.stylesheets' do
      page.has_content?('new.css').must_equal true
    end
    @new_stylesheet = Marina::Db::Stylesheet.where(name: 'new.css').first
    @new_stylesheet.wont_equal nil
    @new_stylesheet.contents.must_equal 'p { font-family: Arial; }'
  end

  step 'I add a javascript' do
    click_link I18n.t(:add_a_javascript)
    wait_until { page.has_css? 'form.javascript' }
    fill_in 'name', with: 'new.js'
    fill_in 'contents', with: 'console.log("what you looking at?");'
    click_button I18n.t(:save)
    wait_for 'javascript', 'saved'
  end

  step 'the javascript should be added to the site assets' do
    within '.javascripts' do
      page.has_content?('new.js').must_equal true
    end
    @new_javascript = Marina::Db::Javascript.where(name: 'new.js').first
    @new_javascript.wont_equal nil
    @new_javascript.contents.must_equal 'console.log("what you looking at?");'
  end

  step 'I edit a stylesheet' do
    click_link 'first.css'
    fill_in 'name', with: 'updated.css'
    fill_in 'contents', with: 'h1 { font-weight: normal; }'
    click_button I18n.t(:save)
    wait_for 'stylesheet', 'saved'
  end

  step 'the stylesheet should be updated' do
    @first_stylesheet.reload
    @first_stylesheet.name.must_equal 'updated.css'
    @first_stylesheet.contents.must_equal 'h1 { font-weight: normal; }'
  end

  step 'I edit a stylesheet with bad syntax' do
    pending 'step not implemented'
  end

  step 'the stylesheet should not be updated' do
    pending 'step not implemented'
  end

  step 'I should see an error message' do
    pending 'step not implemented'
  end

  step 'I edit a javascript' do
    click_link 'first.js'
    fill_in 'name', with: 'updated.js'
    fill_in 'contents', with: 'alert("bust");'
    click_button I18n.t(:save)
    wait_for 'javascript', 'saved'
  end

  step 'the javascript should be updated' do
    @first_javascript.reload
    @first_javascript.name.must_equal 'updated.js'
    @first_javascript.contents.must_equal 'alert("bust");'
  end

  step 'I edit a javascript with bad syntax' do
    pending 'step not implemented'
  end

  step 'the javascript should not be updated' do
    pending 'step not implemented'
  end

  step 'I delete a stylesheet' do
    click_link 'first.css'
    click_link I18n.t(:delete)
    click_button I18n.t(:delete)
    wait_for 'stylesheet', 'deleted'
  end

  step 'the stylesheet should be deleted' do
    Marina::Db::Stylesheet.where(id: @first_stylesheet.id).first.must_equal nil
  end

  step 'I delete a javascript' do
    click_link 'first.js'
    click_link I18n.t(:delete)
    click_button I18n.t(:delete)
    wait_for 'javascript', 'deleted'
  end

  step 'the javascript should be deleted' do
    Marina::Db::Javascript.where(id: @first_javascript.id).first.must_equal nil
  end

  step 'there are several stylesheets and javascripts configured' do
    @first_stylesheet = a_saved Marina::Db::Stylesheet, name: 'first.css', contents: 'h1 { font-weight: bold; }'
    @second_stylesheet = a_saved Marina::Db::Stylesheet, name: 'second.css', contents: 'h2 { font-weight: bold; }'
    @first_javascript = a_saved Marina::Db::Javascript, name: 'first.js', contents: "alert('boom');"
    @second_javascript = a_saved Marina::Db::Javascript, name: 'second.js', contents: "console.log('hello');"
  end
end
