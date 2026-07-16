# Backend Dockerfile
FROM node:20-alpine

WORKDIR /app

# Copy root package files (monorepo)
COPY package.json package-lock.json ./

# Copy backend package.json
COPY backend/package.json backend/

# Install dependencies for all workspaces
RUN npm ci

# Copy source code
COPY . .

# Build the Next.js app
RUN npm --workspace=backend run build

EXPOSE 3000

CMD ["npm", "--workspace=backend", "run", "dev"]
