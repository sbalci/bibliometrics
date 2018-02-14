Sys.getenv("PATH")
system("which edirect")
system("echo $PATH")
Sys.getenv("R_HOME")
Sys.getenv()
#  system("/bin/bash
# perl -MNet::FTP -e \
#        '$ftp = new Net::FTP('ftp.ncbi.nlm.nih.gov', Passive => 1);
#        $ftp->login; $ftp->binary;
#        $ftp->get('/entrez/entrezdirect/edirect.tar.gz');'
#        gunzip -c edirect.tar.gz | tar xf -
#        rm edirect.tar.gz
#        builtin exit
#        export PATH=$PATH:$HOME/RepTemplates/pubmed/edirect >& /dev/null || setenv PATH '${PATH}:$HOME/RepTemplates/pubmed/edirect'
#        ./edirect/setup.sh")


system("export PATH=$PATH:$HOME/RepTemplates/pubmed/edirect >& /dev/null || setenv PATH '${PATH}:$HOME/RepTemplates/pubmed/edirect'
       ./edirect/setup.sh")

