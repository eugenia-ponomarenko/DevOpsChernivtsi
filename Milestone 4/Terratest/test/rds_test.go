package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/tree/master/modules/aws"
	"github.com/gruntwork-io/terratest/tree/master/modules/random"
	"github.com/gruntwork-io/terratest/tree/master/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsRDS(t *testing.T) {
	t.Parallel()

	expectedPort := int64(5432)
	expectedDatabaseName := "ss_demo_1"
	username := "postgres"
	password := "postgres"

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	instanceType := aws.GetRecommendedRdsInstanceType(t, awsRegion, "postgres", "12.9", []string{"db.t2.micro"})

	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../terraform",

		// Variables to pass to our Terraform code using -var options
		// "username" and "password" should not be passed from here in a production scenario.
		Vars: map[string]interface{}{
			"allocated_storage": 10,
			"engine_name":       "postgres",
			"engine_version":    "12.9",
			"instance_class":    instanceType,
			"username":          username,
			"password":          password,
			"port":              expectedPort,
			"database_name":     expectedDatabaseName,
			"region":            awsRegion,
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	dbInstanceID := terraform.Output(t, terraformOptions, "db_instance_id")

	// Look up the endpoint address and port of the RDS instance
	address := aws.GetAddressOfRdsInstance(t, dbInstanceID, awsRegion)
	port := aws.GetPortOfRdsInstance(t, dbInstanceID, awsRegion)
	schemaExistsInRdsInstance := aws.GetWhetherSchemaExistsInRdsMySqlInstance(t, address, port, username, password, expectedDatabaseName)
	// Lookup parameter values. All defined values are strings in the API call response
	generalLogParameterValue := aws.GetParameterValueForParameterOfRdsInstance(t, "general_log", dbInstanceID, awsRegion)
	allowSuspiciousUdfsParameterValue := aws.GetParameterValueForParameterOfRdsInstance(t, "allow-suspicious-udfs", dbInstanceID, awsRegion)

	// Verify that the address is not null
	assert.NotNil(t, address)
	// Verify that the DB instance is listening on the port mentioned
	assert.Equal(t, expectedPort, port)
	// Verify that the table/schema requested for creation is actually present in the database
	assert.True(t, schemaExistsInRdsInstance)
	// Booleans are (string) "0", "1"
	assert.Equal(t, "0", generalLogParameterValue)
	// Values not set are "". This is custom behavior defined.
	assert.Equal(t, "", allowSuspiciousUdfsParameterValue)
}
