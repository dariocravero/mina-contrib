module Mina
  module Contrib
    module Helpers
      # Renders an ERB template on the server.
      #
      # Useful for config files :)
      #
      # render("templates/my_template.erb", "/tmp/file")
      #
      def render(template, out)
        unless settings.mina_packed?
          queue "<% #{pack_settings} %>"
          settings.mina_packed = true
        end
        queue "erb -T - #{deploy_to}/tmp/settings.erb #{template} > #{out}"
      end

      def pack_settings
        settings.map { |k,v| "#{k}=#{v}" }.join("\n")
      end
    end
  end
end
