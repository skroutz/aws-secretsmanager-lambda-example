require 'json'

$secret = ENV["SECRET_VALUE"]
    
def lambda_handler(event:, context:)
    
    # TODO implement
    { statusCode: 200, body: JSON.generate('Hello from Ruby Lambda Function deployed with TF ! This is a secret: %s' %[$secret] ) }
end
