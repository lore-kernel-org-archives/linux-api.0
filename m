From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Thu, 3 Dec 2015 15:20:30 -0800
Message-ID: <CALCETrUzOBybH0-rcgvzMNazjadZpuxkBZLkoUDY30X_-cqBzg@mail.gmail.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org> <20151124151811.GA16393@odin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124151811.GA16393-wo1vFcy6AUs@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 24, 2015 at 7:18 AM, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wr=
ote:
> Hello Everybody,
>
> Sorry for the long delay. I wanted to resurrect this thread.
>
> Andy suggested to create a new syscall instead of using netlink
> interface.
>> Would it make more sense to have a new syscall instead?  You could
>> even still use nlattr formatting for the syscall results.
>
> I tried to implement it to understand how it looks like. Here is my
> version:
> https://github.com/avagin/linux-task-diag/blob/task_diag_syscall/kern=
el/task_diag.c#L665
> I could not invent a better interfaces for it than using netlink
> messages as arguments. I know it looks weird.
>
> I could not say that I understood why a new system call is better
> than using a netlink socket, so I tried to solve the problem which
> were mentioned for the netlink interface.
>
> The magor question was how to support pid and user namespaces in task=
_diag.
> I think I found a good and logical solution.
>
> As for pidns, we can use scm credentials, which is connected to each
> socket message. They contain requestor=E2=80=99s pid and we can get a=
 pid
> namespace from it. In this case, we get a good feature to specify a p=
id
> namespace without entering into it. For that, an user need to specify
> any process from this pidns in an scm message.

That seems a little messy.  A process can't currently move into
another pidns, but how do you make sure you have any pid at all that
belongs to the reference pidns?  You can, of course, always use your
own pid, but that still seems odd to me.

>
> As for credentials, we can get them from file->f_cred. In this case w=
e
> are able to create a socket and decrease permissions of the current
> process, but the socket will work as before. It=E2=80=99s the common =
behaviour for
> file descriptors.

Slightly off-topic, but this netlink is really rather bad as an
example of how fds can be used as capabilities (in the real capability
sense, not the Linux capabilities sense).  You call socket and get a
socket.  That socket captures f_cred.  Then you drop privs, and you
assume that the socket you're holding on to retains the right to do
certain things.

This breaks pretty badly when, through things such as this patch set,
existing code that creates netlink sockets suddenly starts capturing
brand-new rights that didn't exist as part of a netlink socket before.

=46rom my perspective, netlink is a lot like ioctl, only without the
meaningful fd that you're calling it on.  So why is it better than
syscalls?  I'll grant that it comes with nice (?) buffering machinery.

> * Netlink is designed for such type of workloads. It allows to expand
>   the interface and save backward compatibility. It allows to generat=
es
>   packets with a different set of parameters.
> * If we use a file descriptor, we can create it and decrease
>   capabilities of the current process. It's a good feature which will=
 be
>   unavailable if we decide to create a system call.

If this is actually a real goal and it matters, then I'd suggest doing
it right.  Make a way to create an fd that represents a pidns and,
specifically, the right to query non-secret properties of the
processes in the pidns.

--Andy
