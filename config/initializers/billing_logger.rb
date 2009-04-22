class BillingLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n" 
  end
end

# Setting up the billing scripts billing logger, this should only be used in the billing script
billing_log_file = File.open("#{RAILS_ROOT}/log/billing.log", 'a')
billing_log_file.sync = true
BILLING_LOGGER = BillingLogger.new(billing_log_file)