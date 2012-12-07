namespace :image_filename_fix do
  
  desc "Fix Local Offers Photo filenames"
  task :fixit => :environment do
    
    ["LocalOffer", "Image", "Admin", "Post"].each do |mname|
      mname.constantize.all.each do |data|
        if data.image
          new_file_name = Iconv.iconv('ascii//ignore//translit', 'utf-8', data.image_file_name).to_s
          new_file_name.strip!
          new_file_name.downcase!
          new_file_name.gsub!(/'/, '')
          new_file_name.gsub!( /[^a-zA-Z0-9_\.]/, '-')
          
          puts "old: #{data.image_file_name} | new: #{new_file_name}"

          if new_file_name != data.image_file_name
            (data.image.styles.keys+[:original]).each do |style|
              path = data.image.path(style)
              # path = File.join(File.dirname(path), data.image_file_name)
              puts "path: #{path}"
              
              begin
                FileUtils.mv(path, File.join(File.dirname(path), new_file_name), :force => true)
              rescue Exception => e
                puts "error in patching: #{e.message}"
              end
            end

            data.image_file_name = new_file_name
            data.save
          end
        end
      end
    end
 
  end
end