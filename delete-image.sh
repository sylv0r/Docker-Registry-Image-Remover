#!/bin/bash

# Variables : 

# Your registry URL
registryUrl='localhost:5000'

# Your registry auth
auth='-u user:password'

# Repository to delete (taken from command line argument)
repo=$0

# Docker registry name
dockerRegistryName='my-registry'


echo "Processing repository: $repo"

# Get the list of tags for the repository
tags=$(curl $auth -s -k "http://${registryUrl}/v2/${repo}/tags/list" | jq -r '.tags[]' 2>/dev/null)

if [ -n "$tags" ]; then
    # Loop through each tag
    for tag in $tags; do
        echo "Processing tag: $tag"

        # Get the manifest digest for the tag
        digest=$(curl $auth -sI -k \
        -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
        "http://${registryUrl}/v2/${repo}/manifests/${tag}" \
        | tr -d '\r' | sed -En 's/^Docker-Content-Digest: (.*)/\1/p')

        if [ -n "$digest" ]; then
            # Delete the image using the digest
            curl $auth -X DELETE -sI -k "http://${registryUrl}/v2/${repo}/manifests/${digest}"
            echo "Deleted: $repo:$tag"
        else
            echo "Failed to retrieve digest for: $repo:$tag"
        fi
    done
else
    echo "No tags found for repository: $repo"
fi

# Run garbage collection to clean up deleted artifacts
echo "Running garbage collection..."
docker exec -it $dockerRegistryName /bin/registry garbage-collect --delete-untagged /etc/docker/registry/config.yml

echo "Garbage collection completed."

echo "Hard delete the repo folder..."
docker exec -it $dockerRegistryName rm -rf /var/lib/registry/docker/registry/v2/repositories/$repo
echo "Hard delete the repo folder completed."

echo "Repository deletion completed."