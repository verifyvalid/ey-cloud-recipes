# add x86 emulation libraries so that wkhtmltopdf version in the gem all work
package 'app-emulation/emul-linux-x86-xlibs' do
  action :install
end
