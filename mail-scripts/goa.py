#!/usr/bin/env python3
import sys
import gi
gi.require_version('Goa', '1.0')

from gi.repository import Goa

def lookup(host, user):
    client = Goa.Client.new_sync()
    mail_handles = [h  for h in client.get_accounts() if h.get_mail()]

    for h in mail_handles:
        m = h.get_mail()
        if m.get_property("imap-host") == host and m.get_property("imap-user-name") == user:
            print(h.get_password_based().call_get_password_sync("imap-password"))
            return
    print(f"{user} (at) {host} not found")

[h, u] = sys.argv[1:]
lookup(h, u)
