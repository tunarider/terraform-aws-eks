resource "aws_iam_policy" "eks_cloudwatch_metrics" {
  name = "EKSCloudWatchMetrics"
  path = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "cloudwatch:PutMetricData"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        }
      ]
    }
  )
}

resource "aws_iam_policy" "eks_elb_permission" {
  name = "EKSELBPermission"
  path = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeAddresses",
            "ec2:DescribeInternetGateways"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        }
      ]
    }
  )
}
