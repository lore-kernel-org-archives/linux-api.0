From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] pidns: introduce syscall getvpid
Date: Wed, 16 Sep 2015 09:39:39 -0500
Message-ID: <20150916143939.GA32226@mail.hallyn.com>
References: <20150915120924.14818.49490.stgit@buzz>
 <87h9mvg3kw.fsf@x220.int.ebiederm.org>
 <55F832D2.1070605@yandex-team.ru>
 <20150915151729.GA144242@dakara>
 <20150915174143.GE4699@ubuntumail>
 <55F91C3D.1040209@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55F91C3D.1040209-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 16, 2015 at 10:37:33AM +0300, Konstantin Khlebnikov wrote:
> On 15.09.2015 20:41, Serge Hallyn wrote:
> >Quoting St=E9phane Graber (stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org):
> >>On Tue, Sep 15, 2015 at 06:01:38PM +0300, Konstantin Khlebnikov wro=
te:
> >>>On 15.09.2015 17:27, Eric W. Biederman wrote:
> >>>>Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> writes:
> >>>>
> >>>>>pid_t getvpid(pid_t pid, pid_t source, pid_t target);
> >>>>>
> >>>>>This syscall converts pid from one pid-ns into pid in another pi=
d-ns:
> >>>>>it takes @pid in namespace of @source task (zero for current) an=
d
> >>>>>returns related pid in namespace of @target task (zero for curre=
nt too).
> >>>>>If pid is unreachable from target pid-ns then it returns zero.
> >>>>
> >>>>This interface as presented is inherently racy.  It would be bett=
er
> >>>>if source and target were file descriptors referring to the names=
paces
> >>>>you wish to translate between.
> >>>
> >>>Yep, it's racy. As well as any operation with non-child pids.
> >>>With file descriptors for source/target result will be racy anyway=
=2E
> >>>
> >>>>
> >>>>>Such conversion is required for interaction between processes fr=
om
> >>>>>different pid-namespaces. For example when system service talks =
with
> >>>>>client from isolated container via socket about task in containe=
r:
> >>>>
> >>>>Sockets are already supported.  At least the metadata of sockets =
is.
> >>>>
> >>>>Maybe we need this but I am not convinced of it's utility.
> >>>>
> >>>>What are you trying to do that motivates this?
> >>>
> >>>I'm working on hierarchical container management system which
> >>>allows to create and control nested sub-containers from containers
> >>>( https://github.com/yandex/porto ). Main server works in host and
> >>>have to interact with all levels of nested namespaces. This syscal=
l
> >>>makes some operations much easier: server must remember only pid i=
n
> >>>host pid namespace and convert it into right vpid on demand.
> >>
> >>Note that as Eric said earlier, sending a PID inside a ucred throug=
h a
> >>unix socket will have the pid translated.
> >>
> >>So while your solution certainly should be faster, you can already =
achieve
> >>what you want today by doing:
> >>
> >>=3D=3D Translate PID in container to PID in host
> >>  - open a socket
> >>  - setns to container's pidns
> >>  - send ucred from that container containing the requested contain=
er PID
> >>  - host sees the host PID
> >>
> >>=3D=3D Translate PID on host to PID in container
> >>  - open a socket
> >>  - setns to container's pidns
> >>  - send ucred from the host containing the request host PID
> >>    (send will fail if the host PID isn't part of that container)
> >>  - container sees the container PID
> >
> >In addition, since commit e4bc332451 : /proc/PID/status: show all se=
ts of pid according to ns
> >we now also have 'NSpid' etc in /proc/$$/status.
> >
>=20
> As I see this works perfectly only for converting host pid into virtu=
al.
>=20
> Backward conversion is troublesome: we have to scan all pids in host
> procfs and somehow filter tasks from container and its sub-pid-ns.
> Or I am missing something trivial?

Ah, no that doesn't help with this.

What St=E9phane describes is what I've done in several projects.
Getting it right is however actually quite tricky.  I'm not
convinced it's at the level of "since you can do (sweep hands)
all this, we don't need a simple syscall to do it."

So I'd encourage you to resend using namespace inode fds for
source and target as Eric suggested.  We still may decide that
the syscall isn't needed, but it's a trivial change to your
patch and removes that race.  And I'm not convinced it's not
needed.

-serge
