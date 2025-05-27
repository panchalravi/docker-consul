Kind = "service-defaults"
Name = "web"
Protocol = "http"
EnvoyExtensions = [
  {
    Name = "builtin/lua",
    Arguments = {
      ProxyType = "connect-proxy"
      Listener  = "outbound"
      Script    = <<-EOF
function envoy_on_request(request_handle)
  print("-----------------------------------------------")
  -- request_handle:respond(
  -- {[":status"] = "302",
  -- ["location"] = "http://www.google.com.sg"},
  -- "nope")

  local headers, body = request_handle:httpCall(
  "api-v2.default.dc1.internal.e5061cdf-9eef-8ebf-6053-b808a05db76e.consul",
  {
    [":method"] = "GET",
    [":path"] = "/",
    [":authority"] = "api_v2"
  },
  nil,
  5000)

  request_handle:respond(
     {[":status"] = "200",
     ["upstream_foo"] = headers["foo"]},
     body)
  print("-----------------------------------------------")
end
 EOF
    }
  }
]
