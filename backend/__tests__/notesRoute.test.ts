import { beforeEach, describe, expect, it, vi } from "vitest";
import { NextRequest } from "next/server";
import { GET } from "../app/api/notes/route";
import { getNotesByUserId, getNotesCountByUserId } from "@/lib/noteService";
import { getAuth0ClaimsFromRequest, UnauthorizedError } from "@/lib/auth";
import { getOrCreateUserFromAuth0Claims } from "@/lib/userService";

vi.mock("@/lib/noteService", () => ({
  getNotesByUserId: vi.fn(),
  getNotesCountByUserId: vi.fn(),
}));

vi.mock("@/lib/auth", () => ({
  getAuth0ClaimsFromRequest: vi.fn(),
  UnauthorizedError: class UnauthorizedError extends Error {
    constructor(message = "Unauthorized") {
      super(message);
      this.name = "UnauthorizedError";
    }
  },
}));

vi.mock("@/lib/userService", () => ({
  getOrCreateUserFromAuth0Claims: vi.fn(),
}));

describe("GET /api/notes", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  function mockAuthenticatedUser() {
    vi.mocked(getAuth0ClaimsFromRequest).mockResolvedValue({
      sub: "auth0|route-user",
      name: "Route User",
    });
    vi.mocked(getOrCreateUserFromAuth0Claims).mockResolvedValue({
      id: "user-1",
      name: "Route User",
      auth0_sub: "auth0|route-user",
      created_at: "2026-07-18T10:00:00.000Z",
    });
  }

  it("returns paginated notes with default pagination", async () => {
    mockAuthenticatedUser();
    vi.mocked(getNotesByUserId).mockResolvedValue([
      {
        id: "note-1",
        user_id: "user-1",
        content: "Latest note",
        created_at: "2026-07-18T11:00:00.000Z",
        updated_at: "2026-07-18T11:00:00.000Z",
      },
    ]);
    vi.mocked(getNotesCountByUserId).mockResolvedValue(1);

    const response = await GET(
      new NextRequest("http://localhost:3000/api/notes"),
    );

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({
      notes: [
        {
          id: "note-1",
          user_id: "user-1",
          content: "Latest note",
          created_at: "2026-07-18T11:00:00.000Z",
          updated_at: "2026-07-18T11:00:00.000Z",
        },
      ],
      total: 1,
      limit: 50,
      offset: 0,
    });
    expect(getNotesByUserId).toHaveBeenCalledWith("user-1", 50, 0);
  });

  it("returns paginated notes for explicit limit and offset", async () => {
    mockAuthenticatedUser();
    vi.mocked(getNotesByUserId).mockResolvedValue([
      {
        id: "note-2",
        user_id: "user-1",
        content: "Second page note",
        created_at: "2026-07-18T10:00:00.000Z",
        updated_at: "2026-07-18T10:00:00.000Z",
      },
      {
        id: "note-3",
        user_id: "user-1",
        content: "Third page note",
        created_at: "2026-07-18T09:00:00.000Z",
        updated_at: "2026-07-18T09:00:00.000Z",
      },
    ]);
    vi.mocked(getNotesCountByUserId).mockResolvedValue(5);

    const response = await GET(
      new NextRequest("http://localhost:3000/api/notes?limit=2&offset=1"),
    );

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({
      notes: [
        {
          id: "note-2",
          user_id: "user-1",
          content: "Second page note",
          created_at: "2026-07-18T10:00:00.000Z",
          updated_at: "2026-07-18T10:00:00.000Z",
        },
        {
          id: "note-3",
          user_id: "user-1",
          content: "Third page note",
          created_at: "2026-07-18T09:00:00.000Z",
          updated_at: "2026-07-18T09:00:00.000Z",
        },
      ],
      total: 5,
      limit: 2,
      offset: 1,
    });
    expect(getNotesByUserId).toHaveBeenCalledWith("user-1", 2, 1);
  });

  it("returns an empty page when offset is beyond the result set", async () => {
    mockAuthenticatedUser();
    vi.mocked(getNotesByUserId).mockResolvedValue([]);
    vi.mocked(getNotesCountByUserId).mockResolvedValue(3);

    const response = await GET(
      new NextRequest("http://localhost:3000/api/notes?limit=10&offset=99"),
    );

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({
      notes: [],
      total: 3,
      limit: 10,
      offset: 99,
    });
    expect(getNotesByUserId).toHaveBeenCalledWith("user-1", 10, 99);
  });

  it("returns 400 for invalid pagination params", async () => {
    vi.mocked(getAuth0ClaimsFromRequest).mockResolvedValue({
      sub: "auth0|route-user",
    });

    const response = await GET(
      new NextRequest("http://localhost:3000/api/notes?limit=abc"),
    );

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toEqual({
      error: "limit must be a non-negative integer",
      status: 400,
    });
  });

  it("returns 401 when auth fails", async () => {
    vi.mocked(getAuth0ClaimsFromRequest).mockRejectedValue(
      new UnauthorizedError("Missing Authorization header"),
    );

    const response = await GET(
      new NextRequest("http://localhost:3000/api/notes"),
    );

    expect(response.status).toBe(401);
    await expect(response.json()).resolves.toEqual({
      error: "Missing Authorization header",
      status: 401,
    });
  });
});
