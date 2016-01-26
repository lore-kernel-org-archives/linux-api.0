From: Shawn Lin <shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v1 0/3] Add VP8 deocder for rk3229 & rk3288
Date: Tue, 26 Jan 2016 17:30:33 +0800
Message-ID: <56A73CB9.2040802@rock-chips.com>
References: <1453799046-307-1-git-send-email-jung.zhao@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453799046-307-1-git-send-email-jung.zhao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jung Zhao <jung.zhao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org
Cc: shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benoit Parrot <bparrot-l0cyMroinI0@public.gmane.org>, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, alpha.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, herman.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi jun,

Where is the dt-bingding documentation about your VP8 controller?

And would you please share some info about rk3229? I can just find
rk3228 in mainline, otherwise may someone think it's a misspell.

Thanks.

On 2016/1/26 17:04, Jung Zhao wrote:
> From: zhaojun <jung.zhao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>
>
> ====================
> Introduction
> ====================
>
> The purpose of this series is to add the driver for vp8
> decoder on rk3229 & rk3288 platform, and will support
> more formats in the future.
>
> The driver uses v4l2 framework and RK IOMMU.
> RK IOMMU has not yet been merged.
>
>
>
> zhaojun (3):
>    media: v4l: Add VP8 format support in V4L2 framework
>    media: VPU: support Rockchip VPU
>    media: vcodec: rockchip: Add Rockchip VP8 decoder driver
>
>   drivers/media/platform/rockchip-vpu/Makefile       |    7 +
>   .../media/platform/rockchip-vpu/rkvpu_hw_vp8d.c    |  798 ++++++++++
>   .../platform/rockchip-vpu/rockchip_vp8d_regs.h     | 1594 ++++++++++++++++++++
>   drivers/media/platform/rockchip-vpu/rockchip_vpu.c |  799 ++++++++++
>   .../platform/rockchip-vpu/rockchip_vpu_common.h    |  439 ++++++
>   .../media/platform/rockchip-vpu/rockchip_vpu_dec.c | 1007 +++++++++++++
>   .../media/platform/rockchip-vpu/rockchip_vpu_dec.h |   33 +
>   .../media/platform/rockchip-vpu/rockchip_vpu_hw.c  |  295 ++++
>   .../media/platform/rockchip-vpu/rockchip_vpu_hw.h  |  100 ++
>   drivers/media/v4l2-core/v4l2-ctrls.c               |   17 +-
>   drivers/media/v4l2-core/v4l2-ioctl.c               |    3 +
>   drivers/media/v4l2-core/videobuf2-dma-contig.c     |   51 +-
>   include/media/v4l2-ctrls.h                         |    2 +
>   include/media/videobuf2-dma-contig.h               |   11 +-
>   include/uapi/linux/v4l2-controls.h                 |   98 ++
>   include/uapi/linux/videodev2.h                     |    5 +
>   16 files changed, 5238 insertions(+), 21 deletions(-)
>   create mode 100644 drivers/media/platform/rockchip-vpu/Makefile
>   create mode 100644 drivers/media/platform/rockchip-vpu/rkvpu_hw_vp8d.c
>   create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vp8d_regs.h
>   create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu.c
>   create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_common.h
>   create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
>   create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.h
>   create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
>   create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h
>


-- 
Best Regards
Shawn Lin
