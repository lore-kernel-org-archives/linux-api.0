From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [kernel-hardening] [RFC PATCH 1/1] seccomp: provide information
 about the previous syscall
Date: Fri, 22 Jan 2016 11:48:37 +0100
Message-ID: <20160122104837.GA14440@pc.thejh.net>
References: <1453444200-8604-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
 <1453444200-8604-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453444200-8604-2-git-send-email-daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Cc: keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 22, 2016 at 03:30:00PM +0900, Daniel Sangorrin wrote:
> This patch allows applications to restrict the order in which
> its system calls may be requested. In order to do that, we
> provide seccomp-BPF scripts with information about the
> previous system call requested.
>
> An example use case consists of detecting (and stopping) return
> oriented attacks that disturb the normal execution flow of
> a user program.


The intent here is to mitigate attacks in which an attacker has
e.g. a function pointer overwrite without a high degree of stack
control or the ability to perform a stack pivot, correct? So that
e.g. a one-gadget system() call won't succeed?

Do you have data on how effective this protection is using just
the previous system call number?

I think that for example, the "magic ROP gadget" in glibc that
can be used given just a single pointer overwrite and stdin
control (https://gist.github.com/zachriggle/ca24daf4e8be953a3f96),
which (as far as I can tell) is in the middle of the system()
implementation, could be used as long as a transition to one of
the following syscalls is allowed:

 - rt_sigaction
 - rt_sigprocmask
 - clone
 - execve

I'm not sure how many interesting syscalls typically transition
to that, perhaps you can comment on that?

However, when exploiting network servers, this magic gadget
won't help much - an attacker would probably have to either
call into an interesting function in the application or use
ROP. In the latter case, this protection won't help much -
especially considering that most syscalls just return
-EFAULT / -EINVAL when you supply nonsense arguments, ROPping
through a "pop rax;ret" gadget and a "syscall;ret" gadget
should make it fairly easy to bypass the protection. There
are a bunch of occurences of both gadgets in Debian's libc
(and these are just the trivial ones):

$ hexdump -C /lib/x86_64-linux-gnu/libc-2.19.so | grep '58 c3'
000382e0  00 00 48 8b 00 5b 8b 40  58 c3 48 8d 05 4f 8a 36  |..H..[.@X.H..O=
=2E6|
000383b0  58 c3 48 8d 05 87 89 36  00 48 39 c3 74 0e 48 89  |X.H....6.H9.t.=
H.|
00038450  40 58 c3 48 8d 05 e6 88  36 00 48 39 c3 74 0e 48  |@X.H....6.H9.t=
=2EH|
000d9a00  48 89 44 24 18 e8 56 ff  ff ff 48 83 c4 58 c3 90  |H.D$..V...H..X=
=2E.|
000e51d0  c3 0f 1f 80 00 00 00 00  48 8b 40 58 c3 0f 1f 00  |........H.@X..=
=2E.|
000ea2f0  48 83 3d 58 c3 2b 00 00  48 8b 1d 69 8b 2b 00 64  |H.=3DX.+..H..i=
=2E+.d|
00160520  48 c3 fa ff 58 c3 fa ff  68 c3 fa ff 80 c3 fa ff  |H...X...h.....=
=2E.|
00171470  58 c3 f8 ff 84 60 02 00  74 c3 f8 ff 94 62 02 00  |X....`..t....b=
=2E.|
$ hexdump -C /lib/x86_64-linux-gnu/libc-2.19.so | grep '0f 05 c3'
000b85b0  b8 6e 00 00 00 0f 05 c3  0f 1f 84 00 00 00 00 00  |.n............=
=2E.|
000b85c0  b8 66 00 00 00 0f 05 c3  0f 1f 84 00 00 00 00 00  |.f............=
=2E.|
000b85d0  b8 6b 00 00 00 0f 05 c3  0f 1f 84 00 00 00 00 00  |.k............=
=2E.|
000b85e0  b8 68 00 00 00 0f 05 c3  0f 1f 84 00 00 00 00 00  |.h............=
=2E.|
000b85f0  b8 6c 00 00 00 0f 05 c3  0f 1f 84 00 00 00 00 00  |.l............=
=2E.|
000b87f0  b8 6f 00 00 00 0f 05 c3  0f 1f 84 00 00 00 00 00  |.o............=
=2E.|
000d9260  b8 5f 00 00 00 0f 05 c3  0f 1f 84 00 00 00 00 00  |._............=
=2E.|
000e6400  b8 e4 00 00 00 0f 05 c3  0f 1f 84 00 00 00 00 00  |..............=
=2E.|
000fff60  48 63 3f b8 03 00 00 00  0f 05 c3 0f 1f 44 00 00  |Hc?..........D=
=2E.|

So an attacker would craft the stack like this:
[pop rax;ret address]
[first syscall for transition]
[syscall;ret address]
[pop rax;ret address]
[second syscall for transition]
[syscall;ret address]
[...]
[normal ROP for whatever the attacker wants to do]


Maybe someone who knows a bit more about binary exploiting
can comment on this, especially how likely it is that a
manipulation of a network service's program flow is successful
in the presence of full ASLR and so on without ROP.


Also, there is a potential functional issue: What about signal handlers?
Signal handlers will require transitions from all syscalls to any syscall
that occurs at the start of a signal handler to be allowed as far as I
can tell.


> @@ -443,6 +448,11 @@ static long seccomp_attach_filter(unsigned int flags,
>  			return ret;
>  	}
> =20
> +	/* Initialize the prev_nr field only once */
> +	if (current->seccomp.filter =3D=3D NULL)
> +		current->seccomp.prev_nr =3D
> +			syscall_get_nr(current, task_pt_regs(current));
> +
>  	/*
>  	 * If there is an existing filter, make it the prev and don't drop its
>  	 * task reference.

What about SECCOMP_FILTER_FLAG_TSYNC? When a thread is transitioned from
SECCOMP_MODE_DISABLED to SECCOMP_MODE_FILTER by another thread, its initial
prev_nr will be 0, which would e.g. appear to be the read() syscall on
x86_64, right?

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWogkFAAoJED4KNFJOeCOoTusQAMKEzmzPSBpuLpJH9r5WhtYy
zdXAF5HuEkgkcKfJR9gVVqiddVuvxneWYR3UT7C/KTNEaP0XJ7H+r+TRX3JB0AD0
pxq0IwyXKhZap6GvxwOImnm9+RKih1vRi/wLJAPIrcs7ALyCQE5H7/iQMD0UxE0Y
LyRfaM2QaEADyZFrjz4u6Ey5iirszCfBklfgOX8tTk/FECVy6ua0zoG3Nj/vHM6A
N4eMek+jPKtPEWsMoV3cnLHYV2xJhtqmRh2MjTImCgG2RsLFLzDdTvkETJGsyY4X
dkvzKE7fglf9gA2yrZCv09zzWyCZUPF01QMYNdCPg2toR0aIWJm1OO7gjXFnYwfx
h2bXEqfMajkbkmzzBsPHcLPKfXncHvB3tmAkS0qm8ZukyxkawABcnU7ZLHfr3e9k
trP8RdIDI7YlJ5utbruH+Qbm4ybNUaf4DxKJTUhx4Tgqc3ApGEw1PhNYT471qhEs
0wra7L8FAt7quo1kyKC1c5I10Czj1Xb0BlhC1/Ab8SRtFjHoteFhkPkd4ypCyDMD
7Lrm00Xo1r5A/RHAAsakN+cEOGx0iogy8MavIfENqnI7TVnkfcpjgt1XRrr4bN0q
yr0DSce/+9+5gHoikAz5a2+IcDVvGGQQbgv0W7GxxZDFP0UQd/IageW0q8Xuitda
rSngd5ooXwtrgLUzdKTM
=yeGf
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
