class Current < ActiveSupport::CurrentAttributes
  def account
    Account.new(plan: "basic".inquiry, features: [:search].inquiry,
      contacts: 12, companies: 7, tasks: 21, messages: 53)
  end

  def user
    User.new(admin: true)
  end
end
