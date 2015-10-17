From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] glibc: Remove CPU set size checking from affinity
 functions [BZ #19143]
Date: Fri, 16 Oct 2015 23:10:03 -0400
Message-ID: <20151017031003.GE28215@vapier.lan>
References: <5621126E.5080801@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5xSkJheCpeK0RUEJ"
Return-path: <libc-alpha-return-64212-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <5621126E.5080801@redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: GNU C Library <libc-alpha@sourceware.org>, cgroups@vger.kernel.org, kosaki.motohiro@gmail.com, Linux API <linux-api@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
List-Id: linux-api@vger.kernel.org


--5xSkJheCpeK0RUEJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On 16 Oct 2015 17:06, Florian Weimer wrote:
> The current situation, briefly stated, is this: glibc tries to guess the
> kernel CPU set size and rejects attempts to specify an affinity mask
> which is larger than that, but it does not work, and glibc and the
> kernel still silently accept CPU affinity masks with invalid bits,
> without returning an error.  The glibc check does not provide any value
> to applications, it just adds pointless complexity to the library.
> Therefore, I want to remove it from glibc.

checking the validty of the cpuset mask at the time of setting attributes
seems fundamentally wrong to me.  can't the cpuset change too between the
check and the actual use ?  say you have a controller that also manages
the cpus, and it has pre-initialized the attributes, and then brings up
the cpu on demand before spawning the thread.  it wouldn't be possible to
also pre-create all the attributes.

patch makes sense to me

> +	  abort ();

why does the test call abort instead of exit ?  abort writes to stderr.
-mike

--5xSkJheCpeK0RUEJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWIbwLAAoJEEFjO5/oN/WBuwkP/1R1mnqWa9vREbsllwz1sdUL
K7RdVlMYD9RlxpggxLzrC2XiAX6AmTNDw0CbReiEKBm9mw2X3xuXaBikVKvmyN17
1lt9xVvHApKXeZOORjQUobPb2efWIX8vyESjyVj+O/hI+1Ctw1FqtdAaT/NkIwJw
JBwifbQawS1Uk8l/ym+mYkLZd7zXDWINDezsutP26h9T4klvLfhcCC4Hs0w6WfZZ
U9P3TW7XWnbO7lJyqDk39KzPuG0of1yBX7HIY2Je1JrUMB0VD/1OJchXH69x0khQ
nuiGoaB79OnOBz+wqH03/48PXXi7C0ANZ9apdyjFylgXeUCLBvda1wdrF60d24aW
+TMlIlgGG2IVkevY+JxfL5VH/G6ssMbhDMbGJVsMI7qJuY2wOj1LhIsbfiNFUNHF
G+dwLPUzrTjrmuNNxe0A0WSOvaICMqNfM7qTuUeIBX7HolgQ6KMfq5yaSqxXHTAT
ttuRhtIOYwODRi4QvGuBJAp8zfyB2xOyI39DboDqQJQmmVtxwnv/Kxta1WaiB9R2
4RLU3m3M8zzZuzGtc+a7yv6Ad7FvF7RwSRy2a+CWbkScsfDudQf7q6iJz7LxSoRT
U57/kcKhNYYZ5mZpRk9UCtoWC6L+iD3sVxIiIWqx8pUtPWFpno9NdpgQwFrJNvMu
FH5+qr4MtJJwll4lkAUx
=l60K
-----END PGP SIGNATURE-----

--5xSkJheCpeK0RUEJ--
