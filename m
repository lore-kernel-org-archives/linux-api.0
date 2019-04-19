From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v2 2/5] clone: add CLONE_PIDFD
Date: Fri, 19 Apr 2019 23:39:18 +1000
Message-ID: <20190419133918.7uedlqgc6cvt7fjt@yavin>
References: <20190418101841.4476-1-christian@brauner.io>
 <20190418101841.4476-3-christian@brauner.io>
 <20190418131206.GB13701@redhat.com>
 <20190418132822.untjt7erfvbbiz7a@brauner.io>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vpeoutzg3boqufdk"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190418132822.untjt7erfvbbiz7a@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Oleg Nesterov <oleg@redhat.com>, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org


--vpeoutzg3boqufdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-04-18, Christian Brauner <christian@brauner.io> wrote:
> > Why O_CLOEXEC? I am just curious, I do not really care.
>=20
> I think that having the file descriptor O_CLOEXEC by default is a good
> security measure in general. Most of the time you do not want to pass a
> file descriptor through exec() (apart from 0,1,2) and it is usually more
> of an issue when you accidently do it then when you accidently don't. So
> if users really care about passing a pidfd they should do so by removing
> the O_CLOEXEC flag explicitly.
> (New file descriptors should probably all default to that but that's just
> my opinion.)
> Another thing is that for a pidfds it makes even more sense to have them
> cloexec by default. You don't want to *unintentionally* leak an fd that
> can be used to operate on a process.

There is another factor as well -- if you want to set O_CLOEXEC in a
multi-threaded process you can't be sure that another thread didn't fork
in between you getting the fd_install'd and the userspace process
setting O_CLOEXEC (leading to the fd leaking outside the current
process). This is why a lot of syscalls have a way to get an O_CLOEXEC
fd from the outset.

So I'm +1 on doing O_CLOEXEC by default -- you can always disable it
safely but enabling it safely isn't so simple (and I don't think it
makes much sense to add the mechanism to pass PIDFD_CLOEXEC as well,
given how tight the flags are getting).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--vpeoutzg3boqufdk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAly5z4YACgkQSnvnv3De
m58UxRAAgcnnb4NwtWMB9j9vrcjC5M89nkbun9n1RzZA2iKOiguktbzuFqgI3A7F
+M1vvVsOGP5oNDGDXiSX9klXhY+nMQazNBJx0vB0CEQAVY2nL3l+qy0XEEjlgyZ4
/VbXsEI6/SaYKUmDIHmQPKq0QCjC69s5L0O7R1bsnoH5YUVk6m7RNBAMxQ+EZ/Fn
BhV0WAiBsjOk6fM12RpbWFeEV5cg9UB4OI+75S1zpirhVsMo1d0xtDwD/2dEfrAl
undKn+rDuhh5/ULP76drQ9XWnB24F9qiqvx2/H8vrCLYY8vOmhanC1Xii2HaXKPQ
8ggaFeDY3/rO6h2TIXNzW6d5bj8ezveiOtMngVaIeAXCi0se13iCYcRzVjPHGwBw
/V+NaHktML75wazFadXkMp0rlyWr6ua6lClnCz8TN2cEonHHRJQKIz4rr+JedqQh
rl9svBSn7kP+6A0H6ch1s2Lx+dcSMIBA05HFM9S8RoKUn3i0OM8DZzkikcctGwid
Dc2HASNmm3lCWg030Fdym+p4Ndzl1Dr9IFCLV/Zwso8rsbaFGoY4nMa1TLUmbS+w
7cmgFd+imZrlcbrTTUvVsYBGPZ5G9EYbIefO/PqVlARxK7aa3urQFj4pjyKTodUI
1Ou6fi1anhOAp1JOkxlXIdrLfB5RvoxcH3sUKizN33QjBT/zIzU=
=enJD
-----END PGP SIGNATURE-----

--vpeoutzg3boqufdk--
