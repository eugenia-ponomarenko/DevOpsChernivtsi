package test

import (
	"testing"

	"github.com/eugenia-ponomarenko/terratest/modules/aws"
	"github.com/eugenia-ponomarenko/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsRDS(t *testing.T) {
	t.Parallel()

	expectedDatabaseName := "ss_demo_1"
	username := "postgres"
	password := "postgres"

	awsRegion := "eu-central-1"
	instanceType := aws.GetRecommendedRdsInstanceType(t, awsRegion, "postgres", "12.9", []string{"db.t2.micro"})

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../terraform/rds",

		Vars: map[string]interface{}{
			"allocated_storage": 10,
			"engine_name":       "postgres",
			"engine_version":    "12.9",
			"instance_class":    instanceType,
			"username":          username,
			"password":          password,
			"database_name":     expectedDatabaseName,
			"region":            awsRegion,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	dbInstanceID := terraform.Output(t, terraformOptions, "db_instance_id")

	address := aws.GetAddressOfRdsInstance(t, dbInstanceID, awsRegion)
	port := aws.GetPortOfRdsInstance(t, dbInstanceID, awsRegion)
	schemaExistsInRdsInstance := aws.GetWhetherSchemaExistsInRdsMySqlInstance(t, address, port, username, password, expectedDatabaseName)
	// Lookup parameter values. All defined values are strings in the API call response
	generalLogParameterValue := aws.GetParameterValueForParameterOfRdsInstance(t, "general_log", dbInstanceID, awsRegion)
	allowSuspiciousUdfsParameterValue := aws.GetParameterValueForParameterOfRdsInstance(t, "allow-suspicious-udfs", dbInstanceID, awsRegion)

	assert.NotNil(t, address)

	assert.True(t, schemaExistsInRdsInstance)

	assert.Equal(t, "0", generalLogParameterValue)

	assert.Equal(t, "", allowSuspiciousUdfsParameterValue)
}
