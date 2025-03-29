import { supabase } from './supabase';

export interface Match {
  id: string;
  team1: string;
  team2: string;
  date: string;
  venue: string;
  time: string;
  result?: string;
}

export interface TeamStats {
  team: string;
  matches: number;
  won: number;
  lost: number;
  points: number;
  nrr: number;
}

// Mock data for matches
const mockMatches: Match[] = [
  {
    id: '1',
    team1: 'CSK',
    team2: 'RCB',
    date: '2025-03-22',
    venue: 'M.A. Chidambaram Stadium',
    time: '19:30',
    result: 'CSK won by 5 wickets'
  },
  {
    id: '2',
    team1: 'MI',
    team2: 'GT',
    date: '2025-03-23',
    venue: 'Wankhede Stadium',
    time: '19:30'
  },
  {
    id: '3',
    team1: 'DC',
    team2: 'KKR',
    date: '2025-03-24',
    venue: 'Arun Jaitley Stadium',
    time: '19:30'
  },
  {
    id: '4',
    team1: 'PBKS',
    team2: 'RR',
    date: '2025-03-25',
    venue: 'IS Bindra Stadium',
    time: '19:30'
  },
  {
    id: '5',
    team1: 'LSG',
    team2: 'SRH',
    date: '2025-03-26',
    venue: 'BRSABV Ekana Stadium',
    time: '19:30'
  }
];

// Mock data for team stats
const mockTeamStats: TeamStats[] = [
  {
    team: 'CSK',
    matches: 1,
    won: 1,
    lost: 0,
    points: 2,
    nrr: 0.5
  },
  {
    team: 'MI',
    matches: 0,
    won: 0,
    lost: 0,
    points: 0,
    nrr: 0
  },
  {
    team: 'RCB',
    matches: 1,
    won: 0,
    lost: 1,
    points: 0,
    nrr: -0.5
  },
  {
    team: 'GT',
    matches: 0,
    won: 0,
    lost: 0,
    points: 0,
    nrr: 0
  },
  {
    team: 'DC',
    matches: 0,
    won: 0,
    lost: 0,
    points: 0,
    nrr: 0
  },
  {
    team: 'KKR',
    matches: 0,
    won: 0,
    lost: 0,
    points: 0,
    nrr: 0
  },
  {
    team: 'PBKS',
    matches: 0,
    won: 0,
    lost: 0,
    points: 0,
    nrr: 0
  },
  {
    team: 'RR',
    matches: 0,
    won: 0,
    lost: 0,
    points: 0,
    nrr: 0
  },
  {
    team: 'LSG',
    matches: 0,
    won: 0,
    lost: 0,
    points: 0,
    nrr: 0
  },
  {
    team: 'SRH',
    matches: 0,
    won: 0,
    lost: 0,
    points: 0,
    nrr: 0
  }
];

export const fetchMatches = async (): Promise<Match[]> => {
  // Return mock data instead of fetching from external API
  return Promise.resolve(mockMatches);
};

export const fetchTeamStats = async (): Promise<TeamStats[]> => {
  // Return mock data instead of fetching from external API
  return Promise.resolve(mockTeamStats);
};