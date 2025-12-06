// Zustand Store for Dashboard State
import { create } from 'zustand';

export const useStore = create((set) => ({
  selectedPeriod: '1M',
  setSelectedPeriod: (period) => set({ selectedPeriod: period }),
  
  // Real-time collaboration state (for Liveblocks integration)
  activeUsers: [],
  setActiveUsers: (users) => set({ activeUsers: users }),
  
  // Akane theme state
  theme: 'akane',
  setTheme: (theme) => set({ theme }),
}));

