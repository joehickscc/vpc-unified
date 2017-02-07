######################################################################
## Create a vpc, igw and attach the igw to the vpc
######################################################################
coreo_aws_vpc_vpc "${VPC_NAME}${SUFFIX}" do
  action :sustain
  cidr "${VPC_OCTETS}/16"
  internet_gateway true
  region "${REGION}"
  tags ${VPC_TAGS}
end

######################################################################
## create a routetable for the public subnet
## route everything to the internet gateway
######################################################################

coreo_aws_vpc_routetable "${PUBLIC_ROUTE_NAME}${SUFFIX}" do
  action :sustain
  vpc "${VPC_NAME}${SUFFIX}"
  routes [
             { :from => "0.0.0.0/0", :to => "${VPC_NAME}${SUFFIX}", :type => :igw }
        ]
  number_of_tables 1
  region "${REGION}"
end

######################################################################
## Create a Public Subnet
##
## cidr will be split up among all zones specified in "number_of_zones"
##
## percent_of_vpc_allocated split, but use only this percentage of the
## entire vpc range
######################################################################

coreo_aws_vpc_subnet "${PUBLIC_SUBNET_NAME}${SUFFIX}" do
  action :sustain
  number_of_zones ${SUBNET_NUM_ZONES}
  percent_of_vpc_allocated 25
  route_table "${PUBLIC_ROUTE_NAME}${SUFFIX}"
  vpc "${VPC_NAME}${SUFFIX}"
  map_public_ip_on_launch true
  region "${REGION}"
end

######################################################################
## create a routetable for the private subnet
######################################################################

coreo_aws_vpc_routetable "${PRIVATE_ROUTE_NAME}${SUFFIX}" do
  action :create
  vpc "${VPC_NAME}${SUFFIX}"
  number_of_tables ${PRIVATE_ROUTE_NUM_TABLES}
  region "${REGION}"
end

######################################################################
## create a private subnet
######################################################################

coreo_aws_vpc_subnet "${PRIVATE_SUBNET_NAME}${SUFFIX}" do
  action :sustain
  number_of_zones ${SUBNET_NUM_ZONES}
  percent_of_vpc_allocated 50
  route_table "${PRIVATE_ROUTE_NAME}${SUFFIX}"
  vpc "${VPC_NAME}${SUFFIX}"
  region "${REGION}"
end

