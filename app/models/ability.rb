class Ability
  include CanCan::Ability

  def initialize(user)

    if user.blank?
      cannot :manage, :all

      read_unlock Entry
      read_unlock Topic
      can :read, User
      can :read, Photo
    else
      cannot :manage, :all
      if user.admin_permission
        can :manage, :all
      end

      read_unlock Entry
      read_unlock Topic
      read_unlock Photo

      can :read,   [EntryCategory, User]

      can :create, [Entry, Reply, Topic]

      can :update,  Entry

      update_self user, Reply
      update_self user, Topic

      if user.community_permission

      end

      if user.wiki_permission

      end

      if user.photo_permission

      end
    end
  end

  private

  def read_unlock(klass)
    can :read, klass do |i|
      i.lock == false
    end
  end

  def update_self(user, klass)
    can :update,  klass do |i|
      i.fonder_id == user.id
    end
  end
end

