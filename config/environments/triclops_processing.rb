require Rails.root.join('config/environments/deployed.rb')

Rails.application.configure do
  # Setting host so that url helpers can be used in mailer views.
  config.action_mailer.default_url_options = { host: 'https://triclops-processing.library.columbia.edu' }
end
