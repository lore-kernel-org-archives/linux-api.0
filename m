From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: d_off field in struct dirent and 32-on-64 emulation
Date: Fri, 28 Dec 2018 05:23:39 +0300
Message-ID: <20181228022338.GA27992@altlinux.org>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Return-path: <libc-alpha-return-98833-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <87bm56vqg4.fsf@mid.deneb.enyo.de>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, libc-alpha@sourceware.org, qemu-devel@nongnu.org, ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net, hpa@zytor.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 27, 2018 at 06:18:19PM +0100, Florian Weimer wrote:
> We have a bit of an interesting problem with respect to the d_off
> field in struct dirent.
>=20
> When running a 64-bit kernel on certain file systems, notably ext4,
> this field uses the full 63 bits even for small directories (strace -v
> output, wrapped here for readability):
>=20
> getdents(3, [
>   {d_ino=3D1494304, d_off=3D3901177228673045825, d_reclen=3D40, d_name=3D=
"authorized_keys", d_type=3DDT_REG},
>   {d_ino=3D1494277, d_off=3D7491915799041650922, d_reclen=3D24, d_name=3D=
".", d_type=3DDT_DIR},
>   {d_ino=3D1314655, d_off=3D9223372036854775807, d_reclen=3D24, d_name=3D=
"..", d_type=3DDT_DIR}
> ], 32768) =3D 88
>=20
> When running in 32-bit compat mode, this value is somehow truncated to
> 31 bits, for both the getdents and the getdents64 (!) system call (at
> least on i386).

Why getdents64 system call is affected by this truncation,
isn't it a kernel bug that has to be fixed in the kernel instead?


--=20
ldv

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJcJYkqAAoJEAVFT+BVnCUIcosQANvtFPNcdpTeqDv4BvJh1mmD
tLkXHBOml79JQ42kYPcOV3iwQ4WJNkOdL9TzjrIGfEiwUVC8Kd6zJDt4SIeUGTlk
JvKVizkgH7vtPL3dFwfBb4GSiBdRTK3+NP0MwbHjbIgHI0o9kmghqyElbMWdvhlO
qUHuNcoAMI05qd0ZFJ31jHylo747iIQXmVha5CaK/4ntDYcx2/v+HFLzzgW7Ymm6
B14TgVRFDQGZtRjrAfp0cFFPiluXSfWwmLYUOnnqgGqxscj3uxkUIVdb4PSLEt3C
BEfkBq9I9et6UVUh1Yunu9pYArOoZzYgJZOeoLm3QTijMKWeDJ5mqF33swjHGNQD
71ef9YTrWaZ0HnYgbiGTQCMskOSTgSMc7iugHNMdlba56QK/urmwiCP1Bc/4uiMO
QrUziTdJc+pH7ZB4IG3n+3JK1LcSnlhv+i68BfvgJ5ZtN1v4xuLupe1K8JhLn0hT
rDUJWdH+VQKSUZe4tKy1ElsvKF4yGrmwaILHE6fGwtY33XGUSKxGsidyWHZSVOms
nk4P5w2hWrlQ0oCwqJ3d9uErV5Ih0UkxmRK9sNHmQXKw3cC3RjOSc33x8k6XAeAQ
DIw4pRx94ePNbkavwVgr67DxGo3CmTcdlbfvFMf7J58DodxLZRBJENqeZAF4GTtN
A091yYWKMqB/+28jrJD5
=C0vz
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
