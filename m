From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v6 4/5] seccomp: add support for passing fds via
 USER_NOTIF
Date: Thu, 13 Sep 2018 19:42:56 +1000
Message-ID: <20180913094256.gpwrlu4gnjn6zyhn@mikami>
References: <20180906152859.7810-1-tycho@tycho.ws>
 <20180906152859.7810-5-tycho@tycho.ws>
 <CALCETrWZmN4FeCSwemfMeayupBmQ-NqpVWQuqSU34CLvzdx8gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6ksm43o3rqx7ajcf"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWZmN4FeCSwemfMeayupBmQ-NqpVWQuqSU34CLvzdx8gw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org


--6ksm43o3rqx7ajcf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-09-12, Andy Lutomirski <luto@amacapital.net> wrote:
> > The idea here is that the userspace handler should be able to pass an fd
> > back to the trapped task, for example so it can be returned from socket=
().
> >
> > I've proposed one API here, but I'm open to other options. In particula=
r,
> > this only lets you return an fd from a syscall, which may not be enough=
 in
> > all cases. For example, if an fd is written to an output parameter inst=
ead
> > of returned, the current API can't handle this. Another case is that
> > netlink takes as input fds sometimes (IFLA_NET_NS_FD, e.g.). If netlink
> > ever decides to install an fd and output it, we wouldn't be able to han=
dle
> > this either.
>=20
> An alternative could be to have an API (an ioctl on the listener,
> perhaps) that just copies an fd into the tracee.  There would be the
> obvious set of options: do we replace an existing fd or allocate a new
> one, and is it CLOEXEC.  Then the tracer could add an fd and then
> return it just like it's a regular number.
>=20
> I feel like this would be more flexible and conceptually simpler, but
> maybe a little slower for the common cases.  What do you think?

When we first discussed this I sent a (probably somewhat broken) patch
for "dup4" which would let you inject a file descriptor into a different
process -- I still think that having a method for injecting a file
descriptor without needing ptrace (and SCM_RIGHTS) shenanigans would be
generally useful. (With "dup4" you have a more obvious API for flags and
whether you allocate a new fd or use a specific one.)

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--6ksm43o3rqx7ajcf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAluaMR0ACgkQnhiqJn3b
jbRdog//SGIbgcHJBzJCVik/HjW9K8MCFuwaWPTMH5NvZ3L7mVM8z3sztN91sA3R
FMK/t0DfXk7sTQaBo8hy4J636GR37f+GSt1AqowHLiBjOD3zagA6/DO6/9SH7cER
8UsA4sWbdy8s1yEKuOs4q8YMqwvOlSBJGRS/9s4T7I2PaGSHFVxzHWpRnEaQKjHe
fLBDQOAyBu1qGkv5KS1W0uXenjX1cybkYlnZjrsfzd7D7lwcsjKpeZJanrKReS5a
ehHqpiDkI2/IqokIEOqK23SoctJlOFgAVuL5tY7KH7VlC0Vqp+1P5iOD1PEdLzWu
ZHN3TN9U5jmOiUaJebWoylvq06IdllFaiaaRDzBw7HXSUsrJKISHXH04p5Zb8mkC
x0dkuuf+w3fD2/PYHSFxW+QyywuI25+cUHEYUqSqAnJy7gBJDHCv3zp5T1Ab/nHf
SkcHkJxOUCiR3G2ncZMnF2vaYdqVS1rvPPeAkjxVeUVyCkR2G9pkxqeMJMCv5NRR
HaXtS0eN5+tva84gSJy5Q8iq9opYVri/6avLvlyQCuNPt/YSBeTOSiZYeamDIxjY
DZiBI/mv2vDOQUoAY3TpDkhchXq7Tif3B+DED4n3AtduAxojti+tG+pdMMFuCO7g
gpYDbd/qbTCb3NSlqIxw1pzMXJsPUx3eCOJH69mJUf6QB0Bd5I8=
=EVfp
-----END PGP SIGNATURE-----

--6ksm43o3rqx7ajcf--
