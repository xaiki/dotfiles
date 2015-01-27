#!/usr/bin/python

from authinfo import get_password
from oauth2 import GenerateOAuth2String,RefreshToken

def get_token (machine, login, port=''):
    tokens = get_password ('oauth2.' + machine, login, port).split(':')
    response =  RefreshToken(tokens[0], tokens[1], tokens[2])
    auth = GenerateOAuth2String (login, response['access_token'])
    import sys
#    sys.stderr.write('will auth: ' + auth + '\n');
    return auth

if __name__ == '__main__':
    import sys
    sys.stdout.write(get_token(sys.argv[1], sys.argv[2], sys.argv[3]));
