# sepia-deployment-scripts

Scripts to setup a continuous deployment pipeline on AWS.

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

