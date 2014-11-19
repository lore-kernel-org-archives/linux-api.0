From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHv9 4/5] sparc: Hook up execveat system call.
Date: Thu, 20 Nov 2014 10:42:23 +1100
Message-ID: <20141120104223.2cea8043@canb.auug.org.au>
References: <1416418072-18639-1-git-send-email-drysdale@google.com>
	<1416418072-18639-5-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/RAw1y7OKVANSa1LBZY6zEbt"; protocol="application/pgp-signature"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1416418072-18639-5-git-send-email-drysdale@google.com>
Sender: linux-arch-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

--Sig_/RAw1y7OKVANSa1LBZY6zEbt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, 19 Nov 2014 17:27:51 +0000 David Drysdale <drysdale@google.com> wro=
te:
>
> diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_6=
4.S
> index 580cde9370c9..15069cb35dac 100644
> --- a/arch/sparc/kernel/systbls_64.S
> +++ b/arch/sparc/kernel/systbls_64.S
> @@ -88,6 +88,7 @@ sys_call_table32:
>  	.word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm=
_readv, compat_sys_process_vm_writev
>  /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_s=
etattr, sys_sched_getattr
>  	.word sys32_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sy=
s_bpf
> +/*350*/	.word sys_execveat

Shouldn't this be compat_sys_execveat?

> =20
>  #endif /* CONFIG_COMPAT */

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/RAw1y7OKVANSa1LBZY6zEbt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUbSrkAAoJEMDTa8Ir7ZwVoVoP/AlHLVTxaKtx1n9YHKSFO8T8
/G7WwXkXbsm3fb5qBHJeHtjq+rc9tOA1DM/78qeeDbr9rt4eog0N6scoLXdPeSLK
vZSKe+Z0i8z9hGUph0CXmuQI37XmG+V+HtIQCcdtC6PxijjNWzzCmADN+NToyDKr
pmn/jQKHDTGOQHjhfEDhq6G55M3bKzBna5V7YDAd8+Utd/PmT+5lmKNEtuLT8Y/0
MdnuXZUaX1dsh3SKI8y/l2sCmgc91L10OW0OV+k0Jlj78/lZDmg4mPQZs9h9uZQ2
m9+Gw86XKKunUDKoynl0u9obZGWa2J4XMKX0cBWwvgZkXd+SBwZEyeKpwiHb66OF
b6+YxrJdf5ciu+zMkRTpFPyLfwGxGDHnp8HQBvjZtrtHmFwTdLZpQavFwLQpurNv
9Xh3GCg/wb8wTxlvRuMqSZjCH+Wniea0RnBfdVwfGAwFBA2Yzi+gZMVhi7EvAd0i
yDBm5WnaNcDJ9AyvMiyierIweTVJBjCGhdvVSbFtjoFcGBrql+/4Zw9Ng+u360U3
0PGLDNB7Tc18CKP0u3JDYlL23/mFeJhe2OA9OV9899i62QOF9YnJvkDNz+PwqAXC
PuuU/YDA8L8y8E2QOrP8ry1VnC1bWhDzHTYmfBUWwbRPGZNVFfLyy23uSj+T1GHC
03oLWeCX9F9iyjrlQ8Ko
=41EX
-----END PGP SIGNATURE-----

--Sig_/RAw1y7OKVANSa1LBZY6zEbt--
