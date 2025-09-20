const std = @import("std");
const math = std.math;
const rl = @import("raylib");
const particle = @import("particle.zig");

const vec2 = rl.Vector2;
const Color = rl.Color;
const Particle = particle.Particle;
const randVal = rl.getRandomValue;

pub fn main() !void {
    const screenWidth = 1280;
    const screenHeight = 720;

    rl.setRandomSeed(1);

    const particleCount = 10000;
    var particles: [particleCount]Particle = undefined;

    for (&particles) |*item| {
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

        item.* = newParticle;
    }

    rl.initWindow(screenWidth, screenHeight, "Particles");
    defer rl.closeWindow();

    var camera = rl.Camera2D{
        .offset = .{ .x = 0, .y = 0 },
        .target = .{ .x = 0, .y = 0 },
        .rotation = 0,
        .zoom = 2,
    };

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        const mouseWheelMove = rl.getMouseWheelMove();
        if (mouseWheelMove != 0) {
            onMouseWheelScroll(&camera, mouseWheelMove);
        }

        const mouseWorldPos = rl.getScreenToWorld2D(rl.getMousePosition(), camera);
        const mousePos = vec2{ .x = mouseWorldPos.x, .y = mouseWorldPos.y };
        for (&particles) |*item| {
            item.attract(mousePos, 1);
            item.doFriction(0.99);
            item.move(screenWidth, screenHeight);
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.beginMode2D(camera);
        defer rl.endMode2D();

        rl.clearBackground(.black);

        for (&particles) |*item| {
            item.drawPixel();
        }

        rl.drawFPS(10, 10);
    }
}

fn onMouseWheelScroll(camera: *rl.Camera2D, mouseWheelMove: f32) void {
    const mouseScreenPos = rl.getMousePosition();
    const mouseWorldPos = rl.getScreenToWorld2D(mouseScreenPos, camera.*);
    camera.offset = mouseScreenPos;
    camera.target = mouseWorldPos;

    const scaleFactor = 0.2;
    const new_zoom = math.exp(math.log10(camera.zoom) + scaleFactor * mouseWheelMove);
    camera.zoom = math.clamp(new_zoom, 0.125, 64.0);
}
