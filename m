From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [PATCH 05/98] exynos_drm.h: use __u64 from linux/types.h
Date: Mon, 1 Jun 2015 09:56:05 +0100
Message-ID: <20150601085605.GN2067@n2100.arm.linux.org.uk>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-6-git-send-email-mikko.rapeli@iki.fi>
 <20150530164655.GM2067@n2100.arm.linux.org.uk>
 <556C15BA.7000909@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <556C15BA.7000909-5C7GfCeVMHo@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seung-Woo Kim <sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 01, 2015 at 10:20:10AM +0200, Christian K=F6nig wrote:
> Using types that differs on 32-bit and 64-bit machines for a kernel
> interface is indeed a rather bad idea. This not only includes longs, =
but
> pointers as well.

[cut standard stdint.h types argument which we've heard before]

You need to read Linus' rant on this subject:

 From: Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>
 Subject: Re: [RFC] Splitting kernel headers and deprecating __KERNEL__
 Date: Mon, 29 Nov 2004 01:30:46 GMT

 Ok, this discussion has gone on for too long anyway, but let's make it
 easier for everybody. The kernel uses u8/u16/u32 because:

         - the kernel should not depend on, or pollute user-space namin=
g.
           YOU MUST NOT USE "uint32_t" when that may not be defined, an=
d
           user-space rules for when it is defined are arcane and total=
ly
           arbitrary.

         - since the kernel cannot use those types for anything that is
           visible to user space anyway, there has to be alternate name=
s.
           The tradition is to prepend two underscores, so the kernel w=
ould
           have to use "__uint32_t" etc for its header files.

         - at that point, there's no longer any valid argument that it'=
s a
           "standard type" (it ain't), and I personally find it a lot m=
ore
           readable to just use the types that the kernel has always us=
ed:
           __u8/__u16/__u32. For stuff that is only used for the kernel=
,
           the shorter "u8/u16/u32" versions may be used.

 In short: having the kernel use the same names as user space is ACTIVE=
LY
 BAD, exactly because those names have standards-defined visibility, wh=
ich
 means that the kernel _cannot_ use them in all places anyway. So don't
 even _try_.

--=20
=46TTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps u=
p
according to speedtest.net.
