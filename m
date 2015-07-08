From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Wed, 8 Jul 2015 16:48:22 -0700
Message-ID: <CALCETrWcgJmZTwW9n5rNPSDXjtUZHg4nBi+f6B7TgjoUf6KHpg@mail.gmail.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
 <CALCETrVg5AyeXW_AGguFoGCPK9_2zeobEgT9JJFsakH6PyQf_A@mail.gmail.com>
 <20150707154345.GA1593@odin.com> <CALCETrVSRkMSAVPz9JW4XCV7DmrgkyGK54HRUrue2R756f5C=Q@mail.gmail.com>
 <20150708161022.GA1705@odin.com> <CALCETrW4LU3M2OAWjnckFR-rqenBjV+ROBi8B3eOo=Y_mCWfGQ@mail.gmail.com>
 <CANaxB-yMKGWJ1r0GMR9VfAq_xHn6bTjYmkDXST4suNNqu4GVjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANaxB-yMKGWJ1r0GMR9VfAq_xHn6bTjYmkDXST4suNNqu4GVjA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Vagin <avagin-wo1vFcy6AUs@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 8, 2015 at 3:49 PM, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> 2015-07-08 20:39 GMT+03:00 Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>:
>> On Wed, Jul 8, 2015 at 9:10 AM, Andrew Vagin <avagin-wo1vFcy6AUs@public.gmane.org> wrote:
>>>
>>> As far as I understand, socket_diag doesn't have this problem, becaus
>>> each socket has a link on a namespace where it was created.
>>>
>>> What if we will pin the current pidns and credentials to a task_diag
>>> socket in a moment when it's created.
>>
>> That's certainly doable.  OTOH, if anything does:
>>
>> socket(AF_NETLINK, ...);
>> unshare(CLONE_PID);
>> fork();
>>
>> then they now have a (minor) security problem.
>
> What do you mean? Is it not the same when we open a file and change
> uid and gid? Permissions are checked only in the "open" syscall.
>
> [root@avagin-fc19-cr ~]# ls -l xxx
> -rw-r--r-- 1 root root 5 Jul  9 01:42 xxx
>
> open("xxx", O_WRONLY|O_APPEND)          = 3
> setgid(1000)                            = 0
> setuid(1000)                            = 0
> write(3, "a", 1)                        = 1
> close(1)                                = 0

Yes and no.

open(2) is supposed to return an fd that retains the access to the
file that existed when open(2) was called.  socket(2) is supposed* to
capture the access to the netns that existed at the time it was
called, but capturing access to a userns and/or pidns is new.

If you added socket(AF_NETLINK, SOCK_DGRAM, NETLINK_PIDNS), then maybe
that would work, but the userns interaction is a bit odd.  OTOH every
pidns has an associated userns, so you could just use that.  I don't
know whether that would annoy someone.

* There's some question as to whether socket(2) or connect(2) should
do this, but connect handling in netlink is quite broken and iproute2
relies on the broken handling.  The historical behavior was different,
too, but the old behavior was exploitable.  I have a cute little
program that does 'ip set dev lo down' but doesn't need to be run as
root :)

--Andy
