Then /^I should receive a new request notification$/ do
  sleep 5
  email = ActionMailer::Base.deliveries.first
  email.should_not be_nil
  email.subject.should include "Request created by"
end