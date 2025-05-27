Kind = "exported-services"
Name = "finance"
Partition = "finance"
Services = [
  {
    ## The name and namespace of the service to export.
    Name      = "api"
    Namespace = "default"

    ## The list of peer clusters to export the service to.
    Consumers = [
      {
        Partition = "default"
      }
    ]
  }
]