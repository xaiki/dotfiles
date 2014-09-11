#!/usr/bin/python
import re, os

def get_password(machine, login, port=''):
    mc = re.compile("machine %s" % machine)
    po = re.compile("port %s" % port)
    lg = re.compile("login %s" % login)
    pw = re.compile("password ([^ ]+)")

    authinfo = os.popen("gpg -q --use-agent --no-tty -d ~/.authinfo.gpg").read()
    for l in authinfo.split('\n'):
        if (mc.search(l) and lg.search(l)):
            return pw.search(l).group(1).strip()

    return None

if __name__ == '__main__':
    import sys
    sys.stdout.write(get_password(sys.argv[1], sys.argv[2], sys.argv[3]))
