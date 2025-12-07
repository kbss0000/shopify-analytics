# config/initializers/content_security_policy.rb
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self, :https, "https://www.gstatic.com", "https://cdn.jsdelivr.net", "https://unpkg.com", "https://ga.jspm.io", :unsafe_inline, :unsafe_eval # For Chartkick/Chart.js
    policy.style_src   :self, :https, :unsafe_inline # unsafe_inline needed for some Tailwind/Charts
    # policy.report_uri "/csp-violation-report-endpoint"
  end
  
  # Disable nonces - using unsafe_inline instead
  # config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  # config.content_security_policy_nonce_directives = %w(script-src style-src)
end
