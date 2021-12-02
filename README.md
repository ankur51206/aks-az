Multi-zone clusters are the next step in achieving high-availability in these failure scenarios, although they are quite rare. Here are some of the benefits of using one:

-    With the use of pod-replication practices, there is minimal downtime in the event of a node failure. Your service remains live while being hosted in a remote location, away from the failure zone.
-    With node-failure, there is always a risk of data-loss for stateful applications, databases, etc. This can be mitigated if your application supports data-replication. CAS solutions like OpenEBS use live replica containers spread across zones for your high-availability storage needs.
