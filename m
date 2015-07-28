From: Eric B Munson <emunson@akamai.com>
Subject: Re: [PATCH RFC 1/1] Documentation: describe how to add a system call
Date: Tue, 28 Jul 2015 10:14:47 -0400
Message-ID: <20150728141447.GC2407@akamai.com>
References: <1438083663-24814-1-git-send-email-drysdale@google.com>
 <1438083663-24814-2-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438083663-24814-2-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Miklos Szeredi <mszeredi@suse.cz>, Milosz Tanski <milos>
List-Id: linux-api@vger.kernel.org


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Jul 2015, David Drysdale wrote:

> Add a document describing the process of adding a new system call,
> including the need for a flags argument for future compatibility, and
> covering 32-bit/64-bit concerns (albeit in an x86-centric way).
>=20
> Signed-off-by: David Drysdale <drysdale@google.com>
> Reviewed-by: Michael Kerrisk <mtk.manpages@gmail.com>

This is really helpful

Reviewed-by: Eric B Munson <emunson@akamai.com>

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVt45XAAoJELbVsDOpoOa97sEQAM87QLX1AGYi7Yq0GcIRY+D8
Iwd/C96KXwGSHZ0pT4hA1j78Q7AnSkdekWKRAz6hpsUHZs+SpXtVpaswfmIlvsqY
B28UFp/zkJqZuvX8fTAqC60MAMEyu96c8mYQonjA+IXyP7lwCPMz4yNJLbXKA+U8
MDQghNnzfJeR2IQvx8PJmaRI3DtxZ88mmZcPlQGVkXkCOydGjGIbKzAcn1CwC5UL
rxdMS8Wz+hDXj/udF5qYVKEiSkKfH48K7irAoBoYjdnA/I59burdgUCXtzetiC66
ROVXW5PdVKg7bYK4T0R19xalA5leFmLDf1PkfhbAscYvUCAaEiP2WPUsTgkhlxWo
Mk/VO9sPF/uniCZQrrC7Dah+pU6eQusu9/c2gj57M0H6lKE3NQsfNw0pN+jL65Rk
+yVQApnlqGppbwRo6vK7w60cg+FLjVTNQz5zvaQKb+ysff0LbyX1nF+6Prhu/KLX
gpwR8seMbXkfXvGI1hjBViV25S0DJBEpz+8X4Jdp1A9tKAzwyUd/VB+4s4HD091o
Ivrx6UgkIeL8P5KOttLRlMeG07PvwC3PElq6BWL4LcX35p3x/GSkX3MoOBrSCKsd
DNIh8tXXK1DJHSWue6cUSI6+xu+iGpGb2PoOVsCj4UHyMP98YDaeQoSP2YKoHB02
Syw9Cms/1NtCqOiv/3N8
=q5Cf
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
