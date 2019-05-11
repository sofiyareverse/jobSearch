require 'rails_helper'

describe 'users/index.html.erb' do
  it 'displays all needed points' do
    visit root_path

    expect(page).to have_content('Name')
    expect(page).to have_content('Notes')
    expect(page).to have_content('Jobs')
    expect(page).to have_content('Email')
    expect(page).to have_content('Phone')
    expect(page).to have_content('Applied At')
    expect(page).to have_selector('#file')
  end

  it 'checks Candidates.csv importing' do
    visit root_path
    page.attach_file("file", Rails.root.join(
      "spec", "fixtures", "files", "Import task - Candidates.csv"
    ))
    find("[data-disable-with='Import CSV']").click

    User.all.each do |user|
      job = user.candidates.last.job.title
      last_applied_at = user.candidates.last.applied_at.to_date

      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.phone)
      expect(page).to have_content(job)
      expect(page).to have_content(last_applied_at)
    end
  end

  it 'checks Notes.csv importing' do
    visit root_path
    page.attach_file("file", Rails.root.join(
      "spec", "fixtures", "files", "Import task - Notes.csv"
    ))
    find("[data-disable-with='Import CSV']").click

    User.all.each do |user|
      last_note = truncate(user.notes.last.message, length: 100, separator: '.')

      expect(page).to have_content(user.email)
      expect(page).to have_content(last_note)
    end
  end
end
