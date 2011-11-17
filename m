From: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Bug] epoll_wait return EPOLLOUT even with EPOLLET flag
Date: Thu, 17 Nov 2011 09:18:54 +0100
Message-ID: <1321517934.3274.44.camel@edumazet-laptop>
References: <CAFZ0FUWptNqUJUkoj8=3eLSMrGKPKB5c7NcFv_5iJfJLuJF+sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFZ0FUWptNqUJUkoj8=3eLSMrGKPKB5c7NcFv_5iJfJLuJF+sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robin Dong <hao.bigrat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Le jeudi 17 novembre 2011 =C3=A0 16:07 +0800, Robin Dong a =C3=A9crit :
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
>=20

Its not true. Same "status" can be delivered several time.

Think about Edge and Level trigger. An event (change of status) is the
trigger.

As soon as on trigger is done, epoll delivers a status.

And your file status is indeed EPOLLOUT | EPOLLIN, since you can read o=
r
write on it.


> BUT=EF=BC=8Cwhen a message comes from server=EF=BC=8Cthe client socke=
t will get aevent
> and this event contains EPOLLOUT and EPOLLIN, looks epoll_waitreturn
> too much events than it should
>=20
> My question is: Is this a bug for epoll ?

Not a bug, but a misinterpretation of what is an event and what is a
status.
