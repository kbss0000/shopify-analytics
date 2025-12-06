# Akane Theme Implementation

## Overview
This application now uses the exact **Akane Theme** color palette from [omarchy-akane-theme](https://github.com/Grenish/omarchy-akane-theme), a Japanese-inspired dark theme with serene crimson and shadow tones.

## Color Palette (Exact from GitHub)

| Color Name | Hex Code | Usage |
|------------|----------|-------|
| **Oxford Blue** | `#0E1E36` | Deep blue background |
| **Peach** | `#F4B999` | Warm foreground text |
| **African Violet** | `#9279AA` | Keywords & highlights (Primary) |
| **English Violet** | `#574F72` | UI elements (Borders, Secondary) |
| **Old Rose** | `#BE6F76` | Types & properties |
| **Coral Pink** | `#FA7E75` | Numbers & accents |
| **Amaranth** | `#D2495B` | Errors (Destructive) |
| **Dark Purple** | `#4A2036` | Subtle backgrounds (Muted) |

## Implementation Details

### 1. Tailwind Configuration
- Updated `config/tailwind.config.js` with exact Akane colors
- Mapped to semantic color tokens (primary, secondary, destructive, etc.)
- Added custom Akane color utilities

### 2. CSS Variables
- Added CSS custom properties in `app/assets/stylesheets/application.tailwind.css`
- All colors reference the exact hex values from the GitHub repository

### 3. React Components (Advanced Features)

#### Components Created:
- **Dashboard.jsx** - Animated dashboard with Framer Motion
- **MonacoEditor.jsx** - Code editor with Akane theme colors
- **FormWithValidation.jsx** - Form with React Hook Form + Zod validation

#### Libraries Integrated:
- ✅ **React 18.2.0** - Via ESM CDN (esm.sh)
- ✅ **Framer Motion 10.16.4** - For smooth animations
- ✅ **Monaco Editor** - Code editor for AI Studio
- ✅ **React Hook Form 7.48.2** - Form state management
- ✅ **Zod 3.22.4** - Schema validation
- ✅ **Zustand 4.4.7** - Lightweight state management
- ⚠️ **Liveblocks** - Configured but requires API key for real-time collaboration

### 4. Views Updated
All views now use the Akane color palette:
- Dashboard (`app/views/dashboard/index.html.erb`)
- Orders (`app/views/orders/index.html.erb`)
- Customers (`app/views/customers/index.html.erb`)
- Reports (`app/views/reports/index.html.erb`)
- AI Studio (`app/views/ai/index.html.erb`)
- Shopify Onboarding (`app/views/shopify/onboarding/new.html.erb`)
- Shared components (Header, Sidebar, Stat Cards)

### 5. Importmap Configuration
- React and all advanced libraries loaded via ESM CDN
- No build step required - works with Rails 7 importmap
- Components use `React.createElement` for importmap compatibility

## Usage

### Using Akane Colors in Views

```erb
<!-- Background -->
<div class="bg-[#0E1E36]">Oxford Blue Background</div>

<!-- Text -->
<p class="text-[#F4B999]">Peach Text</p>

<!-- Primary Actions -->
<button class="bg-[#9279AA] text-[#0E1E36]">African Violet Button</button>

<!-- Borders -->
<div class="border border-[#574F72]">English Violet Border</div>

<!-- Errors -->
<span class="text-[#D2495B]">Amaranth Error Text</span>
```

### Using Semantic Tokens

```erb
<!-- Use semantic tokens for consistency -->
<div class="bg-background text-foreground">
  <button class="bg-primary text-primary-foreground">Primary Button</button>
  <div class="border border-border">Bordered Container</div>
  <span class="text-destructive">Error Message</span>
</div>
```

### React Components

```javascript
// Dashboard with Framer Motion
import { Dashboard } from 'components/Dashboard';
<Dashboard stats={statsData} />

// Monaco Editor
import { MonacoEditor } from 'components/MonacoEditor';
<MonacoEditor value={code} onChange={handleChange} language="sql" />

// Form with Validation
import { ShopifyConnectionForm } from 'components/FormWithValidation';
<ShopifyConnectionForm onSubmit={handleSubmit} />
```

## Running Locally

1. **Start Docker containers:**
   ```bash
   docker-compose up
   ```

2. **Access the application:**
   - URL: http://localhost:3000
   - Login: `demo@example.com` / `password123`

3. **View the Akane theme:**
   - All pages now use the exact Akane color palette
   - React components with animations are available
   - Monaco Editor in AI Studio uses Akane colors

## Advanced Features Status

| Feature | Status | Notes |
|---------|--------|-------|
| React Components | ✅ Working | Via ESM CDN |
| Framer Motion | ✅ Working | Animations active |
| Monaco Editor | ✅ Working | Akane theme colors applied |
| React Hook Form | ✅ Working | Form validation active |
| Zod Validation | ✅ Working | Schema validation working |
| Zustand | ✅ Working | State management ready |
| Liveblocks | ⚠️ Configured | Requires API key for real-time features |

## Theme Consistency

All components follow the Akane theme:
- **Backgrounds**: Oxford Blue (`#0E1E36`) with transparency
- **Text**: Peach (`#F4B999`) for primary text
- **Accents**: African Violet (`#9279AA`) for highlights
- **Borders**: English Violet (`#574F72`) for subtle definition
- **Errors**: Amaranth (`#D2495B`) for destructive actions
- **Numbers**: Coral Pink (`#FA7E75`) for numeric values

## References

- [Akane Theme GitHub](https://github.com/Grenish/omarchy-akane-theme)
- [Color Reference Documentation](https://github.com/Grenish/omarchy-akane-theme/blob/main/COLOR_REFERENCE.md)

