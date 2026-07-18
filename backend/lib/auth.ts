import { createRemoteJWKSet, jwtVerify, type JWTPayload } from "jose";
import { type NextRequest } from "next/server";
import type { Auth0Input } from "@/lib/userService";

export class UnauthorizedError extends Error {
  constructor(message = "Unauthorized") {
    super(message);
    this.name = "UnauthorizedError";
  }
}

function readStringClaim(payload: JWTPayload, key: string): string | null {
  const value = payload[key];

  return typeof value === "string" && value.trim() ? value : null;
}

function getAuth0Issuer(): string {
  const issuerBaseUrl = process.env.AUTH0_ISSUER_BASE_URL?.trim();

  if (!issuerBaseUrl) {
    throw new Error("AUTH0_ISSUER_BASE_URL is not set");
  }

  return issuerBaseUrl.endsWith("/") ? issuerBaseUrl : `${issuerBaseUrl}/`;
}

function getAuth0Audience(): string {
  const audience = process.env.AUTH0_AUDIENCE?.trim();

  if (!audience) {
    throw new Error("AUTH0_AUDIENCE is not set");
  }

  return audience;
}

function getBearerToken(request: NextRequest): string {
  const authorization = request.headers.get("authorization")?.trim();

  if (!authorization) {
    throw new UnauthorizedError("Missing Authorization header");
  }

  const [scheme, token] = authorization.split(/\s+/, 2);
  if (scheme !== "Bearer" || !token) {
    throw new UnauthorizedError("Invalid Authorization header");
  }

  return token;
}

function getJwks(issuer: string) {
  return createRemoteJWKSet(new URL(".well-known/jwks.json", issuer));
}

export async function getAuth0ClaimsFromRequest(
  request: NextRequest,
): Promise<Auth0Input> {
  const issuer = getAuth0Issuer();
  const audience = getAuth0Audience();
  const token = getBearerToken(request);

  try {
    const { payload } = await jwtVerify(token, getJwks(issuer), {
      issuer,
      audience,
    });

    if (typeof payload.sub !== "string" || !payload.sub.trim()) {
      throw new UnauthorizedError("Auth0 sub is missing from token");
    }

    return {
      sub: payload.sub,
      name: readStringClaim(payload, "name"),
      username:
        readStringClaim(payload, "preferred_username") ??
        readStringClaim(payload, "nickname"),
      email: readStringClaim(payload, "email"),
    };
  } catch (error: unknown) {
    if (error instanceof UnauthorizedError) {
      throw error;
    }

    throw new UnauthorizedError("Invalid access token");
  }
}
