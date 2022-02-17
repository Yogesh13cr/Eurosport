Feature: Olympics Homepage Features

Scenario: Validate the components present in top navigation link
  Given I'm on the home screen 
  Then I see the navigation links on top

Scenario: Validate the components present in bottom navigation link
  Given I'm on the home screen
  Then I see the navigation links on bottom

Scenario: Verify the meta data in article page
  Given I'm on the Eurosport homepage
  When I select the article page 
  Then I validate the metedata in the article page

Scenario: Validate UI in sports hub page
  Given I'm on the home screen
  When I click football tab from home page
  Then I validate the data in sport hub page   