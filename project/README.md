# Fantasy Cricket App PCCI

A Fantasy Cricket application built with React, TypeScript, and Supabase.

## Features

- Real-time match updates and scores
- Player selection and team management
- Points calculation based on player performance
- Leaderboard tracking
- Team statistics

## Getting Started

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd fantasy-cricket-app-pcci
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   Create a `.env` file in the root directory and add your Supabase credentials:
   ```
   VITE_SUPABASE_URL=your_supabase_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. Start the development server:
   ```bash
   npm run dev
   ```

## Database Setup

The application uses Supabase as its database. The schema includes:

- Players table
- User teams
- Team players
- Match performances
- Fantasy teams
- Fantasy team selections

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.