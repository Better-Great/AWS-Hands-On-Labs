# **Creating a Custom VPC on AWS**

In this article, I will explain how to create a custom domain name using Amazon services, specifically focusing on Virtual Private Cloud (VPC). AWS VPC provides a secure and flexible virtual networking environment, allowing you to set up your infrastructure according to your specific needs.

Creating a custom domain name within your VPC gives you complete control over your virtual network. With VPC, you can choose your own IP address ranges, design and set up subnets, and customize route tables and network gateways, like Network Address Translation (NAT) gateways. This level of control ensures that your network setup perfectly fits your business needs and security requirements.

You can also set up a hardware Virtual Private Network (VPN) connection between your company's data center and your VPC. This lets you use the AWS cloud as an extension of your company's network.  

#### **Generally, VPCs in AWS account are of 2 types;**
#### **Default VPC:** 
Each AWS account includes a default VPC that is pre-configured, allowing you to start using it right away. The default VPC comes with a CIDR block of 16 subnet masks, such as 172.31.0.0/16, which can provide up to 65,536 IP addresses. While the default VPC is convenient for creating instances for testing or learning about AWS, it's recommended to create a custom VPC for launching your other AWS resources in a production environment. A custom VPC offers more flexibility and control, ensuring it meets your specific business and security requirements..

#### **Custom VPC:**
A custom VPC allows you to customize a virtual network with your desired IP address range. You can create two types of subnets: public subnets and private subnets. Public subnets are accessible from the internet, making them suitable for resources like web servers, while private subnets are isolated from the internet, ideal for databases and other internal applications. This flexibility lets you design a network that fits your specific needs and enhances security and performance.

## **Prerequisites**
1. An AWS account. 
1. Understanding of AWS networking concepts (IP addressing, subnets, route tables, etc.)
1. Access to the AWS Management Console or AWS CLI
1. A valid user with permission for the creation and deletion of VPCs and EC2 instances.

## **Steps to Create a Custom VPC**
### **Step 1: Create a VPC** 
- Open the [AWS Management Console](https://aws.amazon.com/).
![aws-console](./images/rec2-1.png)
- After logging into your AWS Console, go to search bar and search for `VPC`, and click on it to open the VPC dashboard.. 
- On the VPC Dashboard, click on  `Create VPC`.
![aws-service](./images/p1.png)
![aws-vpc](./images/p2.png)

- Provide the necessary details, such as assigning a name for the VPC.
- Choose the **VPC only** option. 
- **IPv4 CIDR block**: Specify an IP range, e.g., `10.0.0.0/16`.
- **IPv6 CIDR block**: Optional. For IPv6 support, choose no IPv6 CIDR block.
- **Tenancy**:  Choose the default tenancy for instances launched in the VPC. 
- Click on `Create VPC` and wait for the VPC to be created. 

It's important to choose the VPC only option because selecting VPC and more will prompt AWS to create additional resources that you may want to configure manually later.     
![aws-vpc.config](./images/p3.png)
![aws-vpc.config2](./images/p4.png)

Click on your VPC and select edit VPC settings. Select enable DNS resolution and save.
![aws-vpc.created](./images/p5.png)
![vpc-editing](./images/p6.png)

### **Step 2: Create an internet gateway**
Now we have our VPC, but we need access to the internet. An internet gateway will help with that, so we need to create one.
- Click on `Internet Gateways` on the left pane of the VPC Dashboard.
- Click on `Create internet gateway`.
- Give it a name and click `Create internet `gateway`.
![vpc-igw](./images/p7.png)
![vpc](./images/p8.png)

Now we have an internet gateway and a VPC, but they are not connected yet. We need to attach the internet gateway to the VPC to enable internet access.
- Select the internet gateway you just created.
- Click on Actions and then select Attach to VPC.
- Choose the VPC you just created from the list.
- Click Attach internet gateway.
![igw-attach](./images/p9.png)
![igw-attached](./images/p10.png)
![igw-created1](./images/p11.png)

### **Subnets**
A subnet is a logical subdivision of a larger IP network. Simply put, a subnet divides a single network into multiple smaller networks or subnetworks. After creating a Virtual Private Cloud (VPC) in AWS, you need to define an IP address range for the VPC. This IP address range is then divided into smaller sections called subnets. Each subnet represents a distinct network segment within the VPC, with its own unique IP address range.

Subnets are used to organize resources within the VPC, such as EC2 instances, databases, and load balancers. By placing resources in different subnets, you can control the flow of traffic between them and apply specific security and routing rules.

For example, you might create public subnets for resources that need to be accessible from the internet, like web servers, and private subnets for resources that should not be directly accessible from the internet, like application servers or databases. This organization helps ensure better security and traffic management within your VPC.

## **Step 3: Creating Subnets**
- On the VPC Dashboard, click Subnets on the left pane.
- Now, click on `Create subnet` to create a subnet.
- Provide a name for the subnet.
- Select the VPC you just created.
- Choose an availability zone.
- Specify a range within your VPC, such as, `10.0.0.0/24`.
- We will be creating four subnets, two which are public and the others private. 
![subetting](./images/p12.png)
![private-subnet](./images/p13.png)
![private-subnet1](./images/p14.png)
![private](./images/p15.png)
![private](./images/p16.png)
![public-subnet](./images/p17.png)
![public-subnet1](./images/p18.png)
![pulic](./images/p19.png)
![pulic](./images/p20.png)
![review-subnet](./images/p21.png)

### **Step 4: Create Route Tables**
Route tables act like traffic controllers, determining where network traffic is directed or routed. Every subnet in a VPC is associated with a route table, which contains a set of rules (called routes) that specify where traffic from resources within that subnet should be sent.

The route table associated with a public subnet typically has a route that directs internet-bound traffic to an internet gateway. This route essentially tells the traffic, "If you want to go to the internet, use the internet gateway."

In contrast, a private subnet is meant for resources that should not be directly accessible from the internet, like application servers or databases. The route table associated with the private subnet does not have a route to the internet gateway. However, if resources in the private subnet need to access the internet (e.g., for software updates or external API calls), the route table can include a route that directs internet-bound traffic to a NAT gateway (Network Address Translation gateway). The NAT gateway acts like a middleman, allowing resources in the private subnet to access the internet while keeping them hidden from direct access.

- Click on `Route Tables` in the left-hand menu.
- Click on `Create Route Table`.
- Provide a name and select your VPC.
- One route table will be created for the private subets
![create-route-table](./images/p22.png)
![private-route](./images/p23.png)
![private-route](./images/p24.png)
- Another route table will then e created for the public subnets. 
![public-route](./images/p25.png)
![public-route1](./images/p26.png)
![review-route-table](./images/p27.png)

.

### **Step 5: Associate the Route Table**
Now that we have our private and public route tables, we need to associate these route tables with their respective subnets.  
**Private**
- Select the private route table.
- Click on Edit subnet associations.
- Choose ONLY the private subnets you created.
- Click Save association
![attach-private](./images/p29.png)
![attach-private1](./images/p30.png)
**Public**
- Select the public route table.
- Click on Edit subnet associations.
- Choose ONLY the public subnets you created.
- Click Save associations
![attach-public](./images/p28.png)
![attach-public1](./images/p31.png)
![attach-public2](./images/p32.png)

### **Conclusion**
Congratulations! You've successfully created your first custom VPC on AWS. By following these steps, you've set up a robust and secure virtual network tailored to your specific needs. You've learned how to create a custom VPC with a designated IP address range, divide it into public and private subnets, and set up an internet gateway to enable internet access. Additionally, you configured route tables and associated them with the appropriate subnets to manage traffic flow. 











