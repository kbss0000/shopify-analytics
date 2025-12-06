// React Hook Form with Zod Validation (using React.createElement for importmap)
import React from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { motion } from 'framer-motion';

const shopifyConnectionSchema = z.object({
  shopify_domain: z.string()
    .min(1, 'Domain is required')
    .regex(/\.myshopify\.com$/, 'Must be a valid Shopify domain (e.g., mystore.myshopify.com)'),
  shopify_access_token: z.string()
    .min(1, 'Access token is required')
    .min(20, 'Token seems too short'),
});

export function ShopifyConnectionForm({ onSubmit }) {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm({
    resolver: zodResolver(shopifyConnectionSchema),
  });

  return React.createElement(motion.form, {
    initial: { opacity: 0, y: 20 },
    animate: { opacity: 1, y: 0 },
    onSubmit: handleSubmit(onSubmit),
    className: "space-y-6 bg-[#0E1E36]/80 backdrop-blur-md rounded-xl p-8 border border-[#574F72]/50"
  }, [
    React.createElement('div', { key: 'domain' }, [
      React.createElement('label', {
        key: 'label1',
        className: "block text-sm font-medium text-[#F4B999] mb-2"
      }, "Shopify Domain"),
      React.createElement('input', {
        key: 'input1',
        ...register('shopify_domain'),
        type: "text",
        placeholder: "mystore.myshopify.com",
        className: "w-full px-4 py-2 bg-[#4A2036] border border-[#574F72] rounded-lg text-[#F4B999] placeholder-[#574F72] focus:outline-none focus:ring-2 focus:ring-[#9279AA]"
      }),
      errors.shopify_domain && React.createElement(motion.p, {
        key: 'error1',
        initial: { opacity: 0 },
        animate: { opacity: 1 },
        className: "mt-1 text-sm text-[#D2495B]"
      }, errors.shopify_domain.message)
    ]),
    React.createElement('div', { key: 'token' }, [
      React.createElement('label', {
        key: 'label2',
        className: "block text-sm font-medium text-[#F4B999] mb-2"
      }, "Access Token"),
      React.createElement('input', {
        key: 'input2',
        ...register('shopify_access_token'),
        type: "password",
        placeholder: "shpat_...",
        className: "w-full px-4 py-2 bg-[#4A2036] border border-[#574F72] rounded-lg text-[#F4B999] placeholder-[#574F72] focus:outline-none focus:ring-2 focus:ring-[#9279AA]"
      }),
      errors.shopify_access_token && React.createElement(motion.p, {
        key: 'error2',
        initial: { opacity: 0 },
        animate: { opacity: 1 },
        className: "mt-1 text-sm text-[#D2495B]"
      }, errors.shopify_access_token.message)
    ]),
    React.createElement(motion.button, {
      key: 'submit',
      type: "submit",
      disabled: isSubmitting,
      whileHover: { scale: 1.02 },
      whileTap: { scale: 0.98 },
      className: "w-full px-6 py-3 bg-[#9279AA] text-[#0E1E36] font-medium rounded-lg hover:bg-[#9279AA]/90 transition-colors disabled:opacity-50"
    }, isSubmitting ? 'Connecting...' : 'Connect Store')
  ]);
}

