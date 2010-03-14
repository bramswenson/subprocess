
namespace :git do
  desc "git pull, add, commit and push all in one"
  task :all do |t, msg|
    puts `git pull origin master && git add . && git commit -a -m #{msg} && git push`
  end
end


