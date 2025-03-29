import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { ArrowLeft, Trophy } from 'lucide-react';
import { supabase } from '../lib/supabase';

interface Player {
  id: string;
  name: string;
  team: string;
  role: string;
  round: number;
  points: number;
}

interface TeamDetails {
  id: string;
  name: string;
  owner: string;
  total_points: number;
  players: Player[];
}

const TeamDetails = () => {
  const { teamId } = useParams();
  const [teamDetails, setTeamDetails] = useState<TeamDetails | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchTeamDetails();
  }, [teamId]);

  const fetchTeamDetails = async () => {
    try {
      setLoading(true);
      setError(null);

      // Fetch team details
      const { data: teamData, error: teamError } = await supabase
        .from('fantasy_teams')
        .select('*')
        .eq('id', teamId)
        .single();

      if (teamError) throw teamError;

      // Fetch team's players with their match performance points
      const { data: playerData, error: playerError } = await supabase
        .from('fantasy_team_selections')
        .select(`
          round,
          players!inner (
            id,
            name,
            team,
            role,
            match_performances (
              points
            )
          )
        `)
        .eq('fantasy_team_id', teamId);

      if (playerError) throw playerError;

      // Process player data
      const players = playerData?.map((selection) => ({
        id: selection.players.id,
        name: selection.players.name,
        team: selection.players.team,
        role: selection.players.role,
        round: selection.round,
        points: selection.players.match_performances?.reduce((sum: number, perf: any) => sum + (perf.points || 0), 0) || 0
      })) || [];

      // Calculate total points
      const totalPoints = players.reduce((sum, player) => sum + player.points, 0);

      setTeamDetails({
        ...teamData,
        total_points: totalPoints,
        players
      });

    } catch (err) {
      console.error('Error fetching team details:', err);
      setError('Failed to load team details. Please try again later.');
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
      </div>
    );
  }

  if (error || !teamDetails) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="bg-red-50 border border-red-200 rounded-lg p-4 max-w-md">
          <p className="text-red-800">{error || 'Team not found'}</p>
          <Link
            to="/leaderboard"
            className="mt-2 text-sm text-red-600 hover:text-red-800 flex items-center"
          >
            <ArrowLeft className="w-4 h-4 mr-1" />
            Back to Leaderboard
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <Link
            to="/leaderboard"
            className="text-indigo-600 hover:text-indigo-800 flex items-center mb-2"
          >
            <ArrowLeft className="w-4 h-4 mr-1" />
            Back to Leaderboard
          </Link>
          <h1 className="text-3xl font-bold text-gray-900">{teamDetails.name}</h1>
          <p className="text-gray-600">Owned by {teamDetails.owner}</p>
        </div>
        <div className="text-center">
          <Trophy className="w-8 h-8 text-yellow-500 mx-auto" />
          <p className="text-sm text-gray-600 mt-1">Total Points</p>
          <p className="text-2xl font-bold text-indigo-600">{teamDetails.total_points || 0}</p>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        <div className="p-6">
          <h2 className="text-xl font-semibold mb-4">Team Players</h2>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-gray-50">
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Round</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Player</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Team</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Points</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {teamDetails.players.map((player) => (
                  <tr key={player.id}>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      Round {player.round}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap font-medium text-gray-900">
                      {player.name}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-gray-500">
                      {player.team}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-gray-500">
                      {player.role}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                        {player.points}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TeamDetails;