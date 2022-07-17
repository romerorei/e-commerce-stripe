class ArticlePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    #user || !record.private
    return true unless record.private
    return false unless user

    user.article_ids.include?(record.id)
  end
end
