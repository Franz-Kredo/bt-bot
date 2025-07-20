#!/usr/bin/env bash
# Load environment from .env
if [ -f .env ]; then
  # export every key=value in .env (ignoring comments)
  export $(grep -v '^#' .env | xargs)
fi

# Build and run
cd build/ && cmake .. && cd .. && cmake --build build/ -j1 && ./build/discord-bot
