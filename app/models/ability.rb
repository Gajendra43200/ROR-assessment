# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # frozen_string_literal: true
    if user.user_type == 'Author'
      puts "------------------------------------>#{user.user_type}"
      can %i[create update destroy show index], Post
      can %i[update index destroy show create], Comment
      can %i[destroy create], Like
    else
      user.user_type
      puts "------------------------------------>#{user.user_type}"
      can %i[index show], Post
      can %i[update index destroy show create], Comment
      can %i[index create], Like

    end
  end
end
