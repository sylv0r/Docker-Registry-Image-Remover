# Docker-Registry-Image-Remover
Script to delete images in a private Docker registry

Your registry need to be in a Docker container, and you need to have access to the container.


## Script installation :

You need to modify the script to match your configuration :
- dockerRegistryName : the name of the registry docker container
- auth : the authentification to access the registry (example : "-u root:password")
- registryUrl : the url of the registry (example : "localhost:5000" or "myregistry.com" or "myregistry.com:5000" ...)


Run the script in the server where the registry container is running.

## Delete a single image :
```bash
bash ./delete-image.sh <image_name>
```

example:
```bash
bash ./delete-image.sh my_image
```

## Delete all images :
/!\ Be careful, this will delete all images in the registry for the eternity /!\
```bash
bash ./delete-all-images.sh
```

