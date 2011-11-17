From: Jamie Lokier <jamie-yetKDKU6eevNLxjTenLetw@public.gmane.org>
Subject: Re: [Bug] epoll_wait return EPOLLOUT even with EPOLLET flag
Date: Thu, 17 Nov 2011 15:28:32 +0000
Message-ID: <20111117152832.GA4525@jl-vm1.vm.bytemark.co.uk>
References: <CAFZ0FUWptNqUJUkoj8=3eLSMrGKPKB5c7NcFv_5iJfJLuJF+sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFZ0FUWptNqUJUkoj8=3eLSMrGKPKB5c7NcFv_5iJfJLuJF+sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robin Dong <hao.bigrat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Robin Dong wrote:
> Hi,
>=20
> I am a linux user and I found some question when using epoll with EPO=
LLET.
>=20
> My program's step:
>=20
> 1. create a socket (sfd) and connect to server
> 2. create epoll (efd)
> 3. add socket descriptor (sfd) to epoll (efd) with flag EPOLLET
> 4. get a EPOLLOUT event through epoll_wait
>=20
> After that, the program will nerver get a EPOLLOUT event because itus=
e
> EPOLLET mode (the same event will not be got twice)

Hi Robin,

With EPOLLET|EPOLLOUT, you should get a message from epoll whenever
the fd's status changes from "cannot output" to "can output".

So you should get a message when sfd transitions from write()
returning EAGAIN to write() accepting more data.

Until you get EAGAIN while writing, your program should assume the
socket is still writable.  "man epoll" has a few things to say about
this (look for all the places here it says EAGAIN).

> BUT=EF=BC=8Cwhen a message comes from server=EF=BC=8Cthe client socke=
t will get aevent
> and this event contains EPOLLOUT and EPOLLIN, looks epoll_waitreturn
> too much events than it should

The message always contains the latest status, so says EPOLLOUT|EPOLLIN=
=2E

It's doesn't mean there's an EPOLLOUT "event", it just means a message
is triggered (by the socket becoming readable) so you get a status
update.  In theory the program doesn't need to be told about EPOLLOUT
here (it should be assuming the socket is writable already), but it
doesn't do any harm.

EPOLLET is just a way to reduce the number of messages from epoll when
you call epoll_wait().  In effect you are telling the kernel "don't
send me repeated status messages and I'll maintain my own flags".  But
it doesn't change the status value in messages that are sent.

Enjoy,
-- Jamie
