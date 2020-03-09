namespace :benchmark do
  desc 'Simulate multiple apps, reporting lots of coverage data'
  task :simulate => :environment do |_, args|
    # run like so:
    # COVERBAND_API_KEY=XYZ COVERBAND_URL=https://coverband-service.herokuapp.com  bundle exec rake benchmark:simulate
    # local example (no need for key as it should be in your .env.development.local)
    # COVERBAND_URL=http://localhost:3456  bundle exec rake benchmark:simulate
    #
    # To calculate overload / error rate:
    #  bundle exec rake benchmark:simulate > bench.txt
    #  cat bench.txt | grep "Coverband: Error" |  wc -l
    #  this will output the number of requests that exceeded coverband service clients
    #  default timeout (1s)
    #
    # This will simulate many servers reporting for a single project (for now)
    # It runs in a tight loop sending reported coverage as fast as it can
    ENV['COVERBAND_API_KEY'] ||= raise 'FAIL_PASS_THIS_IN'

    servers = (ENV['SIMULATE_SERVERS'] || 5).to_i
    processes = (ENV['SIMULATE_PROCESSES'] || 3).to_i
    # NOTE: Coverband shold only report per process, so adding this in
    # really helps show either multiple apps, bad configuration, background jobs
    # or peaks during deployment... IE this is beyond the expected needed capacity
    threads = (ENV['SIMULATE_THREADS'] || 3).to_i

    # NOTE: Sustained over how many cycles, coverband cycles are really 10m
    # these will be back to back, again worst case
    cycles = (ENV['SIMULATE_CYCLES'] || 5).to_i

    possible_concurrent = servers * processes * threads

    file = '/Users/danmayer/projects/coverband_service_demo/app/controllers/posts_controller.rb'
    file_length = File.read(file).split("\n").length
    fake_coverage = {
      file => [1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0]
    }

    puts "simulating concurrency of #{possible_concurrent}"
    puts "making a total of #{(possible_concurrent * cycles)} over #{cycles} cycles"
    cycles.times do |count|
      puts "cycle #{count}"
      possible_concurrent.times.map do
        Thread.new do
          coverband_service = Coverband::Adapters::Service.new(
            ENV['COVERBAND_URL'],
            runtime_env: Rails.env.to_s
          )
          coverband_service.save_report(fake_coverage)
        end
      end.each(&:join)
    end
  end
end
