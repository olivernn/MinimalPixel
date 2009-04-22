if RAILS_ENV = 'development' || RAILS_ENV = 'test'
  GATEWAY = ActiveMerchant::Billing::PaypalExpressRecurringGateway.new(
    :login => 'oliver_1218302408_biz_api1.ntlworld.com',
    :password => '95X5HJ8WG2SRBPB2',
    :signature => 'AH1eOAAdxH9dz4bJ8jTBB9jd0rv7AUvGZZ3ZuXIXmV77iCPhPlGt9YM.')
else
  GATEWAY = "live settings not yet defined"
end