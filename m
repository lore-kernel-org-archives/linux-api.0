From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Mon, 19 Nov 2018 06:05:04 +1100
Message-ID: <20181118190504.ixglsqbn6mxkcdzu@yavin>
References: <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
 <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
 <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org>
 <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
 <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
 <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com>
 <CAKOZuevVk_aH_2TuiNcmxgMa+gHXMBXz6Uu5a6TDjoxjhaE36g@mail.gmail.com>
 <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
 <CAKOZuevRq-igh06zS_nsGG400zXrKFCtajpEG9-xgU2+Rtb2Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n33er6mvlsotrfdd"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuevRq-igh06zS_nsGG400zXrKFCtajpEG9-xgU2+Rtb2Pw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org


--n33er6mvlsotrfdd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-11-18, Daniel Colascione <dancol@google.com> wrote:
> > Here's my point: if we're really going to make a new API to manipulate
> > processes by their fd, I think we should have at least a decent idea
> > of how that API will get extended in the future.  Right now, we have
> > an extremely awkward situation where opening an fd in /proc requires
> > certain capabilities or uids, and using those fds often also checks
> > current's capabilities, and the target process may have changed its
> > own security context, including gaining privilege via SUID, SGID, or
> > LSM transition rules in the mean time.  This has been a huge source of
> > security bugs.  It would be nice to have a model for future APIs that
> > avoids these problems.
> >
> > And I didn't say in my proposal that a process's identity should
> > fundamentally change when it calls execve().  I'm suggesting that
> > certain operations that could cause a process to gain privilege or
> > otherwise require greater permission to introspect (mainly execve)
> > could be handled by invalidating the new process management fds.
> > Sure, if init re-execs itself, it's still PID 1, but that doesn't
> > necessarily mean that:
> >
> > fd =3D process_open_management_fd(1);
> > [init reexecs]
> > process_do_something(fd);
> >
> > needs to work.
>=20
> PID 1 is a bad example here, because it doesn't get recycled. Other
> PIDs do. The snippet you gave *does* need to work, in general, because
> if exec invalidates the handle, and you need to reopen by PID to
> re-establish your right to do something with the process, that process
> may in fact have died between the invalidation and your reopen, and
> your reopened FD may refer to some other random process.

I imagine the error would be -EPERM rather than -ESRCH in this case,
which would be incredibly trivial for userspace to differentiate
between. If you wish to re-open the path that is also trivial by
re-opening through /proc/self/fd/$fd -- which will re-do any permission
checks and will guarantee that you are re-opening the same 'struct file'
and thus the same 'struct pid'.

> The only way around this problem is to have two separate FDs --- one
> to represent process identity, which *must* be continuous across
> execve, and the other to represent some specific capability, some
> ability to do something to that process. It's reasonable to invalidate
> capability after execve, but it's not reasonable to invalidate
> identity. In concrete terms, I don't see a big advantage to this
> separation, and I think a single identity FD combined with
> per-operation capability checks is sufficient. And much simpler.

I think that the error separation above would trivially allow user-space
to know whether the identity or capability of a process being monitored
has changed.

Currently, all operations on a '/proc/$pid' which you've previously
opened and has died will give you -ESRCH. So the above separation I
mentioned is entirely consistent with how users are using '/proc/$pid'
to check for PID death today.

> > I think you're overstating your case.  To a pretty good approximation,
> > setresuid() allows the caller to remove elements from the set {ruid,
> > suid, euid}, unless the caller has CAP_SETUID.  If you could ptrace a
> > process before it calls setresuid(), you might as well be able to
> > ptrace() it after, since you could have just ptraced it and made it
> > call setresuid() while still ptracing it.
>=20
> What about a child that execs a setuid binary?

Yeah, for this reason I think that using -EPERM on operations that we
think are not reasonable to allow possibly-less-privileged processes to
do -- probably the most reasonable choice would be ptrace_may_access().

> > Similarly, it seems like
> > it's probably safe to be able to open an fd that lets you watch the
> > exit status of a process, have the process call setresuid(), and still
> > see the exit status.
>=20
> Is it? That's an open question.

Well, if we consider wait4(2) it seems that this is already the case.
If you fork+exec a setuid binary you can definitely see its exit code.

> > My POLLERR hack, aside from being ugly,
> > avoids this particular issue because it merely lets you wait for
> > something you already could have observed using readdir().
>=20
> Yes. I mentioned this same issue-punting as the motivation behind
> exithand, initially, just reading EOF on exit.

One question I have about EOF-on-exit is that if we wish to extend it to
allow providing the exit status (which is something we discussed in the
original thread), how will multiple-readers be handled in such a
scenario? Would we be storing the exit status or siginfo in the
equivalent of a locked memfd?

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--n33er6mvlsotrfdd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlvxt90ACgkQSnvnv3De
m5907w/+Izk6UkNPV6dusUBlHUV56jUtHKpSc4dYRGSGmZu5WY6oiWap0GD5baVg
3nRrnRnAQh+8eJtzi5X/k5QJPpGAzigcg/b20JBPvsCUgfG/ZbvnDRKqObYREWRL
R3RrgiKprp9pUUWOrn5DzET/bqbN96jsEQd9KCn44+XeZXwaEy0c5fk82+0Oz4OW
FG2g8K5Y4kayg8yw8WjXoGssAcUWGsxUxcmkmiOoEx+rDiAXhKlCbQnnOtKKDdF3
HRpVCcJPvnGfVxDbuWcrXqmWmZFsMWs1ohnVKd6AeTSsvNS/qHfci66xi/8aG+iQ
T3NZI0pqNveQLqCQ5D4yCoxavPcZ0K2M8p0cgTV87q7IKqc2HLwc7AhP4x5b34r4
CWqwQ7k4Rj57qq+Hpd1SjgrlmW2nq7FyoETDX6oYOo9wXyE4vN2SKMwzF9wgCENB
K9x/yoe0EB4LPb5Ue0mbY5yUxQBoj1NY0y+ruKn+emNsUkd0+HmCcRCVe0J+TveR
B9xhnVKS2t7NlmzsKZ+ZS7UikAf0Vdj0vEtzpD2mtXSTxkgx02AQHI6+EG3svAQD
osbX/Ne3f0jBGX1+Nw2V34lFHsD2a6cLVb5WzDFswzU+fZk5T3lBl7RXsVSw4Rkm
7C5BhJAuUJriF5+1yHax30j+DCCpf7oszI8Wp0x7R3Yj5QxtcRQ=
=rhny
-----END PGP SIGNATURE-----

--n33er6mvlsotrfdd--
