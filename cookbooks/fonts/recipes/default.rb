#
# Cookbook Name:: fonts
# Recipe:: default
#

# node[:v2][:fonts].each do |font|
#   execute "install #{font[:name]} - corefont" do
#     command "cd /usr/share/fonts/corefonts/; wget #{font[:url]};"
#     not_if { File.exists?("/usr/share/fonts/corefonts/#{font[:filename]}") }
#   end

#   execute "install #{font[:name]} - default font" do
#    command "cd /usr/share/fonts/default/; wget #{font[:url]};"
#    not_if { File.exists?("/usr/share/fonts/default/#{font[:filename]}") && font[:default] }
#   end
# end

bash 'Install Mrs. Saint Delafield (corefont)' do
  code <<-EOH
    sudo mkdir -p /usr/share/fonts/corefonts/
    cd /usr/share/fonts/corefonts/; wget #{node[:mrs_saint_delafield_s3_url]}
  EOH
  not_if { File.exists?("/usr/share/fonts/corefonts/#{node[:mrs_saint_delafield_file_name]}") }
end

bash 'install Micr Font ttf - corefont' do
  code <<-EOH
    sudo mkdir -p /usr/share/fonts/corefonts/
    cd /usr/share/fonts/corefonts/; wget #{node[:micr_ttf_s3_url]}
  EOH
  not_if { File.exists?("/usr/share/fonts/corefonts/#{node[:micr_ttf_file_name]}") }
end

bash 'install Micr Font otf - corefont' do
  code <<-EOH
    sudo mkdir -p /usr/share/fonts/corefonts/
    cd /usr/share/fonts/corefonts/; wget #{node[:micr_otf_s3_url]};
  EOH
  not_if { File.exists?("/usr/share/fonts/corefonts/#{node[:micr_otf_file_name]}") }
end

bash 'install Micr Font otf - default font' do
  code <<-EOH
    sudo mkdir -p /usr/share/fonts/default/
    cd /usr/share/fonts/default/; wget #{node[:micr_otf_s3_url]};
  EOH
  not_if { File.exists?("/usr/share/fonts/default/#{node[:micr_otf_file_name]}") }
end

execute 'append xml to type-windows.xml - micr font' do
  if File.exists?('/etc/ImageMagick/type-windows.xml')
    windows_type_path = '/etc/ImageMagick/type-windows.xml'
    type_path = '/etc/ImageMagick/type.xml'
  else
    windows_type_path = '/usr/lib/ImageMagick-6.4.8/config/type-windows.xml'
    type_path = '/usr/lib/ImageMagick-6.4.8/config/type.xml'
  end

  windows_font_xml_file = File.open(windows_type_path, 'rb')
  correct_xml_file = File.open('/tmp/type-windows.xml', 'w')
  mrs_saint_delafield_xml_statement = '<type name="MrsSaintDelafield-Regular" fullname="MrsSaintDelafield-Regular" family="MrsSaintDelafield" weight="400" style="normal" stretch="normal" glyphs="/usr/share/fonts/corefonts/MrsSaintDelafield-Regular.ttf" encoding="AppleRoman"/>'

  windows_font_xml_file.each do |line|
    # the file ends with "</typemap>" and we need to add our xml right before it
    if line.include?('</typemap>')
      correct_xml_file.write(mrs_saint_delafield_xml_statement + "\n")
    end
    correct_xml_file.write(line)
  end

  # close up our files so we dont leak memory
  windows_font_xml_file.close
  correct_xml_file.close

  command %Q{sudo mv -f '/tmp/type-windows.xml' '#{windows_type_path}'}
  not_if { File.read(windows_type_path).include?('MrsSaintDelafield-Regular') }
end

execute 'register windows font file' do
  type_path = if File.exists?('/etc/ImageMagick/type-windows.xml')
    '/etc/ImageMagick/type.xml'
  else
    '/usr/lib/ImageMagick-6.4.8/config/type.xml'
  end

  font_xml_file = File.open(type_path, 'rb')
  correct_xml_file = File.open('/tmp/type.xml', 'w')

  font_xml_file.each do |line|
    # the file ends with "</typemap>" and we need to add our xml right before it
    if line.include?('</typemap>')
      correct_xml_file.write('<include file="type-windows.xml" />' + "\n")
    end
    correct_xml_file.write(line)
  end

  # close up our files so we dont leak memory
  font_xml_file.close
  correct_xml_file.close

  command %Q{sudo mv -f '/tmp/type.xml' '#{type_path}'}
  not_if { File.read(type_path).include?('type-windows.xml') }
end
