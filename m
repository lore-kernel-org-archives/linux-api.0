From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH RFC] pidns: introduce syscall getvpid
Date: Tue, 15 Sep 2015 17:41:43 +0000
Message-ID: <20150915174143.GE4699@ubuntumail>
References: <20150915120924.14818.49490.stgit@buzz>
 <87h9mvg3kw.fsf@x220.int.ebiederm.org>
 <55F832D2.1070605@yandex-team.ru>
 <20150915151729.GA144242@dakara>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150915151729.GA144242@dakara>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Quoting St=E9phane Graber (stgraber@ubuntu.com):
> On Tue, Sep 15, 2015 at 06:01:38PM +0300, Konstantin Khlebnikov wrote=
:
> > On 15.09.2015 17:27, Eric W. Biederman wrote:
> > >Konstantin Khlebnikov <khlebnikov@yandex-team.ru> writes:
> > >
> > >>pid_t getvpid(pid_t pid, pid_t source, pid_t target);
> > >>
> > >>This syscall converts pid from one pid-ns into pid in another pid=
-ns:
> > >>it takes @pid in namespace of @source task (zero for current) and
> > >>returns related pid in namespace of @target task (zero for curren=
t too).
> > >>If pid is unreachable from target pid-ns then it returns zero.
> > >
> > >This interface as presented is inherently racy.  It would be bette=
r
> > >if source and target were file descriptors referring to the namesp=
aces
> > >you wish to translate between.
> >=20
> > Yep, it's racy. As well as any operation with non-child pids.
> > With file descriptors for source/target result will be racy anyway.
> >=20
> > >
> > >>Such conversion is required for interaction between processes fro=
m
> > >>different pid-namespaces. For example when system service talks w=
ith
> > >>client from isolated container via socket about task in container=
:
> > >
> > >Sockets are already supported.  At least the metadata of sockets i=
s.
> > >
> > >Maybe we need this but I am not convinced of it's utility.
> > >
> > >What are you trying to do that motivates this?
> >=20
> > I'm working on hierarchical container management system which
> > allows to create and control nested sub-containers from containers
> > ( https://github.com/yandex/porto ). Main server works in host and
> > have to interact with all levels of nested namespaces. This syscall
> > makes some operations much easier: server must remember only pid in
> > host pid namespace and convert it into right vpid on demand.
>=20
> Note that as Eric said earlier, sending a PID inside a ucred through =
a
> unix socket will have the pid translated.
>=20
> So while your solution certainly should be faster, you can already ac=
hieve
> what you want today by doing:
>=20
> =3D=3D Translate PID in container to PID in host
>  - open a socket
>  - setns to container's pidns
>  - send ucred from that container containing the requested container =
PID
>  - host sees the host PID
>=20
> =3D=3D Translate PID on host to PID in container
>  - open a socket
>  - setns to container's pidns
>  - send ucred from the host containing the request host PID
>    (send will fail if the host PID isn't part of that container)
>  - container sees the container PID

In addition, since commit e4bc332451 : /proc/PID/status: show all sets =
of pid according to ns
we now also have 'NSpid' etc in /proc/$$/status.

-serge
