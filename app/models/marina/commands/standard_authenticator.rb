module Marina
  module Commands
    class StandardAuthenticator
      def user_id_from session, cookies
        session[:user_id]
      end
    end
  end
end
