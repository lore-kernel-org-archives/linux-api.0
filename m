From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Mon, 19 Nov 2018 11:09:28 +1100
Message-ID: <20181119000928.h2wp2rn2pnlfysp7@yavin>
References: <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org>
 <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
 <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
 <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com>
 <CAKOZuevVk_aH_2TuiNcmxgMa+gHXMBXz6Uu5a6TDjoxjhaE36g@mail.gmail.com>
 <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
 <CAKOZuevRq-igh06zS_nsGG400zXrKFCtajpEG9-xgU2+Rtb2Pw@mail.gmail.com>
 <20181118190504.ixglsqbn6mxkcdzu@yavin>
 <CAKOZuetfqvn1uVqKJ=16iEzG4g449YOjC_tLM60eKBSkv9u+bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xnndpxdsburq7xhv"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuetfqvn1uVqKJ=16iEzG4g449YOjC_tLM60eKBSkv9u+bQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org


--xnndpxdsburq7xhv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-11-18, Daniel Colascione <dancol@google.com> wrote:
> On Sun, Nov 18, 2018 at 11:05 AM, Aleksa Sarai <cyphar@cyphar.com> wrote:
> > On 2018-11-18, Daniel Colascione <dancol@google.com> wrote:
> >> > Here's my point: if we're really going to make a new API to manipula=
te
> >> > processes by their fd, I think we should have at least a decent idea
> >> > of how that API will get extended in the future.  Right now, we have
> >> > an extremely awkward situation where opening an fd in /proc requires
> >> > certain capabilities or uids, and using those fds often also checks
> >> > current's capabilities, and the target process may have changed its
> >> > own security context, including gaining privilege via SUID, SGID, or
> >> > LSM transition rules in the mean time.  This has been a huge source =
of
> >> > security bugs.  It would be nice to have a model for future APIs that
> >> > avoids these problems.
> >> >
> >> > And I didn't say in my proposal that a process's identity should
> >> > fundamentally change when it calls execve().  I'm suggesting that
> >> > certain operations that could cause a process to gain privilege or
> >> > otherwise require greater permission to introspect (mainly execve)
> >> > could be handled by invalidating the new process management fds.
> >> > Sure, if init re-execs itself, it's still PID 1, but that doesn't
> >> > necessarily mean that:
> >> >
> >> > fd =3D process_open_management_fd(1);
> >> > [init reexecs]
> >> > process_do_something(fd);
> >> >
> >> > needs to work.
> >>
> >> PID 1 is a bad example here, because it doesn't get recycled. Other
> >> PIDs do. The snippet you gave *does* need to work, in general, because
> >> if exec invalidates the handle, and you need to reopen by PID to
> >> re-establish your right to do something with the process, that process
> >> may in fact have died between the invalidation and your reopen, and
> >> your reopened FD may refer to some other random process.
> >
> > I imagine the error would be -EPERM rather than -ESRCH in this case,
> > which would be incredibly trivial for userspace to differentiate
> > between.
>=20
> Why would userspace necessarily see EPERM? The PID might get recycled
> into a different random process that the caller has the ability to
> affect.

I'm not sure what you're talking about. execve() doesn't change the PID
of a process, and in the case we are talking about:

  pidX_handle =3D open_pid_handle(pidX);
  [ pidX execs a setuid binary ]
  do_something(pidX_handle);

pidX still has the same PID (so PID recycling is irrelevant in this
case). The key point is whether do_something() should give you an error
in such a state transition, and in that case I would say you'd get
-EPERM which would indicate (obviously) insufficient privileges.

If the PID has died you'd get -ESRCH. Even if it was eventually
recycled. Because you've pinned a 'struct pid'.

> > If you wish to re-open the path that is also trivial by
> > re-opening through /proc/self/fd/$fd -- which will re-do any permission
> > checks and will guarantee that you are re-opening the same 'struct file'
> > and thus the same 'struct pid'.
>=20
> When you reopen via /proc/self/fd, you get a new struct file
> referencing the existing inode, not the same struct file. A new
> reference to the old struct file would just be dup.

I don't think this is really relevant to what I'm trying to say...

> Anyway: what other API requires, for correct operation, occasional
> reopening through /proc/self/fd? It's cumbersome, and it doesn't add
> anything. If we invalidate process handles on execve, and processes
> are legally allowed to re-exec themselves for arbitrary reasons at any
> time, that's tantamount to saying that handles might become invalid at
> any time and that all callers must be prepared to go through the
> reopen-and-retry path before any operation.

O_PATH. In container runtimes this is necessary for several reasons to
protect against malicious container root filesystems as well as avoiding
exposing a dirfd to the container.

In LXC, O_PATH re-opening is used for /dev/ptmx as well as some other
operations. In runc we use it for FIFO re-opening so that we can signal
pid1 in a container to execve() into user code.

So this isn't a new thing.

> Why are we making them do that? So that a process can have an open FD
> that represents a process-operation capability? Which capability does
> the open FD represent?

The re-opening part was just an argument to show that there isn't a
condition where you wouldn't be able to get access to the 'struct pid'.
I doubt that anyone would actually need to use this -- since you'd need
to pass "/proc/pid/fd/..." to a more privileged process in order to use
the re-opening.

But this also means that we don't need to have a concept of a pidfd that
isn't actually associated with a PID but is instead associated with
current->mm (which is what you appear to be proposing with the whole
"identity fd" concept).

> I think when you and Andy must be talking about is an API that looks like=
 this:
>=20
> int open_process_operation_handle(int procfs_dirfd, int capability_bitmas=
k)
>=20
> capability_bitmask would have bits like
>=20
> PROCESS_CAPABILITY_KILL --- send a signal
> PROCESS_CAPABILITY_PTRACE --- attach to a process
> PROCESS_CAPABILITY_READ_EXIT_STATUS --- what it says on the tin
> PROCESS_CAPABILITY_READ_CMDLINE --- etc.
>=20
> Then you'd have system calls like
>=20
> int process_kill(int process_capability_fd, int signo, const union sigval=
 data)
> int process_ptrace_attach(int process_capability_fd)
> int process_wait_for_exit(int process_capability_fd, siginfo_t* exit_info)
>=20
> that worked on these capability bits. If a process execs or does
> something else to change its security capabilities, operations on
> these capability FDs would fail with ESTALE or something and callers
> would have to re-acquire their capabilities.
>=20
> This approach works fine. It has some nice theoretical properties, and
> could allow for things like nicer privilege separation for debuggers.
> I wouldn't mind something like this getting into the kernel.

Andy might be arguing for this (and as you said, I can see the benefit
of doing it this way).

I'm not convinced that doing permission checks on-open is necessary here
-- I get Andy's point about write(2) semantics but I think a new set of
proc_* syscalls wouldn't need to follow those semantics. I might be
wrong though.

> I just don't think this model is necessary right now. I want a small
> change from what we have today, one likely to actually make it into
> the tree. And bypassing the capability FDs and just allowing callers
> to operate directly on process *identity* FDs, using privileges in
> effect at the time of all, is at least no worse than what we have now.
>=20
> That is, I'm proposing an API that looks like this:
>=20
> int process_kill(int procfs_dfd, int signo, const union sigval value)
>=20
> If, later, process_kill were to *also* accept process-capability FDs,
> nothing would break.

Again, I think we should agree on whether it's necessary to have both
types of fds before we commit to maintaining both APIs forever...

> >> The only way around this problem is to have two separate FDs --- one
> >> to represent process identity, which *must* be continuous across
> >> execve, and the other to represent some specific capability, some
> >> ability to do something to that process. It's reasonable to invalidate
> >> capability after execve, but it's not reasonable to invalidate
> >> identity. In concrete terms, I don't see a big advantage to this
> >> separation, and I think a single identity FD combined with
> >> per-operation capability checks is sufficient. And much simpler.
> >
> > I think that the error separation above would trivially allow user-space
> > to know whether the identity or capability of a process being monitored
> > has changed.
> >
> > Currently, all operations on a '/proc/$pid' which you've previously
> > opened and has died will give you -ESRCH.
>=20
> Not the case. Zombies have died, but profs operations work fine on zombie=
s.

It is the case if the process is dead in the sense that the PID might be
re-used. That is what I meant be "dead" here, not semi-dead in the sense
that zombies are.

> >> > Similarly, it seems like
> >> > it's probably safe to be able to open an fd that lets you watch the
> >> > exit status of a process, have the process call setresuid(), and sti=
ll
> >> > see the exit status.
> >>
> >> Is it? That's an open question.
> >
> > Well, if we consider wait4(2) it seems that this is already the case.
> > If you fork+exec a setuid binary you can definitely see its exit code.
>=20
> Only if you're the parent. Otherwise, you can't see the process exit
> status unless you pass a ptrace access check and consult
> /proc/pid/stat after the process dies, but before the zombie
> disappears. Random unrelated and unprivileged processes can't see exit
> statuses from distant parts of the system.

Sure, I'd propose that ptrace_may_access() is what we should use for
operation permission checks.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--xnndpxdsburq7xhv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlvx/zcACgkQSnvnv3De
m5/y1A/7BsU8nrbbk4WkM6zHX4iWZMUB0JrNF66rv8nPYq16fDSrEoUtSxbpYVgq
UXkodHIZNoxkLE39NhP1z3cr1GjSwRifB++3XYSWgTA6R72U+hCDkL3VGiZOIV+g
OPkthne/oZNK8oGUFFGkSIFe1zAJ3ApCwzf6FMcRm7UphpOgRgdiSli/SdxXy11X
wVPoJObkHgcuKoqfii59xQU7aEi//D7MYvgDCMZ7h5baJ484+AQG2aXtdsGhNJM0
jxC7+0wF9yZ+JzSUw5tweBFHWzrHAZBvOpyP9ia2LKg3jy0lRXCAm9qL9jMqtwYk
boVYm1p4406zWSkBJa7lJ0lgvKBX07jq844P2VKSHFsiFXYxYc9t/rNmO6KhkL5D
u3xxSRRnYGqbAFuAnTxMJk5VQmwz8/jDzhKskh+wdMIvbNZrdiFLtQM0s2hQcWiL
0X+77/JRJh6ujf2g3I7c7NPZAA8jqbGB3tNDKVOOMoUUxMsQuhph0AJj81u4F42Q
J5s48tdpS5Qev3AAXnCAtSWAUpQqZj4apJ9q+iKeyLW7r1/+bCE++Bi/Ska1e2aa
Dm9ByuVn1yVcPUjH6A9pEltJoFklAT/sPdCRBbECgcOKQRD0btmzyBEVF2haGwqv
TfoCm+L/hxNVBL1+AUs9/wF465LkCY+MrymQsCFqwr30Wi9Npxk=
=O+a0
-----END PGP SIGNATURE-----

--xnndpxdsburq7xhv--
