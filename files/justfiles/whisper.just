whisper:
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    
    echo "${b}Setting up Whisper NPU Server${n}"
    
    # Create whisper directory structure
    WHISPER_DIR="$HOME/.whisper"
    MODELS_DIR="$WHISPER_DIR/models"
    mkdir -p "$MODELS_DIR"
    
    # Check if whisper-small model already exists
    if [ ! -d "$MODELS_DIR/whisper-small" ]; then
        echo "Downloading whisper-small model..."
        cd "$MODELS_DIR"
        # Skip smudge to avoid downloading LFS objects during initial clone
        GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/mecattaf/whisper-small
        cd whisper-small
        git lfs pull
        cd ..
    else
        echo "whisper-small model already exists"
    fi
    
    # Pull the container image
    echo "Pulling whisper-npu-server container..."
    podman pull ghcr.io/mecattaf/whisper-npu-server:latest
    
    echo "${b}Setup almost complete!${n}"
    echo "Enabling the systemd service"
    systemctl --user daemon-reload
    systemctl --user enable --now whisper-npu.container
    echo ""
    
    echo "${b}Whisper NPU Server setup complete!${n}"
    echo "You can test it with murmur.nvim"
