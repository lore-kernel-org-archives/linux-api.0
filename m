From: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] reintroduce accept4
Date: Mon, 27 Oct 2008 21:22:59 -0700
Message-ID: <490693A3.9070805@redhat.com>
References: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com> <20081027204135.a139704e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081027204135.a139704e.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> I'll confess to not having a clue what's going on here.

It has been discussed at length.  accept created file descriptors and w=
e
need flags for tis.

>> #elif __i386__
>> #define SYS_ACCEPT4     18
>> #define USE_SOCKETCALL 1
>> #define SOCK_CLOEXEC O_CLOEXEC
>> #else
>=20
> Well.  This doesn't actually agree with the kernel patch.

What doesn't agree?


> I'd suggest that i386 is sufficiently common to warrant its inclusion
> in the initial patch.

The x86 code is included.  x86 uses socketcall instead of a syscall.

I changed all paccept occurrences in the tree, not just x86-64.

- --
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro S=
t =E2=9E=A7 Mountain View, CA =E2=9D=96
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkkGk6MACgkQ2ijCOnn/RHSwSgCfeb/PGDCm2qy0ZESqWb8wgyhX
cHoAoIIXvhBjdxcj2gy09eQBzNKOTwCU
=3DQSFh
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
