require "application_system_test_case"

class SelectApplicantsTest < ApplicationSystemTestCase

  setup do
    @event = create(:event)
    @user = create(:user, email: "test@user.de", password: "test", admin: true)
    @applicant1 = create(:application, event: @event)
    @applicant2 = create(:application, event: @event)

    visit event_applications_path(@event.id)

    fill_in "Email", with: "test@user.de"
    fill_in "Password", with: "test"

    click_on "Sign in"
  end

  test "select applicant" do
    check("select_applicant_#{@applicant1.id}")

    click_on "Save"

    assert_text "Cool! Changes saved."

    assert @applicant1.reload.selected?
    assert !@applicant2.reload.selected?

    uncheck("select_applicant_#{@applicant1.id}")

    click_on "Save"

    assert_text "Cool! Changes saved."

    assert !@applicant1.reload.selected?
    assert !@applicant2.reload.selected?
  end

  test "complete selection" do
    assert_no_text "The selection is completed"

    click_on "Selection complete"

    assert_text "The selection is completed"

    assert has_no_button?('Selection complete')
  end
end
