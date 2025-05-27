class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    if Rails.env.test?
      Rails.logger.debug { "[ABILITY DEBUG] User ID: #{user.id}, Role: #{user.role}, Organization ID: #{user.organization_id}" }
    end

    case user.role
    when "super_admin"
      can :manage, :all
    when "org_admin"
      can :manage, [ Location, Product, Vehicle, Order, Trip ], organization_id: user.organization_id
      can :manage, User, organization_id: user.organization_id
      can :manage, Organization, id: user.organization_id
    when "planner"
      can :read, [ Location, Product, Vehicle, Order, Trip ], organization_id: user.organization_id
      can :create, [ Order, Trip ], organization_id: user.organization_id
      can :update, [ Order, Trip ], organization_id: user.organization_id
      can :read, Organization, id: user.organization_id
    when "dispatcher"
      can :read, [ Location, Product, Vehicle, Order, Trip ], organization_id: user.organization_id
      can :update, [ Vehicle, Trip ], organization_id: user.organization_id
      can :show, Organization, id: user.organization_id
    end

    if Rails.env.test?
      Rails.logger.debug { "[ABILITY DEBUG] Rules: #{rules.inspect}" }
    end
  end
end
