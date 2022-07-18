require 'json'

$secret1 = ENV["SECRET_VALUE_1"]
$secret2 = ENV["SECRET_VALUE_2"]
    
def lambda_handler(event:, context:)
    
    # TODO implement
    { statusCode: 200, body: JSON.generate('Hello from Ruby Lambda Function deployed with TF ! This is a secret: %s. This is a secret: %s.' % [$secret1, $secret2]) }
end
