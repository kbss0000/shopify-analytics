# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "chartkick", to: "https://ga.jspm.io/npm:chartkick@5.0.1/dist/chartkick.esm.js"
pin "Chart.bundle", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"
pin "chartjs-adapter-date-fns", to: "https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns@3.0.0/dist/chartjs-adapter-date-fns.bundle.min.js"

# React and Advanced Libraries
pin "react", to: "https://esm.sh/react@18.2.0"
pin "react-dom", to: "https://esm.sh/react-dom@18.2.0"
pin "react-dom/client", to: "https://esm.sh/react-dom@18.2.0/client"
pin "react/jsx-runtime", to: "https://esm.sh/react@18.2.0/jsx-runtime"
pin "framer-motion", to: "https://esm.sh/framer-motion@10.16.4"
pin "zustand", to: "https://esm.sh/zustand@4.4.7"
pin "react-hook-form", to: "https://esm.sh/react-hook-form@7.48.2"
pin "zod", to: "https://esm.sh/zod@3.22.4"
pin "@hookform/resolvers", to: "https://esm.sh/@hookform/resolvers@3.3.2"
pin "monaco-editor", to: "https://cdn.jsdelivr.net/npm/monaco-editor@0.45.0/+esm"

# React Components
pin_all_from "app/javascript/components", under: "components"
pin_all_from "app/javascript/stores", under: "stores"
pin "react_app", to: "react_app.js"

# Motion (Framer Motion for vanilla JS)
pin "motion", to: "https://ga.jspm.io/npm:motion@10.16.2/dist/motion.js"

# Monaco Editor Loader
pin "@monaco-editor/loader", to: "https://ga.jspm.io/npm:@monaco-editor/loader@1.4.0/lib/es/index.js"
pin "state-local", to: "https://ga.jspm.io/npm:state-local@1.0.7/lib/es/index.js"

# 3D Tilt Effect
pin "vanilla-tilt", to: "https://ga.jspm.io/npm:vanilla-tilt@1.8.1/lib/vanilla-tilt.js"

# Particles
pin "tsparticles-engine", to: "https://ga.jspm.io/npm:tsparticles-engine@2.12.0/esm/index.js"
pin "tsparticles-slim", to: "https://ga.jspm.io/npm:tsparticles-slim@2.12.0/esm/index.js"

# Tooltips
pin "tippy.js", to: "https://ga.jspm.io/npm:tippy.js@6.3.7/dist/tippy.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"
