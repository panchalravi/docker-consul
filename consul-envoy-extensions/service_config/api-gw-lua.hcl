Kind = "service-defaults"
Name = "gateway-api"
Protocol = "http"
EnvoyExtensions = [
  {
    Name = "builtin/lua",
    Arguments = {
      ProxyType = "api-gateway"
      Listener  = "outbound"
      Script    = <<-EOF

function envoy_on_response(handle)
  print("-----------------------------------------------")
  print("API Gateway, envoy_on_response, outbound")
  handle:logInfo("Outbound Response")
  local status = handle:headers():get(":status")
  i, j = string.find(status, "5")
  if i == 1 then
  -- Sets the content-type
    handle:logInfo("Received 5xx error response")
    handle:headers():replace("content-type", "text/html")
    handle:body():setBytes("<html><body><h2>Error while calling upstream service, please contact support!</h2></body></html>")
  end
  handle:headers():add("x-inbound-response", "x-inbound-response")
  print("-----------------------------------------------")
end
 EOF
    }
  }
]
