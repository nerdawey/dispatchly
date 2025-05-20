class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    role = user.role # Assumes User model has a 'role' attribute

    case role
    when 'Super Admin'
      can :manage, :all
      cannot :dispatch, Order
    when 'Organizational Account'
      can :login, :all
      can [:read, :write, :update, :delete], User
      can [:read, :write, :update, :delete], Order
      can [:read, :write, :update], :manage_order
      can [:read, :write, :update, :delete], Location
      can [:read, :write, :update, :delete], Product
      can [:read, :write, :update, :delete], Vehicle
      can [:read, :write, :update, :delete], Trip
      can [:read, :write], :view_history
      can :dispatch, Order
      cannot :manage, Organization
    when 'Planning User'
      can :login, :all
      can [:read, :write, :update, :delete], Order
      can [:read, :write, :update], :manage_order
      can [:read, :write, :update], Location
      can [:read, :write, :update], Product
      can [:read, :write], :view_history
      cannot [:add, :edit], User
      cannot :dispatch, Order
      cannot :manage, Organization
      cannot :manage, Vehicle
      cannot :create, Trip
    when 'Dispatching User'
      can :login, :all
      can [:read, :write], :manage_order
      can [:read, :write, :update, :delete], Trip
      can [:read, :write], :view_history
      can :dispatch, Order
      cannot :manage, Organization
      cannot [:add, :edit], User
      cannot :manage, Location
      cannot :manage, Product
      cannot :manage, Vehicle
      cannot :create, Order
    else
      # Guest permissions (if any)
    end
  end
end 