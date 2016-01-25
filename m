From: Lucas Stach <l.stach-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Subject: Re: [PATCH 0/5] Etnaviv updates
Date: Mon, 25 Jan 2016 12:04:28 +0100
Message-ID: <1453719868.4368.9.camel@pengutronix.de>
References: <20160124173516.GH10826@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160124173516.GH10826-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: Christian Gmeiner <christian.gmeiner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Sonntag, den 24.01.2016, 17:35 +0000 schrieb Russell King - ARM
Linux:
> Here's some updates to etnaviv, which augment the features and GPU
> specifications which we export to userspace.  This will allow us to
> fix the (currently incorrect) number of varyings that GPUs such as
> GC880 and GC2000 supposedly have.
> 
> While making this change, I'm also increasing the number of feature
> words we export up to the largest number known from the current
> Vivante galcore code.
> 
>  drivers/gpu/drm/etnaviv/common.xml.h   |  59 ++++++++++--
>  drivers/gpu/drm/etnaviv/etnaviv_gpu.c  | 161 ++++++++++++++++++++++-----------
>  drivers/gpu/drm/etnaviv/etnaviv_gpu.h  |   9 ++
>  drivers/gpu/drm/etnaviv/state_hi.xml.h |  26 +++++-
>  include/uapi/drm/etnaviv_drm.h         |   3 +
>  5 files changed, 196 insertions(+), 62 deletions(-)
> 
I've applied this series with the prefix changed to drm/etnaviv.

Thanks,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |
