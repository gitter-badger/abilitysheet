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

  context '#gigadelic_innocentwalls' do
    it 'incorrect' do
      expect(@res.send(:gigadelic_innocentwalls, 'test', 'elem')).to include('test')
    end
    elem = %(
    <dl class="731 hyper" style="background-image: url(http://beatmania-clearlamp.com/common/img/bg_mypage-music_on.png);">
    <dt class="EX"><span>.</span></dt>
    <dd class="level l12">.</dd>
    <dd class="musicName">gigadelic</dd>
    <dd class="exe">
    <form method="post" action="exe.php">
    <input type="hidden" name="userId" value="">
    <input type="hidden" name="musicId" value="731">
    <select name="lampId">
    <option value=""></option>
    <option value="1">FC</option>
    <option value="2" selected="selected">EX</option>
    <option value="3">H</option>
    <option value="4">C</option>
    <option value="5">E</option>
    <option value="6">A</option>
    <option value="7">F</option>
    <option value="8"></option>
    </select>
    </form>
    </dd>
    </dl>
    )
    it 'correct' do
      expect(@res.send(:gigadelic_innocentwalls, 'gigadelic', elem)).to include('gigadelic[H]')
    end
  end
  # HTMLの整形

  # 登録の正常判定
end
