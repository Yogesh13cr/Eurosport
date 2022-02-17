Given("I'm on the Eurosport homepage") do
  on(ESHomePage) do |page|
    page.sd_page_link_element.present?
    page.sd_page_link_element.click
  end
end

# Validate the components present in top navigation link
Then("I see the navigation links on top") do
  on(ESHomePage) do |_page|
    expect(watch_tab_element.present?).to be_truthy
    expect(results_tab_element.present?).to be_truthy
    expect(football_tab_element.present?).to be_truthy
    expect(tennis_tab_element.present?).to be_truthy
    expect(cycling_tab_element.present?).to be_truthy
    expect(search_box_element.present?).to be_truthy
    expect(sign_in_link_element.present?).to be_truthy
  rescue StandardError => e
    p e.backtrace
  end
end
# Validate the components present in bottom navigation link
Then("I see the navigation links on bottom") do
  on(ESHomePage) do |_page|
    expect(help_centre_element.present?).to be_truthy
    expect(country_dropdown_element.present?).to be_truthy
    expect(about_eurosport_link_element.present?).to be_truthy
    expect(mobile_apps_link_element.present?).to be_truthy
    expect(terms_of_use_link_element.present?).to be_truthy
    expect(privacy_policy_link_element.present?).to be_truthy
    expect(legal_information_link_element.present?).to be_truthy
    expect(cookie_policy_link_element.present?).to be_truthy
    expect(pass_information_link_element.present?).to be_truthy
    expect(modern_slavery_link_element.present?).to be_truthy
  rescue StandardError => e
    p e.backtrace
  end
end

# Verify the meta data in article page
When("I select the article page") do
  on(ESHomePage) do |page|
    page.article_link_element.present?
    page.article_link_element.click
  end
end

Then("I validate the metedata in the article page") do
  on(ESHomePage) do |_page|
    expect(sports_label_element.present?).to be_truthy
    expect(image_card_element.present?).to be_truthy
    expect(author_name_element.present?).to be_truthy
    expect(date_information_element.present?).to be_truthy
    expect(article_title_element.present?).to be_truthy
    expect(secondary_title_element.present?).to be_truthy
  rescue StandardError => e
    p e.backtrace
  end
end

# Verify UI of fixed hero in sports hub page
When("I click football tab from home page") do
  on(ESHomePage) do |page|
    page.wait_until(20) { page.football_tab_element.present? }
    page.football_tab_element.click
  end
end

Then("I validate the data in sport hub page") do
  on(ESWatchPage) do |page|
    page.hero_card_img_element.present?
    page.top_stories_element.present?
    page.secondary_card_element.present?
  end
end
