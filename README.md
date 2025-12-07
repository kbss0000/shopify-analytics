# XenoInsights

A modern, high-performance analytics dashboard for Shopify merchants, built with Ruby on Rails 7 and Hotwire. Designed for speed, clarity, and actionable intelligence.

## Overview

XenoInsights aggregates critical store data—revenue, orders, and customer behavior—into a unified, real-time interface. It features a "futuristic minimal" aesthetic (Osaka Jade theme) and integrated AI tools for natural language data querying.

## Key Features

*   **Real-time Dashboard:** Live tracking of revenue trends, order volume, and key performance indicators.
*   **AI Analyst:** Natural language interface powered by Llama 3.3 (via Groq) to answer questions like "Who are my top customers?" or "Show me last week's revenue."
*   **Customer Insights:** Detailed profiles and ranking of high-value customers.
*   **Modern UI/UX:** Glassmorphism design, responsive layout, and dark mode optimization using Tailwind CSS.
*   **Performance:** Fast page loads via Turbo Drive and Stimulus controllers.

## Tech Stack

*   **Backend:** Ruby on Rails 7, PostgreSQL, Sidekiq, Redis
*   **Frontend:** Tailwind CSS, Hotwire (Turbo + Stimulus), Chart.js
*   **AI:** Groq API (Llama-3-70b-versatile)
*   **Deployment:** Docker, Render

## Screenshots

<!-- Add your screenshots in the 'screenshots' folder with these names -->

![Dashboard Overview](screenshots/dashboard.png)
*Dashboard Overview*

![AI Analyst](screenshots/ai-analyst.png)
*AI Analyst Interface*

![Login Screen](screenshots/login.png)
*Secure Login*

## Getting Started

### Prerequisites

*   Ruby 3.2+
*   PostgreSQL
*   Redis
*   Groq API Key

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/kbss0000/shopify-analytics.git
    cd shopify-analytics
    ```

2.  Install dependencies:
    ```bash
    bundle install
    ```

3.  Setup database:
    ```bash
    rails db:setup
    ```

4.  Configure environment:
    Create a `.env` file (or set system variables) with:
    ```
    GROQ_API_KEY=your_key_here
    ```

5.  Start the server:
    ```bash
    bin/dev
    ```

## License

MIT License.
