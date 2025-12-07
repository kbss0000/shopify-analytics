import { Controller } from "@hotwired/stimulus"
import { tsParticles } from "tsparticles-engine"
import { loadSlim } from "tsparticles-slim"

export default class extends Controller {
  async connect() {
    await loadSlim(tsParticles)

    await tsParticles.load(this.element.id, {
      fullScreen: { enable: false },
      fpsLimit: 60,
      particles: {
        color: { value: "#7aa2f7" },
        links: {
          color: "#7aa2f7",
          distance: 120,
          enable: true,
          opacity: 0.05, // Lower opacity for subtle effect
          width: 1,
        },
        move: {
          enable: true,
          speed: 0.5, // Slower movement is less distracting and smoother
          direction: "none",
          random: false,
          straight: false,
          outModes: "out",
        },
        number: {
          density: { enable: true, area: 800 },
          value: 15, // Reduced from 40 to 15 for performance
        },
        opacity: { value: 0.2 },
        shape: { type: "circle" },
        size: { value: { min: 1, max: 2 } },
      },
      detectRetina: false, // Disabled for performance
    })
  }
}
