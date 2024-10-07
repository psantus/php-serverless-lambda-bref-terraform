# PHP on AWS Lambda with Bref framework, deployed with Terraform

This repository shows how to
* instrument a Symfony Demo Application 
with Bref framework, that provides a Lambda runtime for PHP.
* deploy the application with Terraform.

It supports my blog post series "How to run PHP on AWS ServerLess architecture"
* Part 1 : [What's serverless?](https://dev.to/aws-builders/how-to-run-php-on-aws-serverless-architecture-part-1-whats-serverless-3j3m)
* Part 2: [Introducing Bref runtime](https://dev.to/aws-builders/how-to-run-php-on-aws-serverless-architecture-part-2-introducing-bref-runtime-168j)

## Deploying
After logging on AWS with your CLI, just run 
```
terraform apply
```
 
The data.sql file contains the necessary data to seed the Aurora database. 
You can deploy it with a bastion. 

## Result
![Screenshot of running app](bref-screenshot.png)
![Articles can be edited!](bref-screenshot2.png)

# Get in touch!
