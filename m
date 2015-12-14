From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Mon, 14 Dec 2015 14:38:06 -0800
Message-ID: <CALCETrU_MtDa3p64R5bLx4BU5mKTDD0iEgtA4nLRHPfS2JbhOQ@mail.gmail.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
 <20151124151811.GA16393@odin.com> <CALCETrUzOBybH0-rcgvzMNazjadZpuxkBZLkoUDY30X_-cqBzg@mail.gmail.com>
 <20151214075217.GB4112@odin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151214075217.GB4112@odin.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vagin <avagin@virtuozzo.com>
Cc: Roger Luethi <rl@hellgate.ch>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Andrey Vagin <avagin@openvz.org>, Pavel Odintsov <pavel.odintsov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
List-Id: linux-api@vger.kernel.org

On Dec 13, 2015 11:52 PM, "Andrew Vagin" <avagin@virtuozzo.com> wrote:
>
> On Thu, Dec 03, 2015 at 03:20:30PM -0800, Andy Lutomirski wrote:
> > On Tue, Nov 24, 2015 at 7:18 AM, Andrew Vagin <avagin@virtuozzo.com=
> wrote:
> > > Hello Everybody,
> > >
> > > Sorry for the long delay. I wanted to resurrect this thread.
> > >
> > > Andy suggested to create a new syscall instead of using netlink
> > > interface.
> > >> Would it make more sense to have a new syscall instead?  You cou=
ld
> > >> even still use nlattr formatting for the syscall results.
> > >
> > > I tried to implement it to understand how it looks like. Here is =
my
> > > version:
> > > https://github.com/avagin/linux-task-diag/blob/task_diag_syscall/=
kernel/task_diag.c#L665
> > > I could not invent a better interfaces for it than using netlink
> > > messages as arguments. I know it looks weird.
> > >
> > > I could not say that I understood why a new system call is better
> > > than using a netlink socket, so I tried to solve the problem whic=
h
> > > were mentioned for the netlink interface.
> > >
> > > The magor question was how to support pid and user namespaces in =
task_diag.
> > > I think I found a good and logical solution.
> > >
> > > As for pidns, we can use scm credentials, which is connected to e=
ach
> > > socket message. They contain requestor=E2=80=99s pid and we can g=
et a pid
> > > namespace from it. In this case, we get a good feature to specify=
 a pid
> > > namespace without entering into it. For that, an user need to spe=
cify
> > > any process from this pidns in an scm message.
> >
> > That seems a little messy.  A process can't currently move into
> > another pidns, but how do you make sure you have any pid at all tha=
t
> > belongs to the reference pidns?  You can, of course, always use you=
r
> > own pid, but that still seems odd to me.
>
> There is your pid by default, you need to do nothing for that.
> If we look at containers or sandboxes, we ussualy know PID of
> the init process.
>
>
> >
> > >
> > > As for credentials, we can get them from file->f_cred. In this ca=
se we
> > > are able to create a socket and decrease permissions of the curre=
nt
> > > process, but the socket will work as before. It=E2=80=99s the com=
mon behaviour for
> > > file descriptors.
> >
> > Slightly off-topic, but this netlink is really rather bad as an
> > example of how fds can be used as capabilities (in the real capabil=
ity
> > sense, not the Linux capabilities sense).  You call socket and get =
a
> > socket.  That socket captures f_cred.  Then you drop privs, and you
> > assume that the socket you're holding on to retains the right to do
> > certain things.
> >
> > This breaks pretty badly when, through things such as this patch se=
t,
> > existing code that creates netlink sockets suddenly starts capturin=
g
> > brand-new rights that didn't exist as part of a netlink socket befo=
re.
>
> Sorry, I don't understand this part. Could you eloborate? Maybe give =
an
> example.
>
> I always think that it's a feature, that we can create a descriptor a=
nd
> drop capabilities of the process or send this descriptor to an
> unprivilieged process.

Suppose there's an existing program that likes this feature.  It
creates a netlink socket, optionally calls connect(2), and then drop
privileges.  It expects to retain some subset of its privileges.

The problem is that by increasing the power of a netlink socket
created with higher-than-current privilege, you've just increased the
privilege retained by the old app.  In this particular case, it's
especially odd because it retains privilege over the old pidns,
whereas the old program (in theory -- probably no one does this) could
have created a netlink socket, unshared pidns, and forked, and it
would have expected to retain no privilege over the old pidns.

--Andy
