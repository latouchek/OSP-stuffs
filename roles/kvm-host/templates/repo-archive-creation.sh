rsync -avz --progress --delete reposerver:/OSP10/ /home/OSP
tar cf - OSP/  | pigz > /home/tmpwww/datev.tar.gz
