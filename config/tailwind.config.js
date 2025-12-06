const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  darkMode: 'class',
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
        mono: ['JetBrains Mono', ...defaultTheme.fontFamily.mono],
      },
      colors: {
        border: "hsl(var(--border) / <alpha-value>)",
        input: "hsl(var(--input) / <alpha-value>)",
        ring: "hsl(var(--ring) / <alpha-value>)",
        background: "hsl(var(--background) / <alpha-value>)",
        foreground: "hsl(var(--foreground) / <alpha-value>)",
        primary: {
          DEFAULT: "hsl(var(--primary) / <alpha-value>)",
          foreground: "hsl(var(--primary-foreground) / <alpha-value>)",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary) / <alpha-value>)",
          foreground: "hsl(var(--secondary-foreground) / <alpha-value>)",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive) / <alpha-value>)",
          foreground: "hsl(var(--destructive-foreground) / <alpha-value>)",
        },
        muted: {
          DEFAULT: "hsl(var(--muted) / <alpha-value>)",
          foreground: "hsl(var(--muted-foreground) / <alpha-value>)",
        },
        accent: {
          DEFAULT: "hsl(var(--accent) / <alpha-value>)",
          foreground: "hsl(var(--accent-foreground) / <alpha-value>)",
        },
        popover: {
          DEFAULT: "hsl(var(--popover) / <alpha-value>)",
          foreground: "hsl(var(--popover-foreground) / <alpha-value>)",
        },
        // Linear Midnight Theme (Premium, Technical, Invisible)
        // Background: Almost Black - adds depth
        background: '#0F0F10', // Deepest Grey/Black
        // Text: Soft White - High contrast but not harsh
        foreground: '#EEEFF1', // Soft White

        card: {
          DEFAULT: '#151516', // Slightly lighter than bg - Subtle separation
          foreground: '#EEEFF1', // Soft White text
        },
        popover: {
          DEFAULT: '#151516', // Same as card
          foreground: '#EEEFF1', // Soft White
        },
        // Primary: Blurple - Professional & Calm
        primary: {
          DEFAULT: '#5E6AD2', // "Blurple" - Professional & Calm
          foreground: '#FFFFFF', // Pure white for contrast
        },
        // Secondary: Nordic Grey - for secondary buttons
        secondary: {
          DEFAULT: '#222326', // Nordic Grey
          foreground: '#A0A0A0', // Muted grey text
        },
        // Muted: Cool Grey backgrounds
        muted: {
          DEFAULT: '#1A1B1E', // Dark grey for subtle backgrounds
          foreground: '#8A8F98', // Cool Grey text
        },
        // Accent: Hover states
        accent: {
          DEFAULT: '#282A2F', // Hover states
          foreground: '#EEEFF1', // Soft White
        },
        // Destructive: Soft Red for alerts
        destructive: {
          DEFAULT: '#D25E65', // Soft Red
          foreground: '#FFFFFF', // Pure white
        },
        // Borders: Subtle, high-quality borders
        border: '#2E3035', // Subtle, high-quality borders
        input: '#222326', // Input borders
        // Ring: Focus ring matches primary
        ring: '#5E6AD2', // Focus ring matches primary

        // Linear Midnight Theme Specific Colors
        theme: {
          'midnight-bg': '#0F0F10',      // Background - Almost Black
          'midnight-card': '#151516',     // Surface/Cards - Subtle separation
          'midnight-border': '#2E3035',   // Borders - Subtle, high-quality
          'blurple': '#5E6AD2',           // Primary - Blurple
          'soft-red': '#D25E65',         // Destructive - Soft Red
          'soft-white': '#EEEFF1',        // Text - Soft White
          'cool-grey': '#8A8F98',         // Muted text - Cool Grey
        },

        // Legacy Mappings (to prevent crashes, mapped to semantics)
        midnight: {
          950: '#0b1628',
          900: '#0E1E36',
          800: '#1a2c47',
          700: '#2d3f5c',
          600: '#574F72',
        },
        snow: {
          storm: '#F4B999',
          storm2: '#e2d5cc',
          storm3: '#9279AA',
        }
      },
      boxShadow: {
        'sm': '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
        DEFAULT: '0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1)',
        'md': '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
        'lg': '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.05)',
      },
      backgroundImage: {
        'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
      },
      animation: {
        'fade-in': 'fadeIn 0.3s ease-out',
        'slide-up': 'slideUp 0.3s ease-out',
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
      }
    },
  },
  plugins: []
}