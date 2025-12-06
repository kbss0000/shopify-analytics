# Shopify Analytics Dashboard

A full-stack analytics platform for Shopify merchants, featuring real-time sales visualization, AI-driven data insights, and a premium Shadcn-inspired UI.

**Live Demo:** [https://shopify-analytics-le8r.onrender.com](https://shopify-analytics-le8r.onrender.com)

**Login Credentials:** `demo@example.com` / `password123`

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [API Documentation](#api-documentation)
- [Screenshots](#screenshots)
- [Assumptions and Design Decisions](#assumptions-and-design-decisions)
- [Bonus Features](#bonus-features)

## Features

### Core Features

- **Real-time Analytics**: Interactive charts for revenue, orders, and customer growth using Chartkick.
- **Multi-Tenant Architecture**: Secure data isolation for multiple shops using Devise authentication.
- **Background Processing**: Asynchronous job handling for reliable webhook processing and data syncing.
- **Modern UI/UX**: Responsive, dark-mode-first design with smooth animations and glassmorphism effects.

### AI Features (Powered by Groq)

- **Natural Language Queries**: Ask questions about your data (e.g., "Who are my top customers?") and get instant answers.
- **SQL Generation**: The AI converts natural language into safe SQL queries to fetch real-time data.
- **Data Insights**: Automated analysis of sales trends and customer behavior.

### Authentication

- **Secure Login**: Devise-based authentication system.
- **Tenant Isolation**: Each user has their own isolated data scope.
- **Protected Routes**: Secure API endpoints and dashboard access.

## Tech Stack

### Frontend

| Technology | Purpose |
|Data Visualization|
| **Tailwind CSS** | Styling & Design System |
| **Stimulus.js** | Interactive JavaScript |
| **Chartkick** | Data Visualization |
| **Shadcn UI** | Component Design System |
| **Heroicons** | Icons |

### Backend

| Technology | Purpose |
|------------|---------|
| **Ruby on Rails 7** | Web Framework |
| **PostgreSQL** | Production Database |
| **Sidekiq** | Background Jobs |
| **Devise** | Authentication |
| **Groq API** | AI/LLM Integration |

### Deployment

| Service | Purpose |
|---------|---------|
| **Render** | Web Service & Database Hosting |
| **Docker** | Containerization |

## Project Structure

```
shopify-analytics/
├── app/
│   ├── controllers/    # Request handlers
│   ├── models/         # Database models
│   ├── views/          # ERB templates
│   ├── jobs/           # Background jobs
│   └── javascript/     # Stimulus controllers
├── config/             # Application configuration
├── db/                 # Database migrations & seeds
├── docs/               # Documentation assets
├── spec/               # RSpec tests
├── bin/                # Executables
└── README.md
```

## Setup Instructions

### Prerequisites

- Ruby 3.2.2
- PostgreSQL
- Redis

### Local Development

1. **Clone the Repository**

   ```bash
   git clone https://github.com/kbss0000/shopify-analytics.git
   cd shopify-analytics
   ```

2. **Install Dependencies**

   ```bash
   bundle install
   ```

3. **Setup Database**

   ```bash
   rails db:setup
   ```

4. **Environment Variables**
   Create a `.env` file with the following:

   ```bash
   GROQ_API_KEY=your_groq_api_key
   SHOPIFY_API_SECRET=your_shopify_secret
   ```

5. **Start the Server**

   ```bash
   ./bin/dev
   ```

   The app will be available at `http://localhost:3000`.

## API Documentation

### AI Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/ai/ask` | Process natural language query |

### Webhooks

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/webhooks/shopify` | Receive Shopify events |

### Dashboard

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/dashboard` | Main analytics view |
| GET | `/reports` | Detailed reports |

## Screenshots

### Dashboard Overview

Real-time statistics with interactive charts and data tables.

![Dashboard Screenshot](docs/screenshot.png)

## Assumptions and Design Decisions

### Architecture Decisions

- **Monolith Structure**: Chosen for simplicity and rapid development speed using Rails 7.
- **Server-Side Rendering**: Used ERB with Turbo/Stimulus for a fast, SPA-like feel without the complexity of a separate frontend.
- **PostgreSQL**: Robust relational database for structured e-commerce data.

### UI/UX Decisions

- **Dark Theme**: Optimized for data visualization and reduced eye strain.
- **Akane Palette**: A custom color scheme (Oxford Blue, Peach, Violet) for a unique, premium look.
- **Mobile First**: Fully responsive design for on-the-go access.

## Bonus Features

- **AI Analyst**: Integrated Llama 3 via Groq for instant data analysis.
- **Live Deployment**: Fully deployed on Render with automated builds.
- **Idempotent Seeding**: Robust `db:seed` script for easy deployment and testing.

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Author

**Kasilanka Bhoopesh Siva Srikar**
