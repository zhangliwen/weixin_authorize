# encoding: utf-8
module WeixinAuthorize
  module Api
    module Mass

      MSG_TYPE = ["mpnews", "image", "text", "voice", "mpvideo"].freeze

      # media_info= {"media_id" media_id}
      # https://api.weixin.qq.com/cgi-bin/message/mass/sendall?access_token=ACCESS_TOKEN
      def mass_with_group(group_id, media_info, msgtype="mpnews", is_to_all=false)
        group_option = {filter: {group_id: group_id, is_to_all: is_to_all}}
        media = generate_media(msgtype, media_info, group_option)

        mass_url = "#{mass_base_url}/sendall"
        http_post(mass_url, media)
      end

      # https://api.weixin.qq.com/cgi-bin/message/mass/send?access_token=ACCESS_TOKEN
      # if mpvideo,
      # media_info= {"media_id" => media_id, "title" => "title", "description" => "description"}
      def mass_with_openids(openids, media_info, msgtype="mpnews")
        openid_option = {touser: openids}
        media = generate_media(msgtype, media_info, openid_option)
        mass_url = "#{mass_base_url}/send"
        http_post(mass_url, media)
      end

      # 请注意，只有已经发送成功的消息才能删除删除消息只是将消息的图文详情页失效，已经收到的用户，还是能在其本地看到消息卡片。
       # 另外，删除群发消息只能删除图文消息和视频消息，其他类型的消息一经发送，无法删除。
      def mass_delete_with_msgid(msg_id)
        mass_url = "#{mass_base_url}/delete"
        http_post(mass_url, {msg_id: msg_id})
      end

      # 预览接口【订阅号与服务号认证后均可用】
      def mass_preview(openid, media_info, msg_type="mpnews")
        openid_option = {touser: openid}
        media = generate_media(msg_type, media_info, openid_option)
        mass_url = "#{mass_base_url}/preview"
        http_post(mass_url, media)
      end

      # 查询群发消息发送状态【订阅号与服务号认证后均可用】
      def mass_get_status(msg_id)
        mass_url = "#{mass_base_url}/get"
        http_post(mass_url, {"msg_id" => msg_id})
      end

      private

        def mass_base_url
          "/message/mass"
        end

        def generate_media(msg_type, media_info, option)
          msg_type = msg_type.to_s
          if not MSG_TYPE.include?(msg_type)
            raise MediaTypeException, "#{msg_type} is a invalid msg_type"
          end
          {
            msg_type  => convert_media_info(msg_type, media_info),
            "msgtype" => msg_type
          }.merge(option)
        end

        # 如果用户填写的media信息，是字符串，则转换来符合的数据结构，如果 是hash，则直接使用用户的结构。
        def convert_media_info(msg_type, media_info)
          if media_info.is_a?(String)
            if msg_type == "text"
              return {content: media_info}
            else
              return {media_id: media_info}
            end
          end
          media_info
        end

    end
  end
end
