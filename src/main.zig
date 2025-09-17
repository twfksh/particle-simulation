const std = @import("std");
const rl = @import("raylib");
const particle = @import("particle");

const vec2 = rl.Vector2;
const Color = rl.Color;
const Particle = particle.Particle;
const randVal = rl.getRandomValue;

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const screenWidth = 800;
    const screenHeight = 800;

    rl.setRandomSeed(1);

    const particleCount = 10000;
    var particles = std.array_list.Managed(Particle).init(allocator);
    try particles.ensureTotalCapacityPrecise(particleCount);
    defer particles.deinit();

    // Initialize particles with random positions and velocities
    for (0..particleCount) |_| {
        const pos = vec2{
            .x = @floatFromInt(randVal(0, screenWidth - 1)),
            .y = @floatFromInt(randVal(0, screenHeight - 1)),
        };
        const vel = vec2{
            .x = @as(f32, @floatFromInt(randVal(-100, 100))) / 100.0,
            .y = @as(f32, @floatFromInt(randVal(-100, 100))) / 100.0,
        };
        const color = Color{ .r = 255, .g = 255, .b = 255, .a = 255 };

        const newParticle = Particle{
            .pos = pos,
            .vel = vel,
            .color = color,
        };
        try particles.append(newParticle);
    }

    rl.initWindow(screenWidth, screenHeight, "Gravitational Loss - Particles");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        const mousePos = vec2{ .x = @floatFromInt(rl.getMouseX()), .y = @floatFromInt(rl.getMouseY()) };
        for (particles.items) |*item| {
            item.attract(mousePos, 1);
            item.doFriction(0.99);
            item.move(screenWidth, screenHeight);
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        for (particles.items) |*item| {
            item.drawPixel();
        }

        rl.drawFPS(10, 10);
    }
}
