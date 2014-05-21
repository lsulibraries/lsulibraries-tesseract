#
# Cookbook Name:: tesseract
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "libtiff4-dev" do
  action :install
end

package "libpng-dev" do
  action :install
end

package "libjpeg-dev" do
  action :install
end

remote_file "#{Chef::Config[:file_cache_path]}/leptonica.tar.gz" do
  source "https://leptonica.googlecode.com/files/leptonica-1.69.tar.gz"
  action :create_if_missing
end

bash "compile_leptonica_source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxf leptonica.tar.gz
    cd leptonica-1.69
    ./configure
    make && make install
  EOH
end

package "autoconf" do
  action :install
end

package "libtool" do
  action :install
end

remote_file "#{Chef::Config[:file_cache_path]}/tesseract.tar.gz" do
  source "https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.02.tar.gz"
  action :create_if_missing
end

bash "compile_tesseract_source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxf tesseract.tar.gz
    cd tesseract-ocr
    ./autogen.sh
    ./configure
    make && make install
  EOH
  creates "/usr/local/bin/tesseract"
end

execute "ldconfig" do
  command "/sbin/ldconfig"
end

remote_file "#{Chef::Config[:file_cache_path]}/tesseract.eng.tar.gz" do
  source "https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.eng.tar.gz"
  action :create_if_missing
end

bash "install_tesseract_english_language_pack" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxf tesseract.eng.tar.gz
    cd tesseract-ocr
    cp -rf tessdata /usr/local/share
  EOH
end

