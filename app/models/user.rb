class User < ActiveRecord::Base
  has_many :scores
  has_many :logs
  serialize :rival
  serialize :reverse_rival
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  # usernameを必須・一意とする
  validates_uniqueness_of :username, :iidxid
  validates_presence_of :username, :djname, :iidxid, :grade, :pref

  validates :iidxid, format: {
    with: /\A\d{4}-\d{4}\z/,
    message: 'が正しくありません。'
  }, length: {
    is: 9
  }
  validates :grade, numericality: {
    only_integer: true
  }, inclusion: {
    in: AbilitysheetIidx::Application.config.iidx_grade..17, message: 'のパラメタが異常です。'
  }
  validates :pref, numericality: {
    only_integer: true
  }, inclusion: {
    in: 0..47, message: 'のパラメタが異常です。'
  }
  validates :djname, length: { maximum: 6 }, format: { with: /\A[A-Z0-9\-]+\z/, message: 'は半角大文字英字で記入して下さい' }
  validates :username, length: { minimum: 3, maximum: 10 }, format: { with: /\A[a-z_0-9]+\z/, message: 'は半角英数字で記入して下さい' }
  @pref_all = %w(
    海外
    北海道 青森県   岩手県 宮城県
    秋田県 山形県   福島県 茨城県
    栃木県 群馬県   埼玉県 千葉県
    東京都 神奈川県 新潟県 富山県
    石川県 福井県   山梨県 長野県
    岐阜県 静岡県   愛知県 三重県
    滋賀県 京都府   大阪府 兵庫県
    奈良県 和歌山県 鳥取県 島根県
    岡山県 広島県   山口県 徳島県
    香川県 愛媛県   高知県 福岡県
    佐賀県 長崎県   熊本県 大分県
    宮崎県 鹿児島県 沖縄県
  )

  @dan_all = %w(
    皆伝
    十段 九段
    八段 七段 六段 五段 四段 三段 二段 初段
    一級 二級 三級 四級 五級 六級 七級
  )

  @dan_all = %w(
    八段 七段 六段 五段 四段 三段 二段 初段
    一級 二級 三級 四級 五級 六級 七級
  )

  def belongs
    %w(
      海外
      北海道 青森県   岩手県 宮城県
      秋田県 山形県   福島県 茨城県
      栃木県 群馬県   埼玉県 千葉県
      東京都 神奈川県 新潟県 富山県
      石川県 福井県   山梨県 長野県
      岐阜県 静岡県   愛知県 三重県
      滋賀県 京都府   大阪府 兵庫県
      奈良県 和歌山県 鳥取県 島根県
      岡山県 広島県   山口県 徳島県
      香川県 愛媛県   高知県 福岡県
      佐賀県 長崎県   熊本県 大分県
      宮崎県 鹿児島県 沖縄県
    )[pref]
  end

  def dan
    %w(
      皆伝 十段 九段 八段 七段 六段 五段 四段 三段 二段 初段
      一級 二級 三級 四級 五級 六級 七級
    )[grade]
  end

  def dan_color
    if 3 <= grade && grade <= 10
      '#afeeee'
    elsif grade == 1 || grade == 2
      '#ff6347'
    elsif grade == 0
      '#ffd900'
    else
      '#98fb98'
    end
  end

  def self.dan
    array = []
    @dan_all.each.with_index(AbilitysheetIidx::Application.config.iidx_grade) { |d, i| array.push([d, i]) }
    array
  end

  def self.belongs
    array = []
    @pref_all.each_with_index { |p, i| array.push([p, i]) }
    array
  end

  # 登録時にemailを不要とする
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
