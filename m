From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [PATCH 05/98] exynos_drm.h: use __u64 from linux/types.h
Date: Mon, 1 Jun 2015 10:38:09 +0100
Message-ID: <20150601093808.GP2067@n2100.arm.linux.org.uk>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-6-git-send-email-mikko.rapeli@iki.fi>
 <20150530164655.GM2067@n2100.arm.linux.org.uk>
 <556C15BA.7000909@amd.com>
 <20150601085605.GN2067@n2100.arm.linux.org.uk>
 <556C2105.2090607@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <556C2105.2090607-5C7GfCeVMHo@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seung-Woo Kim <sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 01, 2015 at 11:08:21AM +0200, Christian K=F6nig wrote:
> Yeah, completely agree with Linus on the visibility problem and that'=
s
> exactly the reason why we don't include <stdint.h> in the kernel head=
er and
> expect userspace to define the ISO types somewhere.
>=20
> But using the types from "include/linux/types.h" and especially inclu=
ding it
> into the uapi headers doesn't make the situation better, but rather w=
orse.
>=20
> With this step we not only make the headers depend on another header =
that
> isn't part of the uapi, but also pollute the user space namespace wit=
h __sXX
> and __uXX types which aren't defined anywhere else.

1) Header files are permitted to pollute userspace with __-defined stuf=
f.

2) __[su]XX types are defined as part of the kernel's uapi.
   include/uapi/linux/types.h includes asm/types.h, which in userspace
   picks up include/uapi/asm-generic/types.h.  That picks up
   asm-generic/int-ll64.h, which defines these types.

Moreover, this is done throughout the kernel headers _already_ (as you
would expect for a policy set 10+ years ago).

Please, I'm not interested in this discussion, so please don't argue
with me - I may agree with your position, but what you think and what
I think are really not relevant here.  If you have a problem, take it
up with Linus - I made that clear in my email.

--=20
=46TTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps u=
p
according to speedtest.net.
