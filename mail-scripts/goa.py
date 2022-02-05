#!/usr/bin/env python3
import sys
import gi
gi.require_version('Goa', '1.0')

from gi.repository import Goa

client = Goa.Client.new_sync()
mail_handles = [h  for h in client.get_accounts() if h.get_mail()]

for s in sys.argv[1:]:
    found = False
    for h in mail_handles:
        m = h.get_mail()
        if m.get_property("imap-host") == s:
            print(h.get_password_based().call_get_password_sync("imap-password"))
            found = True
            break
    if not found:
        print(f"{s} not found")
