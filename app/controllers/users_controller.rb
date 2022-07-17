class UsersController < ApplicationController
  def profile
    @articles_user = Article.where(id: current_user.article_ids)
  end

end
