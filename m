From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [PATCH 05/98] exynos_drm.h: use __u64 from linux/types.h
Date: Sat, 30 May 2015 17:46:56 +0100
Message-ID: <20150530164655.GM2067@n2100.arm.linux.org.uk>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-6-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433000370-19509-6-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonyoung Shim <jy0922.shim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Seung-Woo Kim <sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Inki Dae <inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, May 30, 2015 at 05:37:57PM +0200, Mikko Rapeli wrote:
> Fixes userspace compilation error:
>=20
> drm/exynos_drm.h:30:2: error: unknown type name =E2=80=98uint64_t=E2=80=
=99
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>

This is another thing which we need to address.  We should not be using
unsigned int/unsigned long/uintXX_t/etc in here, but the __uXX and __sX=
X
types.

The lesson learned from other DRM developers is that using these types
simplifies the API especially when it comes to the differences between
32-bit and 64-bit machines, and compat applications.

Note that drm/drm.h is all that should need to be included - drm/drm.h
takes care of including linux/types.h when building on Linux platforms.
(note: if your compiler doesn't set __linux__ then you're probably not
using the proper compiler...)

--=20
=46TTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps u=
p
according to speedtest.net.
