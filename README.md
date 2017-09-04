# sepia-deployment-scripts

Scripts to setup a continuous deployment pipeline on AWS.

Sample repositories that can be used to set up a sample pipeline:

- https://github.com/liferay-labs/lexicon-test-portlet
- https://github.com/liferay-labs/lexicon-test-deployment

## Fork repositories and clone them
```
cd ..
```

```
git clone https://github.com/<your-github-username>/lexicon-test-portlet.git
```

```
git clone https://github.com/<your-github-username>/lexicon-test-deployment.git
```

```
cd sepia-deployment-scripts
```

## Update deployment specifications

Manually edit the following environment file so it matches your environment:

`/lexicon-test-portlet/lexicon-test-deployment/aws/deployment-pipeline/config/setup_deployment_pipeline.env`


## Update deployment specifications
```
cd aws/deployment-pipeline/setup/codepipeline-setup
```

```
./update_deployment_specifications.sh -c $pulpodir/com-liferay-osb-pulpo-engine-assets-private/osb-pulpo-engine-assets-deployment/aws/deployment-pipeline/config
```

## Commit and push the changes made to the deployment repository


## Setup a Continuous Deployment Pipeline
```
cd aws/deployment-pipeline/setup/codepipeline-setup
```

```
./setup_deployment_pipeline.sh -c $pulpodir/lexicon-test-portlet/lexicon-test-deployment/aws/deployment-pipeline/config
```

## Cleanup a Continuous Deployment Pipeline
```
cd aws/deployment-pipeline/cleanup/codepipeline-cleanup
```

```
./cleanup_deployment_pipeline.sh -c $pulpodir/lexicon-test-portlet/lexicon-test-deployment/aws/deployment-pipeline/config
```

