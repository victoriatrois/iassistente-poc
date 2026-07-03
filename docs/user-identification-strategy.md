# User Identification Strategy

## 1. Current Approach (Full Login System)

For the Proof of Concept (POC) phase, we chose to use a **Managed third-party authentication provider** to implement passwordless/biometric login. The specific provider will be selected following a dedicated technical spike.

### Why this approach?

- **Data privacy and security:** we want to ensure from day one that test users' data remains completely private.

- **Production-ready baseline:** avoids technical debt by building the foundation for real user accounts early.

- **Medium effort, high UX:** provides advanced authentication methods (like FaceID/TouchID or Passkeys) out-of-the-box without the massive effort of building a biometric auth backend from scratch.

- **Provider agnostic (for now):** the architecture relies on standard JSON Web Tokens (JWT), meaning we can build the backend middleware to accept standard JWTs while we run a spike to pick the exact provider.

- **Realistic testing:** Mobile application testing reflects the true user journey, including at least login, and session persistence.

> ❔ Do we want to implement the Sign up jorney at this early stage, or make use of a `POST /user` endpoint to create test users?

## 2. Architecture

The system uses an external provider to handle the complexity of authentication:

1. **Client authentication:** The mobile app integrates the provider's SDK to authenticate the user.
2. **Token retrieval:** Upon success, the provider issues a signed JWT to the mobile app.
3. **API requests:** The mobile app attaches this token in the `Authorization: Bearer <token>` header for all requests to our custom backend.
4. **Middleware validation:** The backend `userAuth` middleware intercepts the request, verifies the JWT signature against the provider's public keys (JWKS), extracts the user ID, and attaches the user context to the request.

## 3. Examples

### Client-side auth (Conceptual)

```javascript
// The mobile app handles auth via the provider's SDK
const session = await AuthProvider.signInWithBiometrics();
const token = session.jwt;
```

### Authenticated backend request

**Request:**

```http
GET /api/notes HTTP/1.1
Host: api.iassistente.local
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
```

**Response:**

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "user": "ext_provider_user_123",
  "data": [...]
}
```
