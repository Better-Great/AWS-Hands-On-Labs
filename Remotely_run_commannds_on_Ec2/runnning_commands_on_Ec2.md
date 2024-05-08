# Remotely Run Commands on an EC2 Instance with AWS Systems Manager

In this step-by-step guide, I'll be explaining how to use AWS Systems Manager to remotely run commands on your Amazon EC2 instances.



I'll do this by signing in to my AWS account with a user account I already made in IAM, not as the root user. I've chosen to use an IAM account because, for instance, if you're a sys admin, your organization's security team won't let you directly access production servers through SSH or use bastion hosts. Nevertheless, one of your job descriptions will be carrying out tasks like updating packages on your EC2 instances. So it is important to still carry out these tasks even with these limitations.

To solve this issue, we would create a user just in case you don't have an existing user. Then we will set up an Identity and Access Management (IAM) role while following best practices. Thereafter, we'll use the AWS-UpdateSSMAgent document to upgrade the Systems Manager Agent. Then, we'll use Systems Manager to send a command to various EC2 instances running.

## Assiging Permission to ther User
The first step is to log into the [AWS Management Console](https://console.aws.amazon.com). This gives us complete access to all privileges, so we can create users, user groups, and assign policies as needed.  
![rootuser](./images/rec2-1.png)

In the AWS Management Console, navigate to the IAM service by clicking on `Services` in the top left corner. Then, under the `Security, Identity, & Compliance` section, select "IAM. Another way to go about it is by simply typing **"IAM"** in the search bar and clicking on it from the results.

### **Step I: Creating A User and Usergroup**
1. While you're within the IAM console, click on `Users` in the left-hand navigation pane. Thereafter click on the `Create user` button.  
![create-user](./images/rec2-8.png) 

1. Enter a username for the new user, like "test-user." Then, select the type of access. For simplicity, I recommend choosing "Programmatic access," which will create an access key ID and secret access key.    
![user-name](./images/rec2-9.png)  
![user-name2](./images/rec2-10.png)
Click on the `Next` button.

1. After that, you'll see a tab to assign permissions to the user using `Add user to group`. The idea here is to gather all the permissions we want to give to the user into a single group. To do this, click on `Create group` to continue.
![usergroup](./images/rec2-11.png) 
1. However, since I already created a user, I'll just be adding a new user group to this user. Click on `User groups` on the left navigation bar, then select `Create group`.
![usergroup1](./images/rec2-13.png)

1. While you're in the user group settings, you can give the group a name like **"EC2SystemsManagerGroup"**. Then, select the user you want to attach this group to. 
![usergroup2](./images/rec2-16.png)
1. Since the aim of this usergorup is to enable the user being created to carry out tasks like updating necessary packages, we need to assign specific permissions. These permissions include `IAMFullAccess`, which grants full access to IAM privileges, `AmazonEC2FullAccess` for full access to EC2 resources, and `AmazonSSMManagedInstanceCore`, which provides the necessary permissions for basic Systems Manager (SSM) functionality on EC2 instances. By assigning these permissions, the user will have the authority to perform the required actions seamlessly within the AWS environment.
![usergroup3](./images/rec2-14.png)
![usergroup4](./images/rec2-15.png)

## **Step 2: Login to the User and Create Roles**
1. Once you've finished creating the user and usergroup and assinging the neccessary permissions, log out of the account you signed into as root. Then, log back in as an `IAM user`. Navigate to the IAM console by searching for it in the search bar. Within the IAM console, select `Roles` from the left navigation menu, and then proceed to create a new role.
![iam-login](./images/rec2-17.png)  
![iam-roles](./images/rec2-18.png)
 1.  On the Select trusted entity page, under `AWS Service`, choose `EC2`, and then choose `Next`.
 ![roles](./images/rec2-4.png)
 ![roles1](./images/rec2-5.png)
1. On the `Add permissions` page, type `AmazonEC2RoleforSSM` in the search bar. From the policy list that appears, select `AmazonEC2RoleforSSM,` and then click `Next` to proceed.
 ![roles2](./images/rec2-6.png)
1.  On the "Name, review, and create" page, enter *EnablesEC2ToAccessSystemsManagerRole* in the `Role name` box. In the `Description` box, type *Enables an EC2 instance to access Systems Manager.* Finally, click on `Create role` to complete the process.
![roles-description](./images/rec2-7.png)

## **Step 3: Create an EC2 instance**
1. At this point we will be creating an EC2 instance using the "EnablesEC2ToAccessSystemsManagerRole" role. This role will enable the EC2 instance to be managed by Systems Manager. To do this, search for EC2 on the search bar and click on it. Then on the EC2 dashboard, select your preferred region, I choose us-east1 and click on `launch instance`.
![ec2-a](./images/rec2-18.png)
![ec2-b](./images/rec2-19.png)  

1. In the box to assign a name to the instance, you can use "DemoSysAdmin," or any name you prefer. Then, select the operating system for the virtual machine, such as "Ubuntu," which is available for free tier accounts. Keep the default selection that appears in the dropdown menu.  
![ec2-c](./images/rec2-20.png)
![ec2-d](./images/rec2-21.png)

1. Choose the t2.micro instance type to assign adequate compute power to this virtual machine.
![ec2-e](./images/rec2-22.png)

1. Since we are using Systems Manager to run commands remotely, we wo't be needing a keypair. Therefore scroll down to the key pair option and select *Proceed without a key pair* on the dropdown box. 
![ec2-f](./images/rec2-23.png)

1. Keep the default settings under `Network settings` and `Configure storage`.
![ec2-g](./images/rec2-24.png)
![ec2-h](./images/rec2-25.png)
1. Under `Advanced details,` in the `IAM instance profile` dropdown, choose the "EnablesEC2ToAccessSystemsManagerRole" role we created earlier. Leave everything else as default, then click on `Launch instance`.  
![ec2-i](./images/rec2-26.png)
![ec2-j](./images/rec2-27.png)

## **Step 4:  Update the Systems Manager Agent**
Now that you have an EC2 instance running the Systems Manager agent, we can automate administrative tasks and manage the instance more efficiently. We will be running a pre-packaged command, known as a document, to upgrade the agent. It's considered a best practice to always update the Systems Manager Agent when you create a new instance, ensuring that we have the latest features and security patches.








