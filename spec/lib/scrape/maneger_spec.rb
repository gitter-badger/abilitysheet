require 'rails_helper'

describe 'lib/scrape/maneger.rb' do
  # 前処理
  before(:all) do
    @res = Scrape::Maneger.new(build(:user))
    @agent = Mechanize.new
  end

  # 登録されていない場合は空の配列を返す
  it 'returns empty array if is not registered' do
    expect(@res.url.empty?).to eq true
  end
  # 登録されている場合は/sp/を含むページの配列を1つ返す
  it 'returns array if is registered include /sp/' do
    user = build(:user, iidxid: '6570-6412')
    res = Scrape::Maneger.new(user)
    expect(res.url.count).to eq 1
    expect(res.url.first).to include('/sp/')
  end
  # 複数登録されている場合は/sp/を含む複数配列を返す
  it 'returns some array if is registered include /sp/' do
    user = build(:user, iidxid: '9447-8955')
    res = Scrape::Maneger.new(user)
    expect(res.url.count).to be >= 2
    res.url.each do |url|
      expect(url).to include('/sp/')
    end
  end
  # 登録されていない場合はfalseを返す
  it 'returns false if is not registered does not include /sp/' do
    expect(@res.sync).to eq false
  end
  # 全て一から問題なく通ることの確認のテスト
  it 'returns true if is all correct' do
    res = Scrape::Maneger.new(build(:user, iidxid: '3223-5186'))
    expect(res.sync).to eq true
  end
  # Lv12フォルダがない場合はnilを返す
  it 'returns nil if does not exist level 12 folder' do
    html = Nokogiri::HTML.parse(
      @agent.get('http://beatmania-clearlamp.com/djdata/ruquia7/sp/').body,
      nil,
      'UTF-8'
    )
    expect(@res.send(:folder_specific, html)).to eq nil
  end
  # 12フォルダが存在すればnokogiriのクラスを返す
  it 'returns nokogiri class if does exist level 12 folder' do
    html = Nokogiri::HTML.parse(
      @agent.get('http://beatmania-clearlamp.com/djdata/lib_sheet/sp/').body,
      nil,
      'UTF-8'
    )
    expect(@res.send(:folder_specific, html).is_a?(Nokogiri::XML::Element)).to be_truthy
  end
  # HTMLの整形
  # 登録の正常判定
end
