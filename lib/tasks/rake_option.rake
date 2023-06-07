namespace :rake_option do
  desc '引数なしのタスク'
  task without_option: :environment do
    Rails.logger.error('foo')
  end

  desc '[]で囲った引数ありのタスク'
  task :with_option, [:foo, :bar] => :environment do |_task, args|
    Rails.logger.error("#{args[:foo]}, type => #{args[:foo].class}")
    Rails.logger.error("#{args[:bar]}, type => #{args[:bar].class}")
  end

  desc 'ENVに入る引数のタスク'
  task with_env: :environment do
    foo = ENV.fetch('foo')
    bar = ENV.fetch('bar')

    Rails.logger.error("#{foo}, type => #{foo.class}")
    Rails.logger.error("#{bar}, type => #{bar.class}")
  end
end