From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v2 1/3] namei: implement O_BENEATH-style AT_* flags
Date: Wed, 10 Oct 2018 18:07:47 +1100
Message-ID: <20181010070747.byi2itbi4j42gynq@ryuk>
References: <20181009065300.11053-1-cyphar@cyphar.com>
 <20181009065300.11053-3-cyphar@cyphar.com>
 <CALCETrUZAYw-g+75WAijS+fmRA_DrTahpv156WrxgYuX3KX2xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n7emm7xa7e276qdd"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUZAYw-g+75WAijS+fmRA_DrTahpv156WrxgYuX3KX2xw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--n7emm7xa7e276qdd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-10-09, Andy Lutomirski <luto@kernel.org> wrote:
> On Mon, Oct 8, 2018 at 11:53 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > * AT_NO_PROCLINK: Disallows ->get_link "symlink" jumping. This is a very
> >   specific restriction, and it exists because /proc/$pid/fd/...
> >   "symlinks" allow for access outside nd->root and pose risk to
> >   container runtimes that don't want to be tricked into accessing a host
> >   path (but do want to allow no-funny-business symlink resolution).
>=20
> Can you elaborate on the use case?
>=20
> If I'm set up a container namespace and walk it for real (through the
> outside /proc/PID/root or otherwise starting from an fd that points
> into that namespace), and I walk through that namespace's /proc, I'm
> going to see the same thing that the processes in the namespace would
> see.  So what's the issue?
>=20
> Similarly, if I somehow manage to walk into the outside /proc, then
> I've pretty much lost regardless of the links.

Well, there's a couple of reasons:

* The original AT_NO_JUMPS patchset similarly disabled "proclinks" but
  it was sort of all contained within AT_NO_JUMPS. In order to have a
  precise 1:1 feature mapping we need this in *some* form (and in v1 the
  only way to get it was to add a separate flag). According to the
  original O_BENEATH changelog, both you and Al pushed for this to be
  part of O_BENEATH. :P

  *However* in v2 of the patchset, proclinks are also disabled by
  AT_BENEATH (because it's not really safe or consistent to allow them
  at the moment -- we'd need to add __d_path checks when jumping through
  them as well if we wanted them to be consistent) -- so the need for
  this flag (purely for AT_NO_JUMPS compatibility) is reduced.

* There were cases in the past where races caused (temporarily)
  something like /proc/self/exe (or a file descriptor referencing the
  host filesystem) to be exposed into a container -- but because of
  set_dumpable they were blocked. CVE-2016-9962 was an example of this
  (it wasn't blocked by set_dumpable -- but the fix used set_dumpable).

  In those cases, if you can trick a host-side process to open that
  procfs file through a symlink/bind-mount (which is technically
  "accessible" but not actually usable by the container process), you
  can trick the resolution to resolve the host filesystem (and this
  might be a file which is unlinked and thus there's no way for __d_path
  checking to verify whether it is safe or not).

  I think that AT_BENEATH allowing only proclinks that result in you
  being under the root is something we might want in the future, but I
  think there are some cases where you want to be _very_ sure you don't
  follow a proclink (now or in the future).

* And finally, some containers run with the host's pidns. This is not a
  usecase that I'm particularly fond of, but some folks do use this (as
  far as I'm aware this is one of the reasons why the subreaper concept
  exists). In those cases, the procfs mount would be able to see the
  host processes -- and thus /proc/self would resolve (as would the
  host's init and so on).

I will admit that this flag is more paranoid than the others though.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--n7emm7xa7e276qdd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlu9pT8ACgkQnhiqJn3b
jbSBVg//c4KvbXk7YydiFAtNTbwXcmuc0QpBJdnDKNZX8J9MrzVvUv0yhbrsrOj+
SBIeBvSytBsbRhVohQSJpR3CUL4BgGKRFh2z7YSVgxa9dOSoFJ+NPLR2RkXl/h2x
59GGaWP/THGOtKheWGMjJgbOJMd31RaNru0w3gZx69kEhU8V3jCFfuTvx1s+RP9O
sUA4E+nHcoVxPp7lZRtF1odlEBOrqo6V9Nw9gDOPKWK/dI6wiIZMsfzo72Q+xaZh
7XURnAKdLHTqQX+GQ/ydPfNaBZb2ccn4fAg2dlRmlN27rESfwaqj+wOgPJyNOYPE
RHYCaJKh6xXbq3KbeIxgIWhHQRjnB+sZt8CdXlikFAWST3vOXIiqwkbh9Whnqrz+
W75INjqyzstSlgXpEqBQZ0nneHkt94C8hQE8qn3tkEdVmx2reoYK+1ZNBuR0hK7G
vOvT2xEB1i2Lkd3qhZQjcKDFZ8o0D1oA8tVGL9Nne21c4AFomYlRB7j4C+Pw6K5U
c94RS53SjMpIpgbmS4EnwYUHPmuuQe98h5O+WxOMvnBrIcs1OqgUTmTFR4/a/De6
hoFfo1nszzlieolP9lS3fbY/q1DFWtX4XyuxgMW0FxmjkSer2zlPG9khkbfYhwks
DWRx2nas50uUEWsI9SPSZbFbRrDC+IeJ3UicDXdLOxNE43/R3wU=
=QM+v
-----END PGP SIGNATURE-----

--n7emm7xa7e276qdd--
