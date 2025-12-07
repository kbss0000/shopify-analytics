// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Force Chartkick to render charts after Turbo navigation
document.addEventListener("turbo:load", function() {
  setTimeout(function() {
    if (typeof Chart !== 'undefined' && typeof Chartkick !== 'undefined') {
      if (!Chartkick.adapter) {
        Chartkick.use(Chart);
      }
      
      // Force render all charts
      var chartContainers = document.querySelectorAll('[data-chart]');
      console.log('Turbo load: Found ' + chartContainers.length + ' charts');
      
      chartContainers.forEach(function(container) {
        if (!container.chartkickChart) {
          var chartData = container.getAttribute('data-chart');
          var chartType = container.getAttribute('data-chart-type') || 'LineChart';
          
          if (chartData) {
            try {
              var data = JSON.parse(chartData);
              if (Chartkick[chartType]) {
                new Chartkick[chartType](container, data);
                console.log('✅ Manually rendered chart');
              }
            } catch (e) {
              console.error('Error rendering chart:', e);
            }
          }
        }
      });
    }
  }, 300);
});

// Also on regular page load
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', function() {
    setTimeout(function() {
      if (typeof Chart !== 'undefined' && typeof Chartkick !== 'undefined') {
        if (!Chartkick.adapter) {
          Chartkick.use(Chart);
        }
      }
    }, 300);
  });
}

// React App (loaded conditionally)
if (document.getElementById('react-dashboard') ||
  document.getElementById('react-monaco-editor') ||
  document.getElementById('react-shopify-form')) {
  import("./react_app.js");
}
