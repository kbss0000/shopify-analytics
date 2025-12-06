// React Dashboard Component with Akane Theme (using React.createElement for importmap compatibility)
import React from 'react';
import { motion } from 'framer-motion';
import { useStore } from '../stores/dashboardStore';

export function Dashboard({ stats }) {
  const { selectedPeriod, setSelectedPeriod } = useStore();

  const statCards = [
    { label: 'Total Revenue', value: stats?.total_revenue, color: '#9279AA' },
    { label: 'Total Orders', value: stats?.total_orders, color: '#BE6F76' },
    { label: 'Customers', value: stats?.total_customers, color: '#FA7E75' },
    { label: 'Avg Order Value', value: stats?.average_order_value, color: '#9279AA' },
  ];

  return React.createElement(motion.div, {
    initial: { opacity: 0, y: 20 },
    animate: { opacity: 1, y: 0 },
    transition: { duration: 0.5 },
    className: "space-y-8"
  }, [
    React.createElement(motion.div, {
      key: 'hero',
      initial: { scale: 0.95 },
      animate: { scale: 1 },
      transition: { duration: 0.3 },
      className: "relative rounded-2xl overflow-hidden shadow-2xl"
    }, [
      React.createElement('div', {
        key: 'bg',
        className: "absolute inset-0 bg-cover bg-center bg-no-repeat opacity-30",
        style: { backgroundImage: "url('/assets/preview-1.png')" }
      }),
      React.createElement('div', {
        key: 'overlay',
        className: "absolute inset-0 bg-gradient-to-br from-[#0E1E36]/70 via-[#0E1E36]/60 to-[#0E1E36]/80"
      }),
      React.createElement('div', {
        key: 'content',
        className: "relative z-10 p-12 lg:p-16"
      }, [
        React.createElement(motion.h1, {
          key: 'title',
          initial: { opacity: 0, x: -20 },
          animate: { opacity: 1, x: 0 },
          transition: { delay: 0.2 },
          className: "text-4xl lg:text-5xl font-bold text-[#F4B999] mb-4"
        }, "Welcome to Your Analytics Dashboard"),
        React.createElement(motion.p, {
          key: 'subtitle',
          initial: { opacity: 0, x: -20 },
          animate: { opacity: 1, x: 0 },
          transition: { delay: 0.3 },
          className: "text-lg text-[#F4B999]/90 mb-6"
        }, "Track your store's performance with real-time insights and beautiful visualizations.")
      ])
    ]),
    React.createElement('div', {
      key: 'stats',
      className: "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6"
    }, statCards.map((stat, index) =>
      React.createElement(motion.div, {
        key: stat.label,
        initial: { opacity: 0, y: 20 },
        animate: { opacity: 1, y: 0 },
        transition: { delay: index * 0.1 },
        whileHover: { scale: 1.05, y: -5 },
        className: "bg-[#0E1E36]/80 backdrop-blur-md rounded-xl p-6 border border-[#574F72]/50 shadow-lg"
      }, [
        React.createElement('p', {
          key: 'label',
          className: "text-sm text-[#9279AA] mb-2"
        }, stat.label),
        React.createElement('p', {
          key: 'value',
          className: "text-2xl font-bold text-[#F4B999]"
        }, stat.value || '0')
      ])
    ))
  ]);
}

