# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zprofile.pre.zsh"
eval "$(/opt/homebrew/bin/brew shellenv)"

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zprofile.post.zsh"
# aikido-endpoint-cert-config-start
# Allow Node.js tooling to trust the SafeChain MITM CA while preserving public roots.
[[ -f "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-combined-ca.pem" ]] && \
  export NODE_EXTRA_CA_CERTS="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-combined-ca.pem"
# aikido-endpoint-cert-config-end
# aikido-endpoint-pip-cert-config-start
# Allow Python package managers to trust the SafeChain MITM CA while preserving user-provided roots.
if [[ -f "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-pip-combined-ca.pem" ]]; then
  export PIP_CERT="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-pip-combined-ca.pem"
  export REQUESTS_CA_BUNDLE="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-pip-combined-ca.pem"
  export POETRY_CERTIFICATES_PYPI_CERT="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-pip-combined-ca.pem"
fi
export UV_SYSTEM_CERTS=true
# aikido-endpoint-pip-cert-config-end
# aikido-endpoint-ruby-cert-config-start
# Allow Ruby Bundler to trust the SafeChain MITM CA while preserving public roots.
[[ -f "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-ruby-combined-ca.pem" ]] && \
  export BUNDLE_SSL_CA_CERT="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-ruby-combined-ca.pem"
# aikido-endpoint-ruby-cert-config-end
# aikido-endpoint-curl-cert-config-start
# Allow curl and other OpenSSL-linked tools to trust the SafeChain MITM CA while preserving the system roots.
[[ -f "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-openssl-combined-ca.pem" ]] && \
  export CURL_CA_BUNDLE="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-openssl-combined-ca.pem"
# aikido-endpoint-curl-cert-config-end
