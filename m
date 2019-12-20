From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v4 2/5] pid: Add PIDFD_IOCTL_GETFD to fetch file
 descriptors from processes
Date: Fri, 20 Dec 2019 15:35:10 +1100
Message-ID: <20191220043510.r5h6wvsp2p5glyjv@yavin.dot.cyphar.com>
References: <20191218235459.GA17271@ircssh-2.c.rugged-nimbus-611.internal>
 <CAK8P3a2eT=bHkUamyp-P3Y2adNq1KBk7UknCYBY5_aR4zJmYaQ@mail.gmail.com>
 <20191219103525.yqb5f4pbd2dvztkb@wittgenstein>
 <CAMp4zn_z-CCQYMpT=GjZeGVLobjHBCSbmfha1rtWdmptOQ8JtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nmgp7ksjzcrpo6tt"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMp4zn_z-CCQYMpT=GjZeGVLobjHBCSbmfha1rtWdmptOQ8JtA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>, Florian Weimer <fweimer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Gian-Carlo Pascutto <gpascutto@mozilla.com>, Emilio Cobos =?utf-8?Q?=C3=81lvarez?= <ealvarez@mozilla.com>, Jed Davis <jld@mozilla.com>
List-Id: linux-api@vger.kernel.org


--nmgp7ksjzcrpo6tt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-19, Sargun Dhillon <sargun@sargun.me> wrote:
> On Thu, Dec 19, 2019 at 2:35 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> > I guess this is the remaining question we should settle, i.e. what do we
> > prefer.
> > I still think that adding a new syscall for this seems a bit rich. On
> > the other hand it seems that a lot more people agree that using a
> > dedicated syscall instead of an ioctl is the correct way; especially
> > when it touches core kernel functionality. I mean that was one of the
> > takeaways from the pidfd API ioctl-vs-syscall discussion.
> >
> > A syscall is nicer especially for core-kernel code like this.
> > So I guess the only way to find out is to try the syscall approach and
> > either get yelled and switch to an ioctl() or have it accepted.
> >
> > What does everyone else think? Arnd, still in favor of a syscall I take
> > it. Oleg, you had suggested a syscall too, right? Florian, any
> > thoughts/worries on/about this from the glibc side?
> >
> > Christian
>=20
> My feelings towards this are that syscalls might pose a problem if we
> ever want to extend this API. Of course we can have a reserved
> "flags" field, and populate it later, but what if we turn out to need
> a proper struct? I already know we're going to want to add one
> around cgroup metadata (net_cls), and likely we'll want to add
> a "steal" flag as well. As Arnd mentioned earlier, this is trivial to
> fix in a traditional ioctl environment, as ioctls are "cheap". How
> do we feel about potentially adding a pidfd_getfd2? Or are we
> confident that reserved flags will save us?

If we end up making this a syscall, then we can re-use the
copy_struct_from_user() API to make it both extensible and compatible in
both directions. I wasn't aware that this was frowned upon for ioctls
(sorry for the extra work) but there are several syscalls which use this
model for extendability (clone3, openat2, sched_setattr,
perf_events_open) so there shouldn't be any such complaints for a
syscall which is extensible.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--nmgp7ksjzcrpo6tt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXfxPewAKCRCdlLljIbnQ
ElNGAP0QzHxTfcWUIyKQwziyZ7SKPlC5ve6y0476CjvwfTG0mQD+JDR19gzaS69O
MYDK8035BURwBnELBe2PceZHzjVhlAQ=
=Kwh+
-----END PGP SIGNATURE-----

--nmgp7ksjzcrpo6tt--
