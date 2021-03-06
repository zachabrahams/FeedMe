require 'rss'

class User < ActiveRecord::Base
  has_attached_file :image, default_url: "fly_trap.jpg"

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates :username, :email, :password_digest, :session_token, :activation_token, presence: true
  validates :username, :email, :session_token, uniqueness: true
  validates :activated, inclusion: [true, false]
  validates :password, length: {minimum: 6, allow_nil: true}

  after_create :setup_curated_feed
  after_initialize :ensure_session_token
  after_initialize :ensure_activation_token

  has_many :watcher_user_follows,\
           class_name: "UserFollow",
           foreign_key: :curator_id,
           dependent: :destroy
  has_many :curator_user_follows,
           class_name: "UserFollow",
           foreign_key: :watcher_id,
           dependent: :destroy

  has_many :watchers, through: :watcher_user_follows, source: :watcher
  has_many :curators, through: :curator_user_follows, source: :curator

  has_one :curated_feed,
          class_name: "Feed",
          foreign_key: :curator_id,
          dependent: :destroy

  has_many :user_feeds, inverse_of: :user, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :feeds, through: :user_feeds
  has_many :entries, through: :feeds
  has_many :user_read_entries, dependent: :destroy
  has_many :read_entries, through: :user_read_entries, source: :entry

  has_many :security_question_answers,
           foreign_key: :user_id,
           inverse_of: :user,
           dependent: :destroy
  has_many :security_questions, through: :security_question_answers

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :authored_comments,
           class_name: "Comment",
           foreign_key: :author_id,
           dependent: :destroy

  attr_reader :password
  attr_accessor :notice

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user && user.has_password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def has_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end


  def read_entry(entry)
    unless self.read_entries.include?(entry)
      self.read_entries << entry
      self.curated_feed.entries << entry if self.curated_feed
    end
  end

  def setup_curated_feed
    self.curated_feed = Feed.new(
      name: "#{self.username}'s Recent Reading!",
      url:  "Local Feed",
      curated: true,
    )
  end

  def make_feed
    feed = RSS::Maker.make("atom") do |maker|

      maker.channel.author = self.username
      maker.channel.updated = Time.now.to_s
      maker.channel.title = "#{self.username}'s FeedMe Feed!!!!"
      maker.channel.about = "http://feed--me.com/api/user/#{self.id}/personal_feed"

      self.read_entries[0...20].each do |entry|
        maker.items.new_item do |item|
          item.id = entry.guid
          item.title = entry.title
          item.link = entry.link
          item.updated = entry.published_at.to_s || Time.now.to_s

          parsedEntry = JSON::parse(entry.json)
          item.author = parsedEntry['author'] if parsedEntry['author']
          item.summary = parsedEntry['summary'] if parsedEntry['summary']
          item.content= parsedEntry['content'] if parsedEntry['content']
        end
      end

    end

    feed
  end

  def verify_security_questions(quest_id_0, answer_0, quest_id_1, answer_1);
    verify_security_question(quest_id_0, answer_0) &&
    verify_security_question(quest_id_1, answer_1)
  end

  def verify_security_question(quest_id, guess)
    answer = self
      .security_question_answers
      .find_by(question_id: quest_id)
    answer.correct_answer?(guess) ? true : false
  end

  def set_reset_token
    self.reset_token = SecureRandom.urlsafe_base64
    self.save
  end

  def has_reset_token?(token)
    token == self.reset_token
  end

  def clear_reset_token
    self.reset_token = nil
    self.save
  end


  def reset_session_token!
    self.session_token = unique_session_token
    self.save!
  end

  private

  def ensure_activation_token
    self.activation_token || self.activation_token = SecureRandom.urlsafe_base64
  end

  def ensure_session_token
    self.session_token || self.session_token = unique_session_token
  end

  def unique_session_token
    users = User.all # is there a way to do this while caching users?
    new_token = SecureRandom.urlsafe_base64
    until users.none { |user| user.session_token == new_token }
      new_token = SecureRandom.urlsafe_base64
    end

    new_token
  end

end
