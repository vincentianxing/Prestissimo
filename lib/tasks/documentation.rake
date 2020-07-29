require 'rdoc/task'
require 'sdoc'

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc/app'
  rdoc.title = 'Prestissimo Documentation'
  rdoc.main = 'README' # define README_FOR_APP as index

  rdoc.generator = 'sdoc'
  rdoc.template = 'rails'

  rdoc.options << '--charset' << 'utf-8'

  rdoc.rdoc_files.include('app/**/*.rb')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('README')
end
