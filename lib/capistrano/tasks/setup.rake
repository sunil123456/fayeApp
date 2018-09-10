namespace :setup do
  desc "Upload database.yml, application.yml and puma.rb file."
  task :upload_files do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/database.yml")), "#{shared_path}/config/database.yml"
      upload! StringIO.new(File.read("config/application.yml")), "#{shared_path}/config/application.yml"
      upload! StringIO.new(File.read("config/private_pub.yml")), "#{shared_path}/config/private_pub.yml"
      upload! StringIO.new(File.read("config/puma.rb")), "#{shared_path}/config/puma.rb"
    end
  end

  desc "Migrate the database."
  task :create_db do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "db:migrate"
        end
      end
    end
  end

  desc "Seed the database."
  task :seed_db do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "db:seed"
        end
      end
    end
  end
end