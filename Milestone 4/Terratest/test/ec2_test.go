package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/tree/master/modules/aws"
	"github.com/gruntwork-io/terratest/tree/master/modules/random"
	"github.com/gruntwork-io/terratest/tree/master/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/tree/master/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsEC2(t *testing.T) {
	t.Parallel()

	// Make a copy of the terraform module to a temporary directory. This allows running multiple tests in parallel
	// against the same terraform module.
	terraformFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "terraform")

}
