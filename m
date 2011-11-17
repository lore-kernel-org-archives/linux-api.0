From: Robin Dong <hao.bigrat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Bug] epoll_wait return EPOLLOUT even with EPOLLET flag
Date: Thu, 17 Nov 2011 16:07:56 +0800
Message-ID: <CAFZ0FUWptNqUJUkoj8=3eLSMrGKPKB5c7NcFv_5iJfJLuJF+sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

I am a linux user and I found some question when using epoll with EPOLL=
ET.

My program's step:

1. create a socket (sfd) and connect to server
2. create epoll (efd)
3. add socket descriptor (sfd) to epoll (efd) with flag EPOLLET
4. get a EPOLLOUT event through epoll_wait

After that, the program will nerver get a EPOLLOUT event because ituse
EPOLLET mode (the same event will not be got twice)

BUT=A3=ACwhen a message comes from server=A3=ACthe client socket will g=
et aevent
and this event contains EPOLLOUT and EPOLLIN, looks epoll_waitreturn
too much events than it should

My question is: Is this a bug for epoll ?

Any reply will be appreciate.

--
--
Best Regard
Robin Dong
