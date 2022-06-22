package main

import (
	"context"
	"flag"
	"fmt"
	"time"

	"encoding/json"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
	"github.com/aws/aws-sdk-go-v2/aws/retry"
	"github.com/aws/aws-sdk-go-v2/config"
)

// Constants for default values if none are supplied
const DEFAULT_TIMEOUT = 5000
const DEFAULT_REGION = "eu-central-1"

var (
	region      string
	secretArn   string
	timeout     int
)

func getCommandParams() {
	// Setup command line args
	flag.StringVar(&region, "r", DEFAULT_REGION, "The Amazon Region to use")
	flag.StringVar(&secretArn, "s", "", "The ARN for the secret to access")
	flag.IntVar(&timeout, "t", DEFAULT_TIMEOUT, "The amount of time to wait for any API call")

	// Parse all of the command line args into the specified vars with the defaults
	flag.Parse()

	// Verify that the correct number of args were supplied
	if len(region) == 0 || len(secretArn) == 0 {
		flag.PrintDefaults()
		panic("You must supply a region and secret ARN.  -r REGION -s SECRET-ARN")
	}
}

// This function will return the descrypted version of the Secret from Secret Manager using the supplied
// assumed role to interact with Secret Manager.  This function will return either an error or the
// retrieved and decrypted secret.
func GetSecret(ctx context.Context, cfg aws.Config) (*secretsmanager.GetSecretValueOutput, error) {
	client := secretsmanager.NewFromConfig(cfg)
	return client.GetSecretValue(ctx, &secretsmanager.GetSecretValueInput{
		SecretId: aws.String(secretArn),
	})
}

// The main function will pull command line arg and retrieve the secret.
// The resulting secret will be dumped as JSON to the output
func main() {

	// Get all of the command line data and perform the necessary validation
	getCommandParams()

	// Setup a new context to allow for limited execution time for API calls with a default of 200 milliseconds
	ctx, cancel := context.WithTimeout(context.TODO(), time.Duration(timeout)*time.Millisecond)
	defer cancel()

	// Load the config
	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion(region), config.WithRetryer(func() aws.Retryer {
		// NopRetryer is used here in a global context to avoid retries on API calls
		return retry.AddWithMaxAttempts(aws.NopRetryer{}, 1)
	}))

	if err != nil {
		panic("configuration error " + err.Error())
	}

	// Get the secret
	result, err := GetSecret(ctx, cfg)

	if err != nil {
		panic("Failed to retrieve secret due to error " + err.Error())
	}

	// Convert the secret into JSON
	var dat map[string]interface{}
	if err := json.Unmarshal([]byte(*result.SecretString), &dat); err != nil {
		fmt.Println("Failed to convert Secret to JSON")
		fmt.Println(err)
		panic(err)
	}

	// Get the secret value and dump the output in a manner that a shell script can read the data from the output
	for key, value := range dat {
		fmt.Printf("%s|%s\n", key, value)
	}
}