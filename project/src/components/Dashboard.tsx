import React, { useState, useEffect } from 'react';
import { Trophy, Calendar } from 'lucide-react';
import { fetchMatches, fetchTeamStats, Match, TeamStats } from '../lib/api';
import { supabase } from '../lib/supabase';

const Dashboard = () => {
  const [matches, setMatches] = useState<Match[]>([]);
  const [teamStats, setTeamStats] = useState<TeamStats[]>([]);
  const [loading, setLoading] = useState(true);
  const [userScore, setUserScore] = useState(0);
  const [userRank, setUserRank] = useState(0);

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      try {
        const [matchesData, statsData] = await Promise.all([
          fetchMatches(),
          fetchTeamStats()
        ]);
        setMatches(matchesData);
        setTeamStats(statsData);

        // Fetch user's fantasy team score
        const { data: teamData } = await supabase
          .from('fantasy_teams')
          .select('total_points')
          .order('total_points', { ascending: false });

        if (teamData) {
          const totalTeams = teamData.length;
          const userTeamIndex = teamData.findIndex(team => team.total_points === teamData[0]?.total_points);
          setUserScore(teamData[0]?.total_points || 0);
          setUserRank(userTeamIndex + 1);
        }
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
      </div>
    );
  }

  const upcomingMatches = matches.filter(match => !match.result).slice(0, 3);

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-gray-900">Fantasy IPL Dashboard</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-semibold mb-4">Your Team Score</h2>
          <div className="text-4xl font-bold text-indigo-600">{userScore}</div>
          <p className="text-gray-600 mt-2">Points earned this season</p>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-semibold mb-4">Your Rank</h2>
          <div className="flex items-center">
            <Trophy className="w-8 h-8 text-yellow-500 mr-2" />
            <span className="text-4xl font-bold">#{userRank}</span>
          </div>
          <p className="text-gray-600 mt-2">Out of {teamStats.length} teams</p>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-semibold mb-4">Upcoming Matches</h2>
          <div className="space-y-3">
            {upcomingMatches.map((match, index) => (
              <div key={index} className="flex items-center justify-between text-sm">
                <div className="flex items-center">
                  <Calendar className="w-4 h-4 text-gray-400 mr-2" />
                  <span>{match.team1} vs {match.team2}</span>
                </div>
                <span className="text-gray-500">{match.date}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
      
      <div className="bg-white p-6 rounded-lg shadow-md">
        <h2 className="text-xl font-semibold mb-4">IPL 2025 Points Table</h2>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="bg-gray-50">
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Team</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Matches</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Won</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Lost</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Points</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">NRR</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {teamStats.map((team, index) => (
                <tr key={index} className={index < 4 ? 'bg-green-50' : ''}>
                  <td className="px-6 py-4 whitespace-nowrap font-medium text-gray-900">{team.team}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-gray-500">{team.matches}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-gray-500">{team.won}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-gray-500">{team.lost}</td>
                  <td className="px-6 py-4 whitespace-nowrap font-semibold text-gray-900">{team.points}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-gray-500">{team.nrr}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
      
      <div className="bg-white p-6 rounded-lg shadow-md">
        <h2 className="text-xl font-semibold mb-4">Match Schedule</h2>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="bg-gray-50">
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Match</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Venue</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Time</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Result</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {matches.map((match, index) => (
                <tr key={index}>
                  <td className="px-6 py-4 whitespace-nowrap text-gray-500">{match.date}</td>
                  <td className="px-6 py-4 whitespace-nowrap font-medium text-gray-900">
                    {match.team1} vs {match.team2}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-gray-500">{match.venue}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-gray-500">{match.time}</td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    {match.result ? (
                      <span className="text-green-600">{match.result}</span>
                    ) : (
                      <span className="text-gray-400">Upcoming</span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;