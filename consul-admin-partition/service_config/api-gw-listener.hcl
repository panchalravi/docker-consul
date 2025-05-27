Kind = "api-gateway"
Name = "gateway-api"
Partition = "default"

// Each listener configures a port which can be used to access the Consul cluster
Listeners = [
    {
        Port = 8080
        Name = "api-gw-listener"
        Protocol = "http"
    }
]