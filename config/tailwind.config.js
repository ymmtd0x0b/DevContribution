const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './node_modules/flowbite/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      animation: {
        "fade-in-top": "fade-in-top 0.7s cubic-bezier(0.680, -0.550, 0.265, 1.550)    both",
        "fade-out": "fade-out 0.7s cubic-bezier(0.680, -0.550, 0.265, 1.550)   reverse both"
      },
      keyframes: {
          "fade-in-top": {
              "0%": {
                  transform: "translateY(-50px)",
                  opacity: "0"
              },
              to: {
                  transform: "translateY(0)",
                  opacity: "1"
              }
          },
          "fade-out": {
              "0%": {
                  transform: "translateY(-50px)",
                  opacity: "0"
              },
              to: {
                  transform: "translateY(0)",
                  opacity: "1"
              }
          }
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/container-queries'),
    require('flowbite/plugin')
  ]
}
