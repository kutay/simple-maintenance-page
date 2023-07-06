#!/bin/bash

if [ -n "$(git status --porcelain)" ]; then 
  echo -e "Cannot release : There are uncommited changes in your working directory"
  exit 1
fi

echo -e "Computing next version"

NEXT_TAG=$(./scripts/nextsemver.sh $1)

echo -e "Releasing version $NEXT_TAG"

git tag -a $NEXT_TAG -m "v${NEXT_TAG}"

echo -e "Pushing tag"
git push origin $NEXT_TAG

echo -e "Building Docker image"

docker build -t orkhonfr/simple-maintenance-page .

echo -e "Pushing Docker image"

docker push orkhonfr/simple-maintenance-page:$NEXT_TAG
docker push orkhonfr/simple-maintenance-page:latest