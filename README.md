# com-liferay-osb-pulpo-deployment-scripts-private

Scripts to setup a continuous deployment pipeline on AWS.

## Setup a Continous Deployment Pipeline
```
cd osb-pulpo-deployment-scripts/aws/deployment-pipeline/scripts/setup/codepipeline-setup
```
cd c
```
./setup_deployment_pipeline.sh -c $pulpodir/com-liferay-osb-pulpo-engine-assets-private/osb-pulpo-engine-assets-deployment/aws/deployment-pipeline/config
```

## Cleanup a Continous Deployment Pipeline
```
cd osb-pulpo-deployment-scripts/aws/deployment-pipeline/scripts/cleanup/codepipeline-cleanup
```

```
./cleanup_deployment_pipeline.sh -c $pulpodir/com-liferay-osb-pulpo-engine-assets-private/osb-pulpo-engine-assets-deployment/aws/deployment-pipeline/config
```

