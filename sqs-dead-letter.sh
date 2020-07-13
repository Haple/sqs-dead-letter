#!/bin/sh

# Setup dead letter queue
dead_letter_queue_url=$(awslocal sqs create-queue --output text --queue-name test_queue_dead_letter)

echo "Dead Letter Queue URL: $dead_letter_queue_url"

dead_letter_queue_arn=$(awslocal sqs get-queue-attributes --queue-url $dead_letter_queue_url --output text --attribute-names QueueArn --query 'Attributes.QueueArn')

echo "Dead Letter Queue ARN: $dead_letter_queue_arn"

# Create queue
awslocal sqs create-queue \
	--queue-name test_queue \
	--attributes \
	'
	{
	  "RedrivePolicy": "{\"deadLetterTargetArn\":\"'"$dead_letter_queue_arn"'\",\"maxReceiveCount\":\"1\"}"
	}
	'
