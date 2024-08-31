class Account
  include ActiveModel::Model

  attr_accessor :plan, :features
  attr_accessor :contacts, :companies, :tasks, :messages
end
