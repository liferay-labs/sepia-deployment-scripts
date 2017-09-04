# sepia-deployment-scripts

Scripts to setup a continuous deployment pipeline on AWS.

Sample repositories that can be used to set up a sample pipeline:

- https://github.com/liferay-labs/lexicon-test-portlet
- https://github.com/liferay-labs/lexicon-test-deployment

## Update deployment specifications
```
cd aws/deployment-pipeline/setup/codepipeline-setup
```

```
./update_deployment_specifications.sh -c $pulpodir/com-liferay-osb-pulpo-engine-assets-private/osb-pulpo-engine-assets-deployment/aws/deployment-pipeline/config
```

## Setup a Continous Deployment Pipeline
```
cd aws/deployment-pipeline/setup/codepipeline-setup
```

```
./setup_deployment_pipeline.sh -c $pulpodir/com-liferay-osb-pulpo-engine-assets-private/osb-pulpo-engine-assets-deployment/aws/deployment-pipeline/config
```

## Cleanup a Continous Deployment Pipeline
```
cd aws/deployment-pipeline/cleanup/codepipeline-cleanup
```

```
./cleanup_deployment_pipeline.sh -c $pulpodir/com-liferay-osb-pulpo-engine-assets-private/osb-pulpo-engine-assets-deployment/aws/deployment-pipeline/config
```

