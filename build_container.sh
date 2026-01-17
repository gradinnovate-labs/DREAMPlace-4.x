#!/bin/bash

# Parse arguments
if [ "$1" = "--remove" ]; then
    echo "Removing existing dreamplace2:cuda image..."

    # Remove any containers using the image first
    CONTAINERS=$(podman ps -a -q -f ancestor=dreamplace2:cuda 2>/dev/null)
    if [ -n "$CONTAINERS" ]; then
        echo "Removing containers using dreamplace2:cuda..."
        podman rm $CONTAINERS
    fi

    # Now remove the image
    podman rmi dreamplace2:cuda 2>/dev/null && echo "Image removed successfully." || echo "No existing image to remove."
else
    podman build . --file Dockerfile --tag dreamplace2:cuda
fi
