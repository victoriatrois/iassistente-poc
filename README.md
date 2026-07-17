# iAssistente POC - Speech-to-Text Notes App

A proof-of-concept mobile app for capturing and managing voice-to-text notes.

## 📋 Overview

**iAssistente** lets users:

- 🎤 Record voice notes and automatically convert to text
- 💾 Save notes with automatic association to their user
- 📖 View and manage their saved notes
- 🔒 Keep notes private and personal

**Status:** POC - Phase 1 (User Identification) Ready to Start

---

## 🚀 Quick Start

### Prerequisites

- **Docker & Docker Compose**
- **Node.js 22.11.0+** & npm
- **Git**
- **Xcode** for iOS development on macOS
- **Android Studio** for Android development

### Setup and Run

**⚠️ Prerequisites Check:**

- Docker Desktop is running (`docker --version` in terminal)
- Node.js installed (`node --version` returns v22.11.0 or higher)
- Git installed (`git --version` works)

**1. Create local environment file:**

Navigate to the project root folder and run:

```bash
cp .env.example .env.local
```

Open `.env.local` in your editor and set local values. For the Docker workflow in this repository, use:

```
POSTGRES_DB=<your database name>
POSTGRES_USER=<your database user>
POSTGRES_PASSWORD=<your database password>
DATABASE_URL=<postgresql connection string>
```

**2. Start backend + database:**

In your terminal, from the project root:

```bash
npm run services:up
```

**Wait for the services to report healthy startup**

✅ You'll know it's ready when the backend and database containers stay up and `npm run services:ps` shows them running.

**3. Start frontend (open a NEW terminal tab/window):**

```bash
cd frontend
npm start
```

**Wait for Metro to start successfully.**

**4. Choose your platform:**

**iOS** (Mac only):

```bash
npm run ios
```

**Android** (with Android Studio):

```bash
npm run android
```

If this is your first iOS run, or native dependencies changed, run:

```bash
cd frontend
bundle install
bundle exec pod install
```

---

**✅ Success = All 3 running:**

- Backend terminal: API logs appearing
- Frontend terminal: Metro bundler running
- Device/Simulator: App displaying

---

## 📚 Documentation

For detailed information, see:

| Topic                      | File                                                                    |
| -------------------------- | ----------------------------------------------------------------------- |
| Full Architecture          | [speech-to-text-poc.md](docs/speech-to-text-poc.md)                     |
| User Stories & Roadmap     | [user-stories.md](docs/user-stories.md)                                 |
| Task Breakdown (25 tasks)  | [implementation-tasks.md](docs/implementation-tasks.md)                 |
| Database Schema & Commands | [postgres-commands.md](docs/postgres-commands.md)                       |
| Setup Reference            | [project-setup-steps-followed.md](docs/project-setup-steps-followed.md) |

---

## 🔧 Essential Commands

### Docker (Backend + Database)

```bash
npm run services:up      # Start all services
npm run services:down    # Stop all services
npm run services:logs    # View live logs
npm run services:ps      # List running services
```

### Development

```bash
npm run dev              # Backend server from root workspace
cd frontend && npm start # Frontend Metro bundler
```

---

## 🐛 Troubleshooting

| Issue                 | Solution                                                                           |
| --------------------- | ---------------------------------------------------------------------------------- |
| Port 5432/3000 in use | `lsof -i :5432` or `lsof -i :3000`, then stop the conflicting process              |
| Database won't start  | `npm run services:logs` to inspect the PostgreSQL container                        |
| Backend error         | `npm run services:down` then `npm run services:up` to recreate local services      |
| Frontend fails        | `npm start -- --reset-cache && npm install`                                        |

---

## 📂 Project Structure

```
iassistente-poc/
├── backend/               # Next.js API + database services
├── frontend/              # React Native mobile app
├── docs/                  # Documentation files
├── scripts/               # Automation scripts
├── infra/                 # Docker & database setup
│   ├── docker-compose.yml # Orchestrates PostgreSQL + Backend
│   └── init.sql           # Auto-creates database schema
├── package.json           # Root: shared dev tools
├── README.md              # This file
└── ...
```

---

## 👥 Contributing

1. **Start Docker**

   ```bash
   npm run services:up
   ```

2. **Start Frontend** (in another terminal)

   ```bash
   cd frontend
   npm start
   ```

3. **Pick a task** from [implementation-tasks.md](docs/implementation-tasks.md) — start with Phase 1

4. **Create a feature branch**

   ```bash
   git checkout -b feat/task-name
   ```

5. **Follow conventional commits**
   ```bash
   git commit -m "feat(backend): description"
   ```

See [implementation-tasks.md](docs/implementation-tasks.md) for full task details and dependencies.

---

## 📖 Architecture

See [speech-to-text-poc.md](docs/speech-to-text-poc.md) for:

- User identification flow
- Note creation & retrieval workflows
- Database schema design
- Complete API specifications

---

## 🎯 Development Roadmap

**5 Phases | 25 concrete tasks** (~15-30 days depending on team size)

1. **Phase 1:** User Identification (backend blocker)
2. **Phase 2:** Core Backend Features
3. **Phase 3:** Frontend Foundation
4. **Phase 4:** Feature Implementation
5. **Phase 5:** Error Handling & Polish

See [user-stories.md](docs/user-stories.md) for detailed breakdown and critical path.

---

**Last Updated:** July 17, 2026 | **Setup:** Workspace + Docker | **Status:** Phase 1 Ready
