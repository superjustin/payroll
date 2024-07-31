# Pin npm packages by running ./bin/importmap
pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@fullcalendar/core", to: "https://cdn.skypack.dev/@fullcalendar/core@6.1.15"
pin "@fullcalendar/daygrid", to: "https://cdn.skypack.dev/@fullcalendar/daygrid@6.1.15"
pin "@fullcalendar/interaction", to: "https://cdn.skypack.dev/@fullcalendar/interaction@6.1.15"
pin_all_from "app/javascript/controllers", under: "controllers"