module Mina
  module Helpers
    # Renders an ERB template on the server.
    #
    # Useful for config files :)
    #
    # render("templates/my_template.erb", "/tmp/file")
    #
    def render(template, out)
      unless settings.mina_packed?
        queue <<-CMD
          cat <<"EOF" > #{deploy_to}/tmp/settings.erb
<%
#{pack_settings}
%>
EOF
        CMD
        settings.mina_packed = true
      end
      queue "erb -T - #{deploy_to}/tmp/settings.erb #{template} > #{out}"
    end

    def pack_settings
      settings.map do |k,v|
        "#{k}=#{(v.is_a?(Proc) ? v.call : v).inspect}"
      end.join("\n")
    end

    def indent(count, str)
      str.gsub(/^(?!EOF$)/, "\t"*count)
    end
  end
end
