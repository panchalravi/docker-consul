Kind           = "service-resolver"
Name           = "api"
ConnectTimeout = "15s"
Failover = {
  "*" = {
    Targets = [
      {Peer = "dc2-default"}
    ]   
  }
}
