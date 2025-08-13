# Custom AWS VPC Module

In our company devops.com we are creating subnets in 2 high availability zones

* VPC
* Internet gateway
* Attach internet gateway tp vpc
* 2 public subnets
* 2 private subnets
* 2 database subnets
* NAT gateway and elastic ip
* Public Route table
* Private Route table
* Database Route table
* Added routes in all route tables
* Added route tables in their particular subnets(route table asssociations)
* vpc peering
* added routes for peering in all subnet route tables(requestor & acceptor vpc)
* Database subnet group

## Inputs
* project_name(Required): we are forcing user to provide. Type is string
* environment(Optional): Default value is dev, type is string.
* common_tags(Required): we are forcing user to provide. Type is map
* vpc_cidr(Optional): Default value is 10.0.0.0/16. Type is string.
* enable_dns_hostnames(Optional): Default value is true. Type is bool.
* vpc_tags(Optional): Default value is empty. Type is map
* igw_tags(Optional): Default value is empty. Type is map
* public_subnet_tags(Optional): Default value is empty. Type is map
* public_subnet_cidrs(Required): User need to provide 2 public subnet cidrs
* private_subnet_tags(Optional): Default value is empty. Type is map
* private_subnet_cidrs(Required): User need to provide 2 private subnet cidrs
* database_subnet_tags(Optional): Default value is empty. Type is map
* database_subnet_cidrs(Required): User need to provide 2 database subnet cidrs
* db_subnet_group_tags(Optional): Default value is empty. Type is map
* nat_gw_tags(Optional): Default value is empty. Type is map
* public_route_tags(Optional): Default value is empty. Type is map
* private_route_tags(Optional): Default value is empty. Type is map
* database_route_tags(Optional): Default value is empty. Type is map
* is_peering_required(Optional): Default value is false. Type is bool
* peer_tags(Optional): Default value is empty. Type is map
* acceptor_vpc_id(Optional): Default value is empty. Type is string. Default vpc id would be taken

## Outputs
* vpc_id: we are getting created vpc id
* public_subnet_ids: we are getting created public subnet ids
* private_subnet_ids: we are getting created private subnet ids
* database_subnet_ids: we are getting created database subnet ids
* igw_id: we are getting created igw id


