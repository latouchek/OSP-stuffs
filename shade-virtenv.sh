yum group install "Development Tools" -y
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel expat-devel
mkdir ~/python
cd ~/python
wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz
tar zxfv Python-2.7.11.tgz
find ~/python -type d | xargs chmod 0755
cd  Python-2.7.11
./configure --prefix=$HOME/python
make && make install
mkdir $HOME/pip
pip download -d pip  --process-dependency-links  ansible shade virtualenvwrapper virtualenv setuptools
mkdir $HOME/pythonlocal
pip install -t pythonlocal --no-index --find-links=file:$HOME/pip virtualenvwrapper
mkdir virtenv
export WORKON_HOME=virtenv
source pythonlocal/bin/virtualenvwrapper.sh -p $WORKON_HOME
mkvirtualenv shade
pip install   --no-index --find-links=file:$HOME/pip shade
pip install   --no-index --find-links=file:$HOME/pip  ansible
