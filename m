From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v7 1/6] seccomp: add a return code to trap to userspace
Date: Sat, 29 Sep 2018 10:28:55 +1000
Message-ID: <20180929002855.bcx5u2kabtqjtcnt@mikami>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-2-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q7cghsiykh2acose"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180927151119.9989-2-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, "Eric W . Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org


--q7cghsiykh2acose
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-09-27, Tycho Andersen <tycho@tycho.ws> wrote:
> This patch introduces a means for syscalls matched in seccomp to notify
> some other task that a particular filter has been triggered.
>=20
> The motivation for this is primarily for use with containers. For example,
> if a container does an init_module(), we obviously don't want to load this
> untrusted code, which may be compiled for the wrong version of the kernel
> anyway. Instead, we could parse the module image, figure out which module
> the container is trying to load and load it on the host.
>=20
> As another example, containers cannot mknod(), since this checks
> capable(CAP_SYS_ADMIN). However, harmless devices like /dev/null or
> /dev/zero should be ok for containers to mknod, but we'd like to avoid ha=
rd
> coding some whitelist in the kernel. Another example is mount(), which has
> many security restrictions for good reason, but configuration or runtime
> knowledge could potentially be used to relax these restrictions.

Minor thing, but this is no longer _entirely_ true (now it checks
ns_capable(sb->s_user_ns)). I think the kernel module auto-loading is a
much more interesting example, but since this is just a commit message
feel free to ignore my pedantry. :P

> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> CC: Kees Cook <keescook@chromium.org>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: "Serge E. Hallyn" <serge@hallyn.com>
> CC: Christian Brauner <christian.brauner@ubuntu.com>
> CC: Tyler Hicks <tyhicks@canonical.com>
> CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>

Would you mind adding me to the Cc: list for the next round of patches?
It's looking pretty neat!

Thanks!

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--q7cghsiykh2acose
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAluux0MACgkQnhiqJn3b
jbShfg//elDogyxGNl2K0aVd1a01yiY3io1AMaYdFo3t1iFXaQ+chVYkP8KnhC1F
Ce3a0GnCn1x7y8yCWipt+QcaI5vuby8x4xVMJbvQCO2kYp89LAgjE6se2ZlXph2C
HW2UuXLgntTJJpphn3pOhzOQe8wP87JGLLYEIZ0AlvHxycWlIT9fk4YWT7LDT+ke
egGT8dMRyIWgu3mjOBqAhmi38tjjaleyT4t0BqUZU5TopNBpkciedyyQsfrKqHeS
T0mP11fnKDqu2ikwHvz93JgDXDbwneooRkHEyHu4+lXK1XQoZhYpDhN5w4+DUsnB
SrUg5+JEoz0jUJ5TgGko7Y6J8wHru2j7Vr4hZyMhxgsCqceBgdykXq0ZjMXwo2oM
vCbzyJz3VY0SDTY49c5iNFCqrJ9FKA17GqTZ2mVAtVCGqKoluw1UAmuzR8EYW4Mj
H9tsxCepS+FKVlhTzCoGhuPUSBBgrY6u30vMuirR4A1Eo3M8/RvXjWERK0r7n2vl
v5pvOP0WoxAQvgQ256xzduuqERU+CgX2rLcEgLRsCSltCJlGdkLlwQWz0iKEaX9i
Iqb+RUkM/qJLenIR28bpF1haDwnfZ2JEouRFD4I8VRy81fKLASpK8YfE6aEaLHfM
VSDPxoHYzQeN7u7WZX5WBPIkFUvoBhI2k2dxHLeQ+TQQbgFdgEk=
=GIx7
-----END PGP SIGNATURE-----

--q7cghsiykh2acose--
