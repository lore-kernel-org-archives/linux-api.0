From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Mon, 19 Nov 2018 11:08:57 +1100
Message-ID: <20181119000857.rnkuqdpmcutrwtem@yavin>
References: <20181118111751.6142-1-christian@brauner.io>
 <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
 <20181118174148.nvkc4ox2uorfatbm@brauner.io>
 <CAKOZueto1CmUSWFKjOkazcDcZH6CiXXCr4U=ghewLh8GjE2-=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ijvdjms7swqdynhj"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZueto1CmUSWFKjOkazcDcZH6CiXXCr4U=ghewLh8GjE2-=A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Christian Brauner <christian@brauner.io>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org


--ijvdjms7swqdynhj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-11-18, Daniel Colascione <dancol@google.com> wrote:
> > The gist is to have file descriptors for processes which is obviously n=
ot a new
> > idea. This has been done before in other OSes and it has been tried bef=
ore in
> > Linux [2], [3] (Thanks to Kees for pointing out these patches.). So I w=
ant to
> > make it very clear that I'm not laying claim to this being my or even a=
 novel
> > idea in any way. However, I want to diverge from previous approaches wi=
th my
> > suggestion. (Though I can't be sure that there's not something similar =
in other
> > OSes already.)
>=20
> Windows works basically as you describe. You can create a process is
> suspended state, configure it however you want, then let it run.
> CreateProcess (and even moreso, NtCreateProcess) also provide a rich
> (and *extensible*) interface for pre-creation process configuration.
>=20
> >> One of the main motivations for having procfds is to have a race-free =
way of
> > configuring, starting, polling, and killing a process. Basically, a pro=
cess
> > lifecycle api if you want to think about it that way. The api should al=
so be
> > easily extendable in the future to avoid running into the limitations we
> > currently see with the clone*() syscall(s) again.
> >
> > One of the crucial points of the api is to *separate the configuration
> > of a process through a procfd from actually creating the process*.
> > This is a crucial property expressed in the open*() system calls. First=
, get a
> > stable handle on an object then allow for ways to configure it. As such=
 the
> > procfd api shares the same insight with Al's and David's new mount api.
> > (Fwiw, Andy also pointed out similarities with posix_spawn().)
> > What I envisioned was to have the following syscalls (multiple name sug=
gestions):
> >
> > 1. int process_open / proc_open / procopen
> > 2. int process_config / proc_config / procconfig or ioctl()-based
> > 3. int process_info / proc_info / procinfo or ioctl()-based
> > 4. int process_manage / proc_manage / procmanage or ioctl()-based
>=20
> The API you've proposed seems fine to me, although I'd either 1)
> consolidate operations further into one system call, or 2) separate
> the different management operations into more and different system
> calls that can be audited independently. The grouping you've proposed
> seems to have the worst aspects of API splitting and API multiplexing.
> But I have no objection to it in spirit.

I think combining it all into one API is going to be a soft re-invention
of ioctls, but specifically for procfds. This would be an improvement
over just ioctls (since the current ioctl namespacing is based on
well-behaved drivers and hoping we never have more than 256 ioctl
drivers), but I'm not sure it would help make the API nicer than having
separate syscalls (we'd have to do something similar to bpf(2) which I'm
not a huge fan of).

> That said, while I do want to fix process configuration and startup
> generally, I want to fix specific holes in the existing API surface
> first. The two patches I've already sent do that, and this work
> shouldn't wait on an ideal larger process-API overhaul that may or may
> not arrive. Based on previous history, I suspect that an API of the
> scope you're proposing would take years to overcome all LKML
> objections and land. I don't want to wait that long when we can make
> smaller fixes that would not conflict with the general architecture.

I believe this is precisely what Christian is trying to do with this
patch (and you say as much later in your mail).

I think that adding all of {sighand,sighand_exitcode,kill,...} would not
help the path of landing a much larger API change. We should instead
think about the API we want at the end of the day, and then land smaller
changes which are long-term compatible (and won't just become deprecated
APIs -- there's far too many of them, let's not add more needlessly).

If the plan is to have an ioctl API we should merge minor ioctls first.
If the idea is to have an explosion of syscalls, then we should merge
minor syscalls first. We shouldn't merge procfiles if the end goal is to
not use them.

> Next, I want to merge my exithand proposal, or something like it. It's
> likewise a simple change that, in a minimal way, addresses a
> longstanding API deficiency. I'm very strongly against the
> POLLERR-on-directory variant of the idea.

I agree with you on this need. I will admit I do somewhat like the EOF
solution (mainly because it seamlessly deals with the multi-reader case)
but I'm still not sure I like /proc/$pid/exit_sighand. As mentioned in
the other discussion, ideally we would be only ever operating with the=20

An ugly strawman of an alternative would be an interface that gave you
an fd that you could similarly wait-until-EOF on, but that's probably
not a major API improvement unless we also make said API provide exit
status information in a way that works with the
multiple-readers-with-different-creds usecase.

One other thing I think we should eventually consider is to provide an
API which pings a listener whenever a process does an execve() (and
possibly fork()). This is something you can get from FreeBSD's kqueue --
and is something that we have in a really neutered form in the "proc
connector". But of course we can discuss this separately, especially if
we have an extensible API idea in mind when we start.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--ijvdjms7swqdynhj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlvx/xgACgkQSnvnv3De
m58agQ//cvyjY9pM/lVaNr5JmIj/XQ5AgZQ5jKUqmXD3F5BOA92PTqcBw6wyiMvS
xGlqbriX4QK0N5LXM7iB/L6AhGU6Ih5lxQnkp9p14mTcPf0wzrqq3YgcxeEiQnyo
8PnMyqA/b20hDsqVBqQMr+KvRQ7KuSKkRPdUzL4/1FhBG49VZvizaKxX8XXdpe5C
VyZMt8qSwqjxKt5MeSSMrguE7yTG7iBsO+URLNCwzX8NzWIOO99S6TcNSrFbaFjF
hqu9vhfdUtHMdwO8ii5qpQ0JaP1qWV6HTzwG2I2T1uVYJdERQVCBDxKo5+YVDAVV
Duc4TqjFOtjLkUM7j/tQODIdT8uTQOPLkSXyCb0eCbjq4a1Ca/T84olwVCJPuosP
mUTR5wTSm0Fuuw64y7GHg1ohzz3UATsIxdm4LfMIvC9WDogD0oDwIeUQTUWLtb7S
mK+OQMyaged5g7xvoUHBmzvFebBxqn6fw5Lwh9BpWtH8RZxdq8nJmMj3KtQJqh4f
idf3UcZprVwrE+g0Btr8axtkNTu8g0Q5xXrlqAithonIn98gONc3nAwrF2Loz9Ze
hXmBmaqJaqaTosZthTcETc5bBWWvr3zNznyi/bKLXWCMmTcNTwzFmOMSV6JKiohJ
pgpvtV4oy2+qVFZfQ5pPm8rDNkrpcO5rcisC66hSCSZhnADif9E=
=Ez1D
-----END PGP SIGNATURE-----

--ijvdjms7swqdynhj--
