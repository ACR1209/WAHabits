# frozen_string_literal: true

Rake::Task["stimulus:manifest:update"].clear

namespace :stimulus do
  namespace :manifest do
    task update: :environment do
      puts "Skipping Rails default Stimulus manifest update"

      controllers_path = Rails.root.join("app/javascript/controllers")
      index_js_path = controllers_path.join("index.js")

      index_js = File.read(index_js_path)
      start_marker = "// START AUTO-GENERATED CONTROLLERS"
      end_marker = "// END AUTO-GENERATED CONTROLLERS"
      start_idx = index_js.index(start_marker)
      end_idx = index_js.index(end_marker)

      if start_idx && end_idx
        before = index_js[0..(start_idx + start_marker.length - 1)]
        after = index_js[end_idx..]
        generated = Stimulus::Manifest.generate_from(controllers_path)
        new_content = "#{before}\n#{generated.join('')}\n#{after}"
        File.write(index_js_path, new_content)
        puts "Stimulus controllers region of index.js updated."
      else
        puts "Markers not found in index.js. No changes made."
      end
    end
  end
end
