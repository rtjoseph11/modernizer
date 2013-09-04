require 'rake/testtask'

Rake::TestTask.new('test:modernizer') do |test|
  test.pattern = 'spec/modernizer_spec.rb'
  test.verbose = true
end

desc 'Run application test suite'
task 'test' => "test:modernizer"