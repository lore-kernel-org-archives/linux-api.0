From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Sat, 10 May 2014 09:07:42 +0200
Message-ID: <20140510070742.GE6099@debjann.fritz.box>
References: <20140509191914.GA7286@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G6nVm6DDWH/FONJq"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140509191914.GA7286@jtriplet-mobl1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 09, 2014 at 12:19:16PM -0700, Josh Triplett wrote:
> +	if (port > 65535)
> +		return 0;
> +	switch (count) {
[...]
> +	case 4:
> +		if (__put_user(inl(port), buf) < 0)
> +			return -EFAULT;

What if I attempt a four-byte read at 65535? That would access four
out-of-bounds bytes, right?

--G6nVm6DDWH/FONJq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbdA9AAoJED4KNFJOeCOoN+UQAN9GORdj+rzdWu9g22fZxEjE
mqSGf0NUqLa6pXBlhFZqxsAa4iJ+RtXA2Ms8Q0iXsBQ401G825I6lbIGILjs9nsQ
5Nxwuw6fh37OJi+GXdFErQ8ZxjKuYEsd7k9493az24yiLs9ImhjKJyDaUbrdB83Z
HxqedmS7GTgeNrtkI962hin/P4PRVKdFnqGpRiNunsyNWJdlZCZuqbIy1UTJgjyj
e/7jhg5I7Qib1+Pmo8/vYpv/Dvct5xophThEh5vtjfi6gHJjLv6GgLo7ZjC37Izl
4nw4dJrrruxTYt4YwLT0/BbrPLUCLkvNPMqoY2QOi37VE2Fr79a8d/IvxBxI1e/e
3/CQDF4mF6LsRHm7Oovw8sfAFbSV2YEHc4HK8NOU06nSB7mity9tQiFs8U3RjuZJ
G8EJGPeBCYF6i13JLEquYGZVl4kNZoD5lY5zvLWR61rI1+Cv/a6WlIJsnipsxF3D
ZGcQfupU8Cfl7OTqxogBGruUA18OCpL8HVcHx0F2hOj9SIdWshfTzflLQjHNNrTo
cEgBnDD2yRKJFLMV8Ayog2KA9HJeEwbEiA0wL3NPoYYWBgeCe/y/NESBdEtIbRVu
IQlAF1ws4EaPLj6FQne1X4OhPwKooClfGg4VezAvnEkC1S++SZkA7tAsnreU90cE
hpGNKqYLq8+2CSOPjpqd
=w033
-----END PGP SIGNATURE-----

--G6nVm6DDWH/FONJq--
