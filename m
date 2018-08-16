From: Steve French <smfrench@gmail.com>
Subject: Re: Should we split the network filesystem setup into two phases?
Date: Wed, 15 Aug 2018 22:51:45 -0500
Message-ID: <CAH2r5msjAYbXdnmC4Hb5TO155BC2vcMLq7XJ1H37TBiQTcsO7w@mail.gmail.com>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <17763.1534350685@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17763.1534350685@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, ebiederm@redhat.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is worth further detailed discussion re:SMB3 as there are some fascinating
protocol features that might help here, but my first thought is just the obvious
one - this could help 'DFS' (the global name space feature almost all modern
CIFS/SMB3 implement) work a little better in the client.  A share can
be represented by an array of \\server\share\path targets although typically
only one except in the DFS case  (and server can be an ipv4 or
ipv6 address or host name (which could have multiple addresses).
It could be over RDMA, TCP, and even other protocols (as the transport).

There are various examples of DFS referrals in
https://msdn.microsoft.com/en-us/library/cc227066.aspx section 4.

But since SMB3 also supports transparent failover, and "share move"
and "server move" features, as well as multichannel - I would like
to better understand the patch set to see if it helps/hurts.

But until I dive into the patch set more and try it, hard for me to speculate.
Has anyone looked at the CIFS/SMB3 changes needed?

On Wed, Aug 15, 2018 at 11:32 AM David Howells <dhowells@redhat.com> wrote:
>
> Having just re-ported NFS on top of the new mount API stuff, I find that I
> don't really like the idea of superblocks being separated by communication
> parameters - especially when it might seem reasonable to be able to adjust
> those parameters.
>
> Does it make sense to abstract out the remote peer and allow (a) that to be
> configured separately from any superblocks using it and (b) that to be used to
> create superblocks?
>
> Note that what a 'remote peer' is would be different for different
> filesystems:
>
>  (*) For NFS, it would probably be a named server, with address(es) attached
>      to the name.  In lieu of actually having a name, the initial IP address
>      could be used.
>
>  (*) For CIFS, it would probably be a named server.  I'm not sure if CIFS
>      allows an abstraction for a share that can move about inside a domain.

CIFS/SMB3 has fairly mature support (in the protocol) for various types
of share redirection (not just 'DFS' that is supported by most every
NAS server, and Macs, Windows, Linux clients etc).  There are also
very interesting features introduced with SMB 3.1.1 allowing 'tree
connect contexts"
which some important servers in the last few years implement.

This is worth more discussion - SMB3 (in particular the SMB3.1.1 dialect) has
a lot of interesting features here.



-- 
Thanks,

Steve
