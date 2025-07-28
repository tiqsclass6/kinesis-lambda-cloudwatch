# AWS Kinesis Data Streams to AWS Lambda

![Terraform](https://img.shields.io/badge/Terraform-v1.5%2B-blue?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Kinesis%20%7C%20Lambda-orange?logo=amazon-aws)
![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen)
![Last Commit](https://img.shields.io/github/last-commit/aws-samples/serverless-patterns)

![Kinesis-Lambda-CloudWatch](/kinesis-lambda-cloudwatch.png)

This pattern creates an AWS Kinesis Data Stream, a stream consumer, and an AWS Lambda function. When data is added to the stream, the Lambda function is invoked.

Learn more about this pattern at Serverless Land Patterns: [https://serverlessland.com/patterns/kinesis-to-lambda-terraform](https://serverlessland.com/patterns/kinesis-to-lambda-terraform)

Important: this application uses various AWS services and there are costs associated with these services after the Free Tier usage - please see the [AWS Pricing page](https://aws.amazon.com/pricing/) for details. You are responsible for any AWS costs incurred. No warranty is implied in this example.

---

## Requirements

* [Create an AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) if you do not already have one and log in. The IAM user that you use must have sufficient permissions to make necessary AWS service calls and manage AWS resources.
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) installed and configured
* [Git Installed](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started) installed

---

## Deployment Instructions

1. Clone the project to your local working directory

   ```sh
   git clone https://github.com/aws-samples/serverless-patterns/ 
   ```

2. Change the working directory to this pattern's directory

   ```sh
   cd serverless-patterns/kinesis-lambda-terraform
   ```

3. From the command line, initialize, validate, format, and plan the terraform to downloads and installs the providers defined in the configuration:

    ```bash
    terraform init
    terraform validate
    terraform fmt
    terraform plan
    ```

4. From the command line, apply the configuration in the main.tf file:

    ```bash
    terraform apply
    ```

5. During the prompts:

   * Enter `yes`

---

## Testing

Use the Amazon Kinesis Data Generator for testing. The easiest way to use this tool is to use the [hosted generator](https://awslabs.github.io/amazon-kinesis-data-generator/web/producer.html) and follow the [setup instructions](https://awslabs.github.io/amazon-kinesis-data-generator/web/help.html).

After you have the generator configured, you should have a custom URL to generate data for your Kinesis data stream. In your configuration steps, you created a username and password. Log in to the generator using those credentials.

When you are logged in, you can generate data for your stream test.

1. Choose the region you deployed the application (i.e. us-east-1).

2. For Stream/delivery stream, select your stream.

3. For Records per second, keep the default value of `100`.

4. On the Template 1 tab, name the template `Sensor 1`.

5. Use the following template:

    ```JSON
    {
        "sensorId": {{random.number(50)}},
        "currentTemperature": {{random.number(
            {
                "min":10,
                "max":150
            }
        )}},
        "status": "{{random.arrayElement(
            ["OK","FAIL","WARN"]
        )}}"
    }
    ```

6. Choose `Send Data`.

7. After several seconds, choose `Stop Sending Data`.

---

## Cleanup

1. Delete all created resources by terraform

    ```bash
    terraform destroy
    ```

2. During the prompts:
    * Enter `yes`

3. Confirm all created resources has been deleted

    ```bash
    terraform show
    ```

---

## ✍️ Authors & Acknowledgments

* **Author:** T.I.Q.S.
* **Group Leader:** John Sweeney

---
