import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["prompt", "response", "answer", "visualization"]

  connect() {
    console.log("✅ AI Controller connected")
  }

  // Handle suggestion button clicks - populate input and focus
  suggest(event) {
    const text = event.currentTarget.textContent.trim()
    if (this.promptTarget && text) {
      this.promptTarget.value = text
      this.promptTarget.focus()
    }
  }

  async submit(event) {
    event.preventDefault()
    event.stopPropagation()
    event.stopImmediatePropagation()

    console.log("🚀 Form submitted!")

    const promptText = this.promptTarget?.value?.trim()
    if (!promptText) {
      console.warn("⚠️ No prompt text")
      alert("Please enter a question")
      return false
    }

    console.log("📝 Prompt:", promptText)

    // Clear input
    this.promptTarget.value = ""

    // Show response container IMMEDIATELY
    if (this.responseTarget) {
      this.responseTarget.classList.remove('hidden')
      this.responseTarget.style.display = 'grid'
      this.responseTarget.style.opacity = '1'
      this.responseTarget.style.visibility = 'visible'
      console.log("✅ Response container shown")
    }

    // Show loading state
    if (this.answerTarget) {
      this.answerTarget.textContent = "Processing your request..."
      this.answerTarget.style.minHeight = '3rem'
    }

    // Editor target removed - no longer showing SQL queries

    if (this.visualizationTarget) {
      this.visualizationTarget.innerHTML = `<div class="p-4 text-muted-foreground text-sm">Loading data...</div>`
    }

    try {
      const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
      if (!csrfToken) {
        throw new Error("CSRF token not found. Please refresh the page.")
      }

      console.log("🌐 Making API request...")

      const response = await fetch('/ai/ask', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
          'Accept': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify({ prompt: promptText })
      })

      console.log("📡 Response status:", response.status)

      if (!response.ok) {
        const errorText = await response.text()
        console.error("❌ Error:", errorText)
        throw new Error(`Server error: ${response.status}`)
      }

      const data = await response.json()
      console.log("✅ Data received:", data)

      if (!data) {
        throw new Error('No data received from server')
      }

      // Update answer
      if (this.answerTarget) {
        this.answerTarget.textContent = data.answer || 'Analysis complete.'
        console.log("✅ Answer updated")
      }

      // SQL query is no longer displayed (removed per user request)
      // The query is still generated and used, just not shown in UI

      // Update visualization - format data nicely
      if (this.visualizationTarget) {
        if (data.data && Object.keys(data.data).length > 0) {
          // If data is an array, format as a table
          if (Array.isArray(data.data)) {
            let tableHTML = '<div class="overflow-auto max-h-96"><table class="min-w-full text-xs"><thead class="bg-muted"><tr>'

            // Get headers from first object
            if (data.data.length > 0) {
              const headers = Object.keys(data.data[0])
              headers.forEach(header => {
                tableHTML += `<th class="px-3 py-2 text-left font-semibold text-foreground border-b border-border">${header.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}</th>`
              })
              tableHTML += '</tr></thead><tbody>'

              data.data.forEach((row, idx) => {
                const bgClass = idx % 2 === 0 ? 'bg-card' : 'bg-muted/50'
                tableHTML += `<tr class="${bgClass}">`
                headers.forEach(header => {
                  let value = row[header]
                  // Format currency values
                  if (header.includes('cents') || header.includes('spent') || header.includes('price') || header.includes('revenue')) {
                    if (typeof value === 'number') {
                      value = '$' + (value / 100).toFixed(2)
                    }
                  }
                  tableHTML += `<td class="px-3 py-2 text-foreground border-b border-border/50">${value || '-'}</td>`
                })
                tableHTML += '</tr>'
              })
              tableHTML += '</tbody></table></div>'
              this.visualizationTarget.innerHTML = tableHTML
            } else {
              this.visualizationTarget.innerHTML = `<div class="p-4 text-muted-foreground text-sm">No data rows returned</div>`
            }
          } else {
            // Object data - show as formatted JSON
            const dataStr = JSON.stringify(data.data, null, 2)
            this.visualizationTarget.innerHTML = `<pre class="p-4 text-xs font-mono text-foreground overflow-auto max-h-96 whitespace-pre-wrap">${dataStr}</pre>`
          }
        } else {
          this.visualizationTarget.innerHTML = `<div class="p-4 text-muted-foreground text-sm">No data returned for this query</div>`
        }
        console.log("✅ Visualization updated")
      }

      // Ensure response is visible
      if (this.responseTarget) {
        this.responseTarget.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
      }

      console.log("🎉 All updates complete!")

    } catch (error) {
      console.error("❌ AI Error:", error)
      console.error("Stack:", error.stack)

      const errorMsg = error.message || 'Unknown error occurred'

      if (this.answerTarget) {
        this.answerTarget.textContent = `Error: ${errorMsg}. Please try again.`
        this.answerTarget.style.color = '#D25E65'
      }

      // Editor target removed - errors shown in answer section only

      if (this.visualizationTarget) {
        this.visualizationTarget.innerHTML = `<div class="p-4 text-destructive text-sm">Error loading data</div>`
      }

      // Still show response container
      if (this.responseTarget) {
        this.responseTarget.classList.remove('hidden')
        this.responseTarget.style.display = 'grid'
        this.responseTarget.style.opacity = '1'
      }
    }

    return false
  }
}
