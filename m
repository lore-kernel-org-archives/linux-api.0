From: Eric B Munson <emunson@akamai.com>
Subject: Re: [PATCH 1/2] mmap.2: clarify MAP_LOCKED semantic
Date: Wed, 13 May 2015 10:45:06 -0400
Message-ID: <20150513144506.GD1227@akamai.com>
References: <1431527892-2996-1-git-send-email-miso@dhcp22.suse.cz>
 <1431527892-2996-2-git-send-email-miso@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz+pwK2yUstbofK6"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1431527892-2996-2-git-send-email-miso@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <miso@dhcp22.suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>
List-Id: linux-api@vger.kernel.org


--rz+pwK2yUstbofK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 13 May 2015, Michal Hocko wrote:

> From: Michal Hocko <mhocko@suse.cz>
>=20
> MAP_LOCKED had a subtly different semantic from mmap(2)+mlock(2) since
> it has been introduced.
> mlock(2) fails if the memory range cannot get populated to guarantee
> that no future major faults will happen on the range. mmap(MAP_LOCKED) on
> the other hand silently succeeds even if the range was populated only
> partially.
>=20
> Fixing this subtle difference in the kernel is rather awkward because
> the memory population happens after mm locks have been dropped and so
> the cleanup before returning failure (munlock) could operate on something
> else than the originally mapped area.
>=20
> E.g. speculative userspace page fault handler catching SEGV and doing
> mmap(fault_addr, MAP_FIXED|MAP_LOCKED) might discard portion of a racing
> mmap and lead to lost data. Although it is not clear whether such a
> usage would be valid, mmap page doesn't explicitly describe requirements
> for threaded applications so we cannot exclude this possibility.
>=20
> This patch makes the semantic of MAP_LOCKED explicit and suggest using
> mmap + mlock as the only way to guarantee no later major page faults.
>=20
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Does the problem still happend when MAP_POPULATE | MAP_LOCKED is used
(AFAICT MAP_POPULATE will cause the mmap to fail if all the pages cannot
be made present).

Either way this is a good catch.

Acked-by: Eric B Munson <emunson@akamai.com>


--rz+pwK2yUstbofK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVU2NyAAoJELbVsDOpoOa9qrcQAL7qkobw8zBNPCW62SwMI8Gt
HnilnO3Y42MDYOVSNzcPvmwDbETpqrS5mzK4cEpM5KQFLIz6XMvmZr2D/16BIOED
3ieX+d2Eg7kw5O87/rq2MVrmLYfAXoDnni25d6SQEQBQihuAGEk7M45KBRaa8zcb
aKElv4ov8xjMMcRwRzTdpdzaWogFjNz5TuRsm4Zu9Xj/MrPhmhzaCwoBpOqxGKp5
kt9utHzVh4h6MDC0ZCZ4dfw9UCAMfA4wtEncS4JcEQ+a/LPN1n/ZG7LqqqwIL50x
1miEgtCxIOVlaLXUUCHeCa0tfvSBPFznDfjpnnnGeowFKdG9HfoakbgrzeGTWFX+
+6MLsCzba/ODKwK4sALB0U9KUCLg+qjBFuTAX16mpaRJLjiaPvK1MHOWoD70yC+z
fKAKjFlXRmebAM9nmpx0Q0uKUzUT8wK7WN0IFB9sJrqM7HoR+nzAweGtbXQrNKwm
O5jA/jPChP7zshrllyfgp56rRiYF3ztsT1kGDA7147c8S17NIzW4oFGYCUG7s8ua
XPsjaMQHgrPn33LVMq9dfX01kLMft1GKVYLil6xoGW+AfqBrNwbOLvVQfy0WrxM2
XKNwGCa5G/V4RYVzQEKdzfvwKYslxbpr3iqmjR0PQNhjdZWFAgIHonrboQmc59PC
fkrgPry07zHAVqVQVIDX
=+Q1g
-----END PGP SIGNATURE-----

--rz+pwK2yUstbofK6--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
