require 'rails_helper'

describe 'users/index.html.erb' do
  it 'displays all needed points' do
    visit users_path

    expect(page).to have_content('Name')
    expect(page).to have_content('Notes')
    expect(page).to have_content('Jobs')
    expect(page).to have_content('Email')
    expect(page).to have_content('Phone')
    expect(page).to have_content('Applied At')
    expect(page).to have_selector('#file')
  end

  it 'checks Candidates.csv importing' do
    visit users_path
    page.attach_file("file", Rails.root.join(
      "spec", "fixtures", "files", "Import task - Candidates.csv"
    ))
    find("[data-disable-with='Import CSV']").click

    User.all.each do |user|
      if user.candidates.present?
        job = user.candidates.last.job.title
        last_applied_at = user.candidates.last.applied_at.to_date

        expect(page).to have_content(job)
        expect(page).to have_content(last_applied_at)
      end

      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.phone)
    end
  end

  it 'checks Notes.csv importing' do
    visit users_path
    page.attach_file("file", Rails.root.join(
      "spec", "fixtures", "files", "Import task - Notes.csv"
    ))
    find("[data-disable-with='Import CSV']").click

    User.all.each do |user|
      if user.notes.present?
        last_note = truncate(user.notes.last.message, length: 100, separator: '.')

        expect(page).to have_content(last_note)
      end

      expect(page).to have_content(user.email)
    end
  end

  it 'checks uniqness of users emails' do
    all_emails_count = User.select(:email).count
    uniq_emails_count = User.where.not('email = ?', "?" == nil).uniq.count

    expect(all_emails_count).to equal(uniq_emails_count)
  end
end
