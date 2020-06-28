describe WeixinAuthorize::Api::Custom do
  let(:text_message) do
    "text Custom message"
  end

  let(:image_path) do
    "#{File.dirname(__FILE__)}/medias/ruby-logo.jpg"
  end

  let(:image_file) do
    File.new(image_path)
  end

  it "#send_text_custom" do
    response = $client.send_text_custom(ENV["OPENID"], text_message)
    expect(response.code).to eq(WeixinAuthorize::OK_CODE)
  end

  it "#send_news_custom" do
    articles = [{
                  "title" => "Happy Day",
                  "description" => "Is Really A Happy Day",
                  "url"   => "http://www.baidu.com",
                  "picurl" => "http://www.baidu.com/img/bdlogo.gif"
                },
                {
                  "title" => "Happy Day",
                  "description" => "Is Really A Happy Day",
                  "url"  => "http://www.baidu.com",
                  "picurl"=> "http://www.baidu.com/img/bdlogo.gif"
                }]
    response = $client.send_news_custom(ENV["OPENID"], articles)
    expect(response.code).to eq(WeixinAuthorize::OK_CODE)
  end

  it "#send_image_custom" do
    image = $client.upload_media(image_file, "image")
    media_id = image.result["media_id"]
    response = $client.send_image_custom(ENV["OPENID"], media_id)
    expect(response.code).to eq(WeixinAuthorize::OK_CODE)
  end

  it "#send_video_custom" do
    pending("The test must have a media_id")
  end

  it "#send_music_custom" do
    pending("The test must have a media_id")
  end

  it "#send_voice_custom" do
    pending("The test must have a media_id")
  end

  it "#get_custom_msg_record" do
    option = {pageindex: 1, pagesize: 10}
    response = $client.get_custom_msg_record(Time.now - 10.days, Time.now, option)
    expect(response.code).to eq(WeixinAuthorize::OK_CODE)
    expect(response.result.keys).to eq(["recordlist", "retcode"])
  end

  it "#create_kf_session" do
    response = $client.create_kf_session("test1@test", ENV["APPID"], "test kfsession")
    expect(response.code).to eq(WeixinAuthorize::OK_CODE)
  end

end
