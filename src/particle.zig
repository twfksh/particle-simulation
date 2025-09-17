const std = @import("std");
const c = @cImport({
    @cInclude("math.h");
});
const rl = @import("raylib");

const sqrt = std.math.sqrt;
const fmax = c.fmax;
const vec2 = rl.Vector2;
const Color = rl.Color;

pub const Particle = struct {
    const Self = @This();

    pos: vec2,
    vel: vec2,
    color: Color,

    fn getDist(self: *Self, otherPos: vec2) f64 {
        const dx = self.pos.x - otherPos.x;
        const dy = self.pos.y - otherPos.y;
        return sqrt((dx * dx) + (dy * dy));
    }

    fn getNormal(self: *Self, otherPos: vec2) vec2 {
        var dist = self.getDist(otherPos);
        if (dist == 0.0) dist = 1;
        const dx = self.pos.x - otherPos.x;
        const dy = self.pos.y - otherPos.y;
        const normal = vec2{ .x = dx * (1 / @as(f32, @floatCast(dist))), .y = dy * (1 / @as(f32, @floatCast(dist))) };
        return normal;
    }

    pub fn attract(self: *Self, posToAttract: vec2, multiplier: f32) void {
        _ = multiplier;

        const dist = fmax(self.getDist(posToAttract), 0.5);
        const normal = self.getNormal(posToAttract);

        self.vel.x -= normal.x / @as(f32, @floatCast(dist));
        self.vel.y -= normal.y / @as(f32, @floatCast(dist));
    }

    pub fn doFriction(self: *Self, amount: f32) void {
        self.vel.x *= amount;
        self.vel.y *= amount;
    }

    pub fn move(self: *Self, screenWidth: i32, screenHeight: i32) void {
        self.pos.x += self.vel.x;
        self.pos.y += self.vel.y;

        const w: f32 = @floatFromInt(screenWidth);
        const h: f32 = @floatFromInt(screenHeight);

        if (self.pos.x < 0) self.pos.x += w;
        if (self.pos.x >= w) self.pos.x -= w;
        if (self.pos.y < 0) self.pos.y += h;
        if (self.pos.y >= h) self.pos.y -= h;
    }

    pub fn drawPixel(self: *Self) void {
        rl.drawPixelV(self.pos, self.color);
    }
};
