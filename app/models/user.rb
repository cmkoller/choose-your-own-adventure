class User < ActiveRecord::Base
  has_many :storys

  def self.find_or_create_from_omniauth(auth)
    provider = auth.provider
    uid = auth.uid

    find_by(provider: provider, uid: uid) || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create(
    provider: auth.provider,
    uid: auth.uid,
    email: auth.info.email,
    username: auth.info.nickname,
    name: auth.info.name,
    avatar_url: auth.info.image
    )
  end

  def first_name
    name.split(" ")[0]
  end

  def last_name
    name.split(" ")[0]
  end
end
