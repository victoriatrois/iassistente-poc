import { NextRequest, NextResponse } from "next/server";
import { getNotesByUserId, getNotesCountByUserId } from "@/lib/noteService";
import { getAuth0ClaimsFromRequest, UnauthorizedError } from "@/lib/auth";
import { getOrCreateUserFromAuth0Claims } from "@/lib/userService";

const DEFAULT_LIMIT = 50;
const DEFAULT_OFFSET = 0;
const MAX_LIMIT = 100;

class BadRequestError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "BadRequestError";
  }
}

function parsePaginationNumber(
  rawValue: string | null,
  fallbackValue: number,
  label: string,
): number {
  if (rawValue === null) {
    return fallbackValue;
  }

  if (!/^\d+$/.test(rawValue)) {
    throw new BadRequestError(`${label} must be a non-negative integer`);
  }

  return Number.parseInt(rawValue, 10);
}

function parsePagination(searchParams: URLSearchParams) {
  const limit = parsePaginationNumber(
    searchParams.get("limit"),
    DEFAULT_LIMIT,
    "limit",
  );
  const offset = parsePaginationNumber(
    searchParams.get("offset"),
    DEFAULT_OFFSET,
    "offset",
  );

  if (limit <= 0) {
    throw new BadRequestError("limit must be greater than 0");
  }

  if (offset < 0) {
    throw new BadRequestError("offset must be greater than or equal to 0");
  }

  return {
    limit: Math.min(limit, MAX_LIMIT),
    offset,
  };
}

export async function GET(request: NextRequest) {
  try {
    const claims = await getAuth0ClaimsFromRequest(request);
    const { limit, offset } = parsePagination(request.nextUrl.searchParams);
    const user = await getOrCreateUserFromAuth0Claims(claims);

    const [notes, total] = await Promise.all([
      getNotesByUserId(user.id, limit, offset),
      getNotesCountByUserId(user.id),
    ]);

    return NextResponse.json({
      notes,
      total,
      limit,
      offset,
    });
  } catch (error: unknown) {
    if (error instanceof UnauthorizedError) {
      return NextResponse.json(
        { error: error.message, status: 401 },
        { status: 401 },
      );
    }

    if (error instanceof BadRequestError) {
      return NextResponse.json(
        { error: error.message, status: 400 },
        { status: 400 },
      );
    }

    console.error("Failed to load notes", error);

    return NextResponse.json(
      { error: "Failed to load notes", status: 500 },
      { status: 500 },
    );
  }
}
