import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { Trophy, Users, Ticket as Cricket } from 'lucide-react';

const Navbar = () => {
  const location = useLocation();

  const isActive = (path: string) => {
    return location.pathname === path ? 'bg-indigo-700' : '';
  };

  return (
    <nav className="bg-indigo-600 text-white">
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <Link to="/" className="flex items-center space-x-2">
            <Cricket className="w-8 h-8" />
            <span className="text-xl font-bold">Fantasy IPL</span>
          </Link>
          
          <div className="flex space-x-4">
            <Link
              to="/"
              className={`flex items-center space-x-1 px-3 py-2 rounded-md ${isActive('/')}`}
            >
              <Users className="w-5 h-5" />
              <span>Dashboard</span>
            </Link>
            
            <Link
              to="/my-team"
              className={`flex items-center space-x-1 px-3 py-2 rounded-md ${isActive('/my-team')}`}
            >
              <Users className="w-5 h-5" />
              <span>My Team</span>
            </Link>
            
            <Link
              to="/leaderboard"
              className={`flex items-center space-x-1 px-3 py-2 rounded-md ${isActive('/leaderboard')}`}
            >
              <Trophy className="w-5 h-5" />
              <span>Leaderboard</span>
            </Link>
          </div>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;