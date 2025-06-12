# Pin npm packages by running ./bin/importmap
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "turbo" # @2.4.4
pin "child_process" # @2.1.0
pin "fs" # @2.1.0
pin "path" # @2.1.0
pin "process" # @2.1.0
pin "autocomplete"
