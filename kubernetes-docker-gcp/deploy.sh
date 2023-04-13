# this deploy.sh script gets executed if there is a new release (ie. change to the master branch)

# build the images (a second time, as the first was the travis-ci test)
# -t specifies the tag, if no tag specified 'latest' is implicitly used, use twice, first for latest
# -t 2nd tag uses git commit identifier SHA as the version 'git rev-parse head'
# as $SHA environment variable created in .travis.yml
docker build -t cygnetops/multi-client-k8s:latest -t cygnetops/multi-client-k8s:$SHA -f ./client/Dockerfile ./client
docker build -t cygnetops/multi-server-k8s-pgfix:latest -t cygnetops/multi-server-k8s-pgfix:$SHA -f ./server/Dockerfile ./server
docker build -t cygnetops/multi-worker-k8s:latest -t cygnetops/multi-worker-k8s:$SHA -f ./worker/Dockerfile ./worker

# push new images to Docker Hub using credentials as specified in .travis.yml
# each image must be pushed twice, once for each tag (latest & SHA)
docker push cygnetops/multi-client-k8s:latest
docker push cygnetops/multi-server-k8s-pgfix:latest
docker push cygnetops/multi-worker-k8s:latest

docker push cygnetops/multi-client-k8s:$SHA
docker push cygnetops/multi-server-k8s-pgfix:$SHA
docker push cygnetops/multi-worker-k8s:$SHA

# execute kubectl from within the travis-ci environment as built in .travis.yml
# which included config of the GCP environment
kubectl apply -f k8s

# if this is not the first build, k8s will see it is already running 'latest' if that tag is used
# imperatively set the exact image/version to be used for each deployment using the unique SHA version tag
kubectl set image deployments/server-deployment server=cygnetops/multi-server-k8s-pgfix:$SHA
kubectl set image deployments/client-deployment client=cygnetops/multi-client-k8s:$SHA
kubectl set image deployments/worker-deployment worker=cygnetops/multi-worker-k8s:$SHA