From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: [PATCH v7 00/16] libnvdimm: non-volatile memory devices
Date: Sat, 20 Jun 2015 22:40:26 +1000
Message-ID: <20150620224026.582616fe@canb.auug.org.au>
References: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/cF97qF+0vI8J8kmt_K4.TyC"; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150617215027.11597.61414.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Nicholas Moulin <nicholas.w.moulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--Sig_/cF97qF+0vI8J8kmt_K4.TyC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Wed, 17 Jun 2015 19:13:19 -0400 Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> =
wrote:
>
> A new sub-system in support of non-volatile memory storage devices.
>=20
> Stephen, please add libnvdimm-for-next to -next:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm libnvdimm-for=
-next

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Sig_/cF97qF+0vI8J8kmt_K4.TyC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVhV9AAAoJEMDTa8Ir7ZwVjPUP/1cZUb9/UBIZ5ybxzgc2yro6
5btwHuMB68JTMUUXHP5R/Ovla0RQHwaoHR3eJxF1X1kM+UKjFdX86in5HFGC7W5b
pfXTc37hucTpbtYZguIKyEu78i02tL9z2tfiuSQ0kJCnTqQ5Ae/uHwaZrK6LTpy9
x2AfF0XVcOi2oVdg+uc7WWiAMBylOsjrBMPBKZklfyaRPZ7Qo+volJDVTFIIXRnZ
HCZoRSkxiE0fMHBqRqL/7OPlYqrFBvhIpFk0t+TKwsANaPKNlKVuvh27TD/mkXiI
KIKatykIQsbr/iWBm/F81gcOjqPJFioGP0dm2TlVsMHKdbFv+Fi+WSHeufiBqBwY
IZGiuY5kr4UQeeXQJN4sUgPmrYZr8508lr3CZwUWIRr3xB+rQGdbV2Y3+nvHMpAi
q7unS8u/C4nxx+7lzlJWGHcURuejgVO/Lg1xZSZpb26kyIybKE68HBXfridnAej/
DViONYHU/DcwptB9ucObXvp3nWQkJ0NpV+9CwVQWlrkoerE4nM6mK1FN9YZm2sHn
je3ozE8Scsngw6KGqEFLxJUK+XogrGkMXAF/fxMKzYkr9CTr27hHcQyUpDx7/zlU
xMlhmXT9IqqYu3tYls8t488N+qaTy3pkJgOKVXtpWcxgkWnSz3253Du/yqA2amKH
4KLXIoSANioA6efVD5Vw
=1qeW
-----END PGP SIGNATURE-----

--Sig_/cF97qF+0vI8J8kmt_K4.TyC--
