From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v3 1/5] drm/rockchip: Add basic drm driver
Date: Tue, 23 Sep 2014 09:48:31 +0200
Message-ID: <20140923074831.GR15734@phenom.ffwll.local>
References: <1411105668-32722-1-git-send-email-mark.yao@rock-chips.com>
 <1411105668-32722-2-git-send-email-mark.yao@rock-chips.com>
 <CAF6AEGsPoj6+PdKCJk5BPPzHS51Tz1FGqS2SjpartaRw7i=Pxg@mail.gmail.com>
 <541F7C23.8000103@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <541F7C23.8000103@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark yao <mark.yao@rock-chips.com>
Cc: Rob Clark <robdclark@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>, linux-doc@vger.kernel.org, Kever Yang <kever.yang@rock-chips.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jianqun Xu <xjq@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>, linux-api@vger.kernel.org, jeff chen <cym@rock-chips.com>, linux-rockchip@lists.infradead.org, kfx@rock-chips.com, Grant Likely <grant.likely@linaro.org>, wxt@rock-chips.com, Tao Huang <huangtao@rock-chips.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, yxj@rock-chips.com, Eddie Cai <cf@rock-chips.com>, Rob Herring <robh+dt@kernel.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 22, 2014 at 09:32:19AM +0800, Mark yao wrote:
> On 2014=E5=B9=B409=E6=9C=8820=E6=97=A5 08:03, Rob Clark wrote:
> >On Fri, Sep 19, 2014 at 1:47 AM, Mark yao <mark.yao@rock-chips.com> =
wrote:
> >>diff --git a/include/uapi/drm/rockchip_drm.h b/include/uapi/drm/roc=
kchip_drm.h
> >>new file mode 100644
> >>index 0000000..8f8e60e
> >>--- /dev/null
> >>+++ b/include/uapi/drm/rockchip_drm.h
> >>@@ -0,0 +1,97 @@
> >>+/*
> >>+ *
> >>+ * Copyright (c) Fuzhou Rockchip Electronics Co.Ltd
> >>+ * Authors:
> >>+ *       Mark Yao <yzq@rock-chips.com>
> >>+ *
> >>+ * base on exynos_drm.h
> >>+ *
> >>+ * This program is free software; you can redistribute  it and/or =
modify it
> >>+ * under  the terms of  the GNU General  Public License as publish=
ed by the
> >>+ * Free Software Foundation;  either version 2 of the  License, or=
 (at your
> >>+ * option) any later version.
> >>+ */
> >>+
> >>+#ifndef _UAPI_ROCKCHIP_DRM_H
> >>+#define _UAPI_ROCKCHIP_DRM_H
> >>+
> >>+#include <drm/drm.h>
> >>+
> >>+/**
> >>+ * User-desired buffer creation information structure.
> >>+ *
> >>+ * @size: user-desired memory allocation size.
> >>+ * @flags: user request for setting memory type or cache attribute=
s.
> >>+ * @handle: returned a handle to created gem object.
> >>+ *     - this handle will be set by gem module of kernel side.
> >>+ */
> >>+struct drm_rockchip_gem_create {
> >>+       uint64_t size;
> >>+       uint32_t flags;
> >>+       uint32_t handle;
> >>+};
> >>+
> >>+/**
> >>+ * A structure for getting buffer offset.
> >>+ *
> >>+ * @handle: a pointer to gem object created.
> >>+ * @pad: just padding to be 64-bit aligned.
> >>+ * @offset: relatived offset value of the memory region allocated.
> >>+ *     - this value should be set by user.
> >>+ */
> >>+struct drm_rockchip_gem_map_off {
> >>+       uint32_t handle;
> >>+       uint32_t pad;
> >>+       uint64_t offset;
> >>+};
> >>+
> >>+/**
> >>+ * A structure for mapping buffer.
> >>+ *
> >>+ * @handle: a handle to gem object created.
> >>+ * @pad: just padding to be 64-bit aligned.
> >>+ * @size: memory size to be mapped.
> >>+ * @mapped: having user virtual address mmaped.
> >>+ *      - this variable would be filled by rockchip gem module
> >>+ *      of kernel side with user virtual address which is allocate=
d
> >>+ *      by do_mmap().
> >>+ */
> >>+struct drm_rockchip_gem_mmap {
> >>+       uint32_t handle;
> >>+       uint32_t pad;
> >>+       uint64_t size;
> >>+       uint64_t mapped;
> >>+};
> >Could we do without the mmap ioctl?  It has been a source of problem=
s
> >in other drivers, and the ioctl to get mmap offset, plus normal mmap=
()
> >on drm device file should be sufficient
> >
> >BR,
> >-R
> OK, I will try to move the special mmap ioctl and use drm generic mma=
p
> interface.

Actually you probably should drop all this and just implement the dummy
object support for now. Until you have proper hw accel there's no reaso=
n
to expose a driver-private gem create/mmap interface at all.

A pure kms driver really shouldn't have it's on uapi/foo_drm.h file.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
