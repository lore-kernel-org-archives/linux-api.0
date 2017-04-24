From: Marko Rauhamaa <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org>
Subject: Re: fanotify read returns with errno == EOPENSTALE
Date: Mon, 24 Apr 2017 10:40:50 +0300
Message-ID: <87shky6ynx.fsf@drapion.f-secure.com>
References: <20170322193122.GV29622@ZenIV.linux.org.uk>
        <CAOQ4uxhTd1j4HLgZFTdr7wwrhjzkVT8QeoXjca_AMZmYHF31sQ@mail.gmail.com>
        <87a88c2yxq.fsf@drapion.f-secure.com>
        <CAOQ4uxggwSDcjdyCDreKs7m0ZNy+6PQQNojm6qDU7mH2tQE-Bw@mail.gmail.com>
        <1490270212.3921.10.camel@poochiereds.net>
        <8760j02mfz.fsf@drapion.f-secure.com>
        <CAOQ4uxja14p02jQurLTGv_fHrs+UBa5qfacrgY_-7tyv6UJqdw@mail.gmail.com>
        <87lgqwa4tg.fsf@drapion.f-secure.com>
        <CAOQ4uxirSfVVYBexXrWccDHnE5oqxNgUh3-X5Ey1w4R=nHXDjA@mail.gmail.com>
        <CAOQ4uxjA8Z7wnwuHFCKeKT1xz0Gh-qS40Y6cfPi3fAM0MKsRuQ@mail.gmail.com>
        <20170420142035.GE22135@quack2.suse.cz>
        <CAOQ4uxgAOJjWP6PHY6WgOkNK0vmaTWnFZN+Jvea7zpjJ_VU8Bw@mail.gmail.com>
        <CAOQ4uxgkXz+8=m2o_faAh2g2Z21KhAf67WckgPNWhktz1=DaWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOQ4uxgkXz+8=m2o_faAh2g2Z21KhAf67WckgPNWhktz1=DaWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Amir Goldstein's message of "Sat, 22 Apr 2017 10:22:20 +0300")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:

> Were you able to verify that both blocking and non-blocking mode work
> correctly? May I add your Tested-by and Reported-by tags?

I have only verified the nonblocking case in my tests (which are by no
means extensive). The reported issue can no longer be reproduced with
the patched kernel, and the regular OPEN_PERM function is still
operational.

Feel free to add me to the tags.


Marko
