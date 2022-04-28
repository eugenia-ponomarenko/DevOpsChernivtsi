package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsEC2(t *testing.T) {
	t.Parallel()

	folder := test_structure.CopyTerraformFolderToTemp(t, "../", "terraform/ec2")

	expectedName := fmt.Sprintf("Ubuntu WebServer")

	awsRegion := "eu-central-1"

	instanceType := "t2.micro"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: folder,

		Vars: map[string]interface{}{
			"instance_type": instanceType,
			"region":        awsRegion,
		},
	})

	terraform.InitAndApply(t, terraformOptions)

	defer terraform.Destroy(t, terraformOptions)

	instanceID := terraform.Output(t, terraformOptions, "instance_id")

	instanceTags := aws.GetTagsForEc2Instance(t, awsRegion, instanceID)

	nameTag, containsNameTag := instanceTags["Name"]
	assert.True(t, containsNameTag)
	assert.Equal(t, expectedName, nameTag)
}
