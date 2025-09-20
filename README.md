# Particle Simulation

A particle physics simulation built with Zig and Raylib, featuring gravitational interactions.

## Prerequisites

- Zig 0.15.1 or later
- Raylib (handled automatically via Zig package manager)

## Building and Running

### Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd particles-simulation

# Build and run
zig build run
```

### Build Only

```bash
# Build the executable
zig build

# The executable will be in zig-out/bin/particles
./zig-out/bin/particles
```

### Development

```bash
# Run tests
zig build test

# Build with optimization
zig build -Doptimize=ReleaseFast
```

## Project Structure

```
gravitational-loss/
├── src/
│   ├── main.zig          # Main application entry point
│   └── particle.zig      # Particle system and physics logic
├── build.zig             # Build configuration
├── build.zig.zon         # Dependencies
└── README.md             # This file
```

## Acknowledgments

- Original C++ implementation by [codemaker4](https://github.com/codemaker4)
- Built with [Raylib](https://www.raylib.com/) - A simple and easy-to-use library to enjoy videogames programming
- Zig programming language for memory safety and performance and most importantly I love programming in Zig :)
