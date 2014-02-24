require 'digest/md5'
module Marina
  module Commands
    class WordpressAuthenticator
      def user_id_from session, cookies
        Marina::Db::Member.by_username(username_from(cookies))
      end

      def username_from cookies
        site_name = "#{request.protocol}#{request.host_with_port}"
        hash = Digest::MD5.hexdigest site_name
        value = cookies["wordpress_logged_in_#{hash}"].to_s.split('|').first
        return value
      end
    end
  end
end
