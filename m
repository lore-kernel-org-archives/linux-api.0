From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [GIT PULL] arch: add pidfd and io_uring syscalls everywhere
Date: Wed, 24 Apr 2019 03:41:31 +0300
Message-ID: <20190424004131.GA19764@altlinux.org>
References: <CAK8P3a3bT=HO=YQ7PY7wOEsJTzf0jS4PkqNHSqYX4JjwmbhY+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a3bT=HO=YQ7PY7wOEsJTzf0jS4PkqNHSqYX4JjwmbhY+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 23, 2019 at 09:28:48PM +0200, Arnd Bergmann wrote:
> The following changes since commit 9e98c678c2d6ae3a17cb2de55d17f69dddaa23=
1b:
>=20
>   Linux 5.1-rc1 (2019-03-17 14:22:26 -0700)
>=20
> are available in the Git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
> syscalls-5.1
>=20
> for you to fetch changes up to 39036cd2727395c3369b1051005da74059a85317:
>=20
>   arch: add pidfd and io_uring syscalls everywhere (2019-04-15 16:31:17 +=
0200)
>=20
> ----------------------------------------------------------------
> arch: add pidfd and io_uring syscalls everywhere
>=20
> This comes a bit late, but should be in 5.1 anyway: we want the newly
> added system calls to be synchronized across all architectures in
> the release.
>=20
> I hope that in the future, any newly added system calls can be added
> to all architectures at the same time, and tested there while they
> are in linux-next, avoiding dependencies between the architecture
> maintainer trees and the tree that contains the new system call.

Is "everywhere" really means everywhere?
The reason I'm asking this question is that sh64 seems to be excluded:
arch/sh/kernel/syscalls_64.S hasn't got any syscall entries since commit
v4.8-rc1~15^2~3.  Is sh64 supported in any way at all?


--=20
ldv

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJcv7C6AAoJEAVFT+BVnCUI0JEQAJ2bzaxtiKTDlR49Nlq0dQhS
fmtO5WLf3d6e11pAG0gyau7tYaLfjVLa1oaLpaH1aRVUrDbX6SyZSkLyaguzeayE
iFvMz5QeDU8QLjMQZd/Gy6Nr5BwGKxUndKcMY2vEvGRXGUlg17rr/DXcmXm5+PIb
hUvzEljiuldojTTTNju1NsTl5Rt6eW+GYG5Sfm/qjGaYaG1qFQUvh5wDx5Ct9qMr
GkKZM+GDnj8fkreM9tQwBpVGKequhdfdMRyCQSAcuGsLxTvClYefRHUd1Wos8xYG
za5Vqz4t2T1JpQTl5bBsnH4bxjjrYRXPO1/WIAIutYRcHZ7SNPTRi/Pxlxzi4XFI
E6N2LuhUFZJmzH3EIguadWlLwalirS4zEY8Q0rnvq4UfnfHG75XuHtTUSpNus/Ar
+hlSaotcRHBmA2wAJjl72KmJSe7xouj2M6ZSBSWmMpE8FefqESXpKCR7vAe8sLOz
RYWsV043x53EWH8rEfALDIqV1IslvWU+DkxeclgCCPMnaril8g72KBRIhW9IzZkf
NkErJHy0ReEQ30ctg7l/Jy2H3ClevOFmsVQ6kiVmaabl4PPfwiAHmmi9BO3SdzIF
P8NJRM/wPvxYV0KlgClGMF4j70hW+fEytmbDZs75THMcr3/VjYSHxgsMdQMS2lE9
SxN5dBBxvaB4KarTpGVS
=sopX
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
