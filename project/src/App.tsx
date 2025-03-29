import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Trophy, Users, Ticket as Cricket } from 'lucide-react';
import Navbar from './components/Navbar';
import Dashboard from './components/Dashboard';
import Leaderboard from './components/Leaderboard';
import MyTeam from './components/MyTeam';
import TeamDetails from './components/TeamDetails';

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-gray-100">
        <Navbar />
        <div className="container mx-auto px-4 py-8">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/leaderboard" element={<Leaderboard />} />
            <Route path="/my-team" element={<MyTeam />} />
            <Route path="/team/:teamId" element={<TeamDetails />} />
          </Routes>
        </div>
      </div>
    </Router>
  );
}

export default App;