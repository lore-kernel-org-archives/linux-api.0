From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Mon, 14 Dec 2015 10:52:18 +0300
Message-ID: <20151214075217.GB4112@odin.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
 <20151124151811.GA16393@odin.com>
 <CALCETrUzOBybH0-rcgvzMNazjadZpuxkBZLkoUDY30X_-cqBzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUzOBybH0-rcgvzMNazjadZpuxkBZLkoUDY30X_-cqBzg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 03, 2015 at 03:20:30PM -0800, Andy Lutomirski wrote:
> On Tue, Nov 24, 2015 at 7:18 AM, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> =
wrote:
> > Hello Everybody,
> >
> > Sorry for the long delay. I wanted to resurrect this thread.
> >
> > Andy suggested to create a new syscall instead of using netlink
> > interface.
> >> Would it make more sense to have a new syscall instead?  You could
> >> even still use nlattr formatting for the syscall results.
> >
> > I tried to implement it to understand how it looks like. Here is my
> > version:
> > https://github.com/avagin/linux-task-diag/blob/task_diag_syscall/ke=
rnel/task_diag.c#L665
> > I could not invent a better interfaces for it than using netlink
> > messages as arguments. I know it looks weird.
> >
> > I could not say that I understood why a new system call is better
> > than using a netlink socket, so I tried to solve the problem which
> > were mentioned for the netlink interface.
> >
> > The magor question was how to support pid and user namespaces in ta=
sk_diag.
> > I think I found a good and logical solution.
> >
> > As for pidns, we can use scm credentials, which is connected to eac=
h
> > socket message. They contain requestor=E2=80=99s pid and we can get=
 a pid
> > namespace from it. In this case, we get a good feature to specify a=
 pid
> > namespace without entering into it. For that, an user need to speci=
fy
> > any process from this pidns in an scm message.
>=20
> That seems a little messy.  A process can't currently move into
> another pidns, but how do you make sure you have any pid at all that
> belongs to the reference pidns?  You can, of course, always use your
> own pid, but that still seems odd to me.

There is your pid by default, you need to do nothing for that.
If we look at containers or sandboxes, we ussualy know PID of
the init process.


>=20
> >
> > As for credentials, we can get them from file->f_cred. In this case=
 we
> > are able to create a socket and decrease permissions of the current
> > process, but the socket will work as before. It=E2=80=99s the commo=
n behaviour for
> > file descriptors.
>=20
> Slightly off-topic, but this netlink is really rather bad as an
> example of how fds can be used as capabilities (in the real capabilit=
y
> sense, not the Linux capabilities sense).  You call socket and get a
> socket.  That socket captures f_cred.  Then you drop privs, and you
> assume that the socket you're holding on to retains the right to do
> certain things.
>=20
> This breaks pretty badly when, through things such as this patch set,
> existing code that creates netlink sockets suddenly starts capturing
> brand-new rights that didn't exist as part of a netlink socket before=
=2E

Sorry, I don't understand this part. Could you eloborate? Maybe give an
example.

I always think that it's a feature, that we can create a descriptor and
drop capabilities of the process or send this descriptor to an
unprivilieged process.

I think this part may be critical for understanding your point of view.
Thanks.

>=20
> From my perspective, netlink is a lot like ioctl, only without the
> meaningful fd that you're calling it on.  So why is it better than
> syscalls?  I'll grant that it comes with nice (?) buffering machinery=
=2E

The nice buffering machinery is one of the reasons. Another reason is
that netlink is a ready interface for this sort of task, so we can avoi=
d
code duplacation.

>=20
> > * Netlink is designed for such type of workloads. It allows to expa=
nd
> >   the interface and save backward compatibility. It allows to gener=
ates
> >   packets with a different set of parameters.
> > * If we use a file descriptor, we can create it and decrease
> >   capabilities of the current process. It's a good feature which wi=
ll be
> >   unavailable if we decide to create a system call.
>=20
> If this is actually a real goal and it matters, then I'd suggest doin=
g
> it right.  Make a way to create an fd that represents a pidns and,
> specifically, the right to query non-secret properties of the
> processes in the pidns.

I will think. Thank you for comments.

>=20
> --Andy
