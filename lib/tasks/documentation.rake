require 'rdoc/task'

namespace :doc do
    RDoc::Task.new('app') { |rdoc|
		rdoc.rdoc_dir = 'doc/app'
		rdoc.title    = 'Prestissimo Documentation'
		rdoc.main     = 'doc/README_FOR_APP' # define README_FOR_APP as index

		rdoc.options << '--charset' << 'utf-8'

		rdoc.rdoc_files.include('app/**/*.rb')
		rdoc.rdoc_files.include('lib/**/*.rb')
		rdoc.rdoc_files.include('doc/README_FOR_APP')
	}
	Rake::Task["doc:app"].clear
	Rake::Task["doc/app"].clear
	Rake::Task["doc/app/index.html"].clear
end
