Azure Kubernetes Service (AKS) cluster distributes resources such as nodes and storage across logical sections of underlying Azure infrastructure. This deployment model when using availability zones, ensures nodes in a given availability zone are physically separated from those defined in another availability zone.

Availability zones are unique physical locations that are made up of one or more datacenters. Applications that are distributed across availability zones are distributed across physical regions, which protects them against failure of any single datacenter.

Multi-zone clusters are the next step in achieving high-availability in these failure scenarios, although they are quite rare. Here are some of the benefits of using one:

-    With the use of pod-replication practices, there is minimal downtime in the event of a node failure. Your service remains live while being hosted in a remote location, away from the failure zone.



In order to enable this feature, we are adding perameter in the Terraform module under default node pool as below.

-- availability_zones  = ["1", "2"]

By that we can able to enable avaibility zone during the creation of the cluster. Initially to test we are using 2 nodes. However we can also keep 1 node and put it over node scale (Which we already enables.)

Image Link {https://media.geeksforgeeks.org/wp-content/uploads/20210605202641/xmfgbdjh.PNG}

When you use availability zones for your Kubernetes cluster, you can make it highly available and protected against the failure of a single datacenter. 
