From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Tue, 15 Dec 2015 18:53:59 +0300
Message-ID: <20151215155358.GC24236@odin.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
 <20151124151811.GA16393@odin.com>
 <CALCETrUzOBybH0-rcgvzMNazjadZpuxkBZLkoUDY30X_-cqBzg@mail.gmail.com>
 <20151214075217.GB4112@odin.com>
 <CALCETrU_MtDa3p64R5bLx4BU5mKTDD0iEgtA4nLRHPfS2JbhOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrU_MtDa3p64R5bLx4BU5mKTDD0iEgtA4nLRHPfS2JbhOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 14, 2015 at 02:38:06PM -0800, Andy Lutomirski wrote:
> On Dec 13, 2015 11:52 PM, "Andrew Vagin" <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote=
:
> >
> > On Thu, Dec 03, 2015 at 03:20:30PM -0800, Andy Lutomirski wrote:
> > > On Tue, Nov 24, 2015 at 7:18 AM, Andrew Vagin <avagin@virtuozzo.c=
om> wrote:
> > > > Hello Everybody,
> > > >
> > > > Sorry for the long delay. I wanted to resurrect this thread.
> > > >
> > > > Andy suggested to create a new syscall instead of using netlink
> > > > interface.
> > > >> Would it make more sense to have a new syscall instead?  You c=
ould
> > > >> even still use nlattr formatting for the syscall results.
> > > >
> > > > I tried to implement it to understand how it looks like. Here i=
s my
> > > > version:
> > > > https://github.com/avagin/linux-task-diag/blob/task_diag_syscal=
l/kernel/task_diag.c#L665
> > > > I could not invent a better interfaces for it than using netlin=
k
> > > > messages as arguments. I know it looks weird.
> > > >
> > > > I could not say that I understood why a new system call is bett=
er
> > > > than using a netlink socket, so I tried to solve the problem wh=
ich
> > > > were mentioned for the netlink interface.
> > > >
> > > > The magor question was how to support pid and user namespaces i=
n task_diag.
> > > > I think I found a good and logical solution.
> > > >
> > > > As for pidns, we can use scm credentials, which is connected to=
 each
> > > > socket message. They contain requestor=E2=80=99s pid and we can=
 get a pid
> > > > namespace from it. In this case, we get a good feature to speci=
fy a pid
> > > > namespace without entering into it. For that, an user need to s=
pecify
> > > > any process from this pidns in an scm message.
> > >
> > > That seems a little messy.  A process can't currently move into
> > > another pidns, but how do you make sure you have any pid at all t=
hat
> > > belongs to the reference pidns?  You can, of course, always use y=
our
> > > own pid, but that still seems odd to me.
> >
> > There is your pid by default, you need to do nothing for that.
> > If we look at containers or sandboxes, we ussualy know PID of
> > the init process.
> >
> >
> > >
> > > >
> > > > As for credentials, we can get them from file->f_cred. In this =
case we
> > > > are able to create a socket and decrease permissions of the cur=
rent
> > > > process, but the socket will work as before. It=E2=80=99s the c=
ommon behaviour for
> > > > file descriptors.
> > >
> > > Slightly off-topic, but this netlink is really rather bad as an
> > > example of how fds can be used as capabilities (in the real capab=
ility
> > > sense, not the Linux capabilities sense).  You call socket and ge=
t a
> > > socket.  That socket captures f_cred.  Then you drop privs, and y=
ou
> > > assume that the socket you're holding on to retains the right to =
do
> > > certain things.
> > >
> > > This breaks pretty badly when, through things such as this patch =
set,
> > > existing code that creates netlink sockets suddenly starts captur=
ing
> > > brand-new rights that didn't exist as part of a netlink socket be=
fore.
> >
> > Sorry, I don't understand this part. Could you eloborate? Maybe giv=
e an
> > example.
> >
> > I always think that it's a feature, that we can create a descriptor=
 and
> > drop capabilities of the process or send this descriptor to an
> > unprivilieged process.
>=20
> Suppose there's an existing program that likes this feature.  It
> creates a netlink socket, optionally calls connect(2), and then drop
> privileges.  It expects to retain some subset of its privileges.
>=20
> The problem is that by increasing the power of a netlink socket
> created with higher-than-current privilege, you've just increased the
> privilege retained by the old app.  In this particular case, it's
> especially odd because it retains privilege over the old pidns,
> whereas the old program (in theory -- probably no one does this) coul=
d
> have created a netlink socket, unshared pidns, and forked, and it
> would have expected to retain no privilege over the old pidns.

Thank you for the explanation.  If I understand you correctly, the
problem is that we can use an arbitrary netlink socket to use task_diag=
=2E

It can be a reason to not use netlink interface for task diag.

What do you think about the idea to add a a transaction file in
procfs? We will open it, send a request and get required information.

I want to have a file descriptor to transfer data between kernel and
userspace, because a size of response can be too big to receive it for
one call. If we use a file descriptor, we can divide a response into
parts.

Thanks,
Andrew

> --Andy
