# sepia-deployment-scripts

Scripts to setup a continuous deployment pipeline on AWS.

## Prerequisites

- [Dockerhub account]()
- [AWS account]()
- [Github Account]()
- [Travis Account]()

 
## Initial setup 
 
Sample repositories that can be used to set up a sample pipeline:

Fork these repositories:

- https://github.com/liferay-labs/lexicon-test-portlet
- https://github.com/liferay-labs/lexicon-test-deployment

Then, add your fork lexicon-test-portlet repository to your Travis account and 
make sure you set the following environment variables:

| Variable              | |
| AWS_ACCOUNT_ID        | |
| AWS_ACCESS_KEY_ID     | |
| AWS_SECRET_ACCESS_KEY | |
| DOCKER_ORG            | |
| DOCKER_USER           | |
| DOCKER_PWD            | |
| GITHUB_TOKEN          | |

## Creating and updating the pipeline

