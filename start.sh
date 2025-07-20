#!/usr/bin/env bash
cd build/ && cmake .. && cd .. && cmake --build build/ -j1 && ./build/discord-bot
