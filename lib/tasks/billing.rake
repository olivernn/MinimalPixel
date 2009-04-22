namespace :billing do
  desc "manages the status of the accounts"
  task :profile_status => :environment do
    BILLING_LOGGER.info "*** Starting billing:profile_status at #{Time.now}"
    
    Account.chargeable.each do |account|
      case account.profile_status
      when "SuspendedProfile"
        BILLING_LOGGER.info "Account #{account.id} has been suspended by paypal"
        account.suspend!
        # this will fail the current pending transaction and set the account status to
        # overdue.  A retry transactions will be set up with a date set to three days time
        
      when "CancelledProfile"
        BILLING_LOGGER.info "Account #{account.id} has been cancelled by paypal"
        account.cancel!
        # what happens if there is an outstanding balance, is there anyway of getting
        # money back?
        
      when "ExpiredProfile"
        BILLING_LOGGER.info "Account #{account.id} has been expired by paypal"
        # when all the recurring payments have been made, this shouldn't happen since
        # all the recurring payments should be neverending, need to catch it if it does
        # happen though.
      end
    end
    
    BILLING_LOGGER.info "*** Finnishing billing:profile_status at #{Time.now} ***"
    # BILLING_LOGGER.flush
  end      
  
  desc "creates transactions for account payments"
  task :transactions => :environment do
    BILLING_LOGGER.info "*** Starting billing:transactions at #{Time.now} ***"
    
    Account.chargeable.each do |account|
      pending_tx = account.transactions.pending.first
      if account.profile.params["last_payment_date"].first(10) == pending_tx.date.to_s
        if account.profile_status == "ActiveProfile"
          BILLING_LOGGER.info "Account #{account.id} has had a succesfull transaction"
          pending_tx.amount = account.profile.params["last_payment_amount"]
          pending_tx.completed_successfully!
        else
          # something has gone wrong, needs some human intervention
          # need to send an email to the administrator
          BILLING_LOGGER.info "Account #{account.id} has a profile status of #{account.profile_status}"
        end
      end
    end

    BILLING_LOGGER.info "*** Finnishing billing:transactions at #{Time.now} ***"
    # BILLING_LOGGER.flush
  end
  
  desc "bill any outstanding account balances"
  task :overdue => :environment do
    BILLING_LOGGER.info "*** Starting billing:overdue at #{Time.now} ***"
    
    Account.overdue.each do |account|
      if account.transactions.retry.first.date == Time.now.strftime('%Y-%M-%d')
        BILLING_LOGGER.info "Account #{account.id} has an outstanding balance of #{account.profile.params['outstanding_balance']}"
        if account.bill_outstanding_amount
          account.transactions.retry.first.completed_successfully!
        else
          account.transactions.retry.first.fail!
          BILLING_LOGGER.info "unsucesful retry of failed payment for account #{account.id}"
        end
      end
    end
    
    BILLING_LOGGER.info "*** Finnishing billing:overdue run at #{Time.now} ***"
    # BILLING_LOGGER.flush
  end
  
  desc "handles cancelled accounts"
  task :cancelations => :environment do
    BILLING_LOGGER.info "*** Starting billing:cancelations at #{Time.now} ***"
    
    Account.cancel_pending.each do |account|
      unless account.profile_id.nil?
        account.bill_outstanding_amount
        account.cancel_profile
      end
      account.cancel!
      account.user.delete!
      BILLING_LOGGER.info "User #{account.user.name} account has been cancelled"
    end
    
    BILLING_LOGGER.info "*** Finnishing billing:cancellations run at #{Time.now} ***"
  end
  
  desc "runs the entire billing suite"
  task :run => [:profile_status, :transactions, :cancelations, :overdue]
end