// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "Chart.bundle"
import "chartjs-adapter-date-fns"
import "chartkick"

// React App (loaded conditionally)
if (document.getElementById('react-dashboard') ||
  document.getElementById('react-monaco-editor') ||
  document.getElementById('react-shopify-form')) {
  import("./react_app.js");
}
