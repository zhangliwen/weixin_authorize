# encoding: utf-8
module WeixinAuthorize
  module Api
    module Template

      # 设置所属行业
      # 需要选择公众账号服务所处的2个行业，每月可更改1次所选行业；
      # 初始化行业时，传入两个，每月更改时，传入一个即可。
      def set_template_industry(industry_id1, industry_id2="")
        industries = {industry_id1: industry_id1}
        if industry_id2 != ""
          industries.merge!({industry_id2: industry_id2})
        end
        http_post("/template/api_set_industry", industries)
      end

      # 获得模板ID
      # code: 模板库中模板的编号，有“TM**”和“OPENTMTM**”等形式
      def add_template(code)
        http_post("/template/api_add_template", template_id_short: code)
      end

      # 发送模板消息
      def send_template_msg(touser, template_id, url, topcolor, data)
        msg = {
          touser: touser, template_id: template_id,
          url: url, topcolor: topcolor, data: data
        }
        http_post("/message/template/send", msg)
      end

    end
  end
end
