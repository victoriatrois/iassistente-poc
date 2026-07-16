# Auth Provider Decision

## Context:

This proof of concept aims to validate a secure, production-viable authentication foundation for our note-taking app, with initial focus on users in Brazil.

Target users are a small group of people collaborating to validate the solution.

Must-have requirements are:

- Email/password authentication
- Social login (for later and minimum: Google and Apple)
- Secure token/session handling suitable for mobile apps
- Clear, predictable pricing for POC and early production growth

Options compared (3): one subsection per provider with Pros, Cons, and Fit for this POC.

| Provider | Pros | Cons | Verdict |
|---|---|---|---|
| Supabase | - Clear pricings<br>- Neat concept definition (Users, Identities, Sessions)<br>- Nice flow-based how tos |  | Quite appeling to use |
| Auth0 | - Customizable authentication for developers<br>- Explicitly mentions passwordless authentication<br>- Next.js and React.js specific quick stater sample| Free up to 25,000 monthly active users (competitors are free for longer) | Very appeling to use |
| Clerk | - Complete solution<br>- Includes billing if ever needed<br>- Clear pricings<br>- Next.js and React.js specific documentation<br>- Unlimited applications<br>- 50,000 Monthly Recurring Users (MRU) limit per app |  | Appeling to use |
| Firebase |  | - Confusing pricing conditions<br>- Confusing documentation | Not appealing to use |

Among the 4 providers listed above, we decided to go with Auth0 due to its developer-centreed documentation, we might test how to implement supabase.
