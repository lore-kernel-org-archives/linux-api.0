From: Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org
Subject: Re: [PATCH 1/2] Define ENOAUTHSERVICE to indicate "Authentication service unavailable"
Date: Wed, 08 Feb 2012 18:53:50 -0500
Message-ID: <22934.1328745230@turing-police.cc.vt.edu>
References: <20120208122905.8902.65762.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1328745230_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Your message of "Wed, 08 Feb 2012 12:29:05 GMT."
             <20120208122905.8902.65762.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

--==_Exmh_1328745230_2846P
Content-Type: text/plain; charset=us-ascii

On Wed, 08 Feb 2012 12:29:05 GMT, David Howells said:

> +#define	ENOAUTHSERVICE	139	/* Authentication service not available */
>
>  #define EHWPOISON	139	/* Memory page has hardware error */

Was this an intentional overload of 139 (and so on for other archs)?
Just checking - I'm sure if it goes in like this, we'll see a patch to "fix" the
collision for 3.16.0 or so... ;)

--==_Exmh_1328745230_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBTzMLDgdmEQWDXROgAQLo8w/9GSAkuhd+TKRP7GBY/vtnzb8/kyvEnJ5M
kXAsV/k12ZKsyRo+qat0scVkIIVR+siFVQMBMAOE4r4Y14CGYMInhrpsNLa0vhqK
GdS5+GNIAbHj8PBJSYxxHffiQisePTTbAppzW68to/jRe3eYcWQdlJgcjdOMYSKJ
TxLJi7R36FNZAMW5C6VjrEZcWym+LOizeSuX0a4hGMkWbo1D6YO/bsqI0703fhh3
+q3n6KLZahVNZQ4zNDtIuznUgm/SEWnz5kyZF+Lj0pCxCC/00Qtl0d47YGQ8Bfcr
6v+v2loI96oHJypLbPOoovwqpPV5YUoiaLS+aKFyEcMb+Soa8kSpPSkb+lkQZ/eK
FTkdLuRFQ4cK9Dk1mqFa94x7XsVv6FfXt4NUKuWSm2cqEzUbdEbmXsdwT69oMcYV
aYd//3xYcjtcwDi+lovc7THYIj2UJYtZVxIeZpitxISMdAJ+gZEYzmgDKF+O4IDj
DYdnO8PVMfdosULrhP5GpYtjYJ0vL/HSNXSkGtJ/OWIlBIBFl2yXtOpzkjqndtBE
WBmmfQHvSNjYU5Ab/udNYNoT4+rEKkkBLTtbWwFvgNPiiE5PLYLrUrdyqz4Y6KAb
B9OkVk4AWq0UlCeNCl2onHKdsT61rfImD8wygJyJ2oau7TWw4itQE2LV/pLQY68T
HrD/BwmIDcY=
=h9rq
-----END PGP SIGNATURE-----

--==_Exmh_1328745230_2846P--
