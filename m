From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: [PATCH 0/5] Etnaviv updates
Date: Sun, 24 Jan 2016 17:35:17 +0000
Message-ID: <20160124173516.GH10826@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lucas Stach <l.stach-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Cc: Christian Gmeiner <christian.gmeiner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Here's some updates to etnaviv, which augment the features and GPU
specifications which we export to userspace.  This will allow us to
fix the (currently incorrect) number of varyings that GPUs such as
GC880 and GC2000 supposedly have.

While making this change, I'm also increasing the number of feature
words we export up to the largest number known from the current
Vivante galcore code.

 drivers/gpu/drm/etnaviv/common.xml.h   |  59 ++++++++++--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c  | 161 ++++++++++++++++++++++-----------
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h  |   9 ++
 drivers/gpu/drm/etnaviv/state_hi.xml.h |  26 +++++-
 include/uapi/drm/etnaviv_drm.h         |   3 +
 5 files changed, 196 insertions(+), 62 deletions(-)

-- 
RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
