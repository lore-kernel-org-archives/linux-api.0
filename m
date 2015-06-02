From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH 05/98] exynos_drm.h: use __u64 from linux/types.h
Date: Tue, 2 Jun 2015 21:59:24 +0300
Message-ID: <20150602185924.GO12550@lakka.kapsi.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-6-git-send-email-mikko.rapeli@iki.fi>
 <20150530164655.GM2067@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150530164655.GM2067@n2100.arm.linux.org.uk>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-samsung-soc@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>, David Airlie <airlied@linux.ie>, Seung-Woo Kim <sw0312.kim@samsung.com>, dri-devel@lists.freedesktop.org, Inki Dae <inki.dae@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, Kukjin Kim <kgene@kernel.org>, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Sat, May 30, 2015 at 05:46:56PM +0100, Russell King - ARM Linux wrote:
> Note that drm/drm.h is all that should need to be included - drm/drm.h
> takes care of including linux/types.h when building on Linux platforms.
> (note: if your compiler doesn't set __linux__ then you're probably not
> using the proper compiler...)

Thanks, I'll fix this by including only drm/drm.h in exynos_drm.h,
nouveau_drm.h, radeon_drm.h and via_drm.h patches.

I'm using standard gcc from Debian for the x86 compilation.

-Mikko
