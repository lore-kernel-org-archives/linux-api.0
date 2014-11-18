From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v12 1/3] drm: rockchip: Add basic drm driver
Date: Tue, 18 Nov 2014 15:24:47 +0100
Message-ID: <20141118142447.GC25711@phenom.ffwll.local>
References: <1416297587-18959-1-git-send-email-mark.yao@rock-chips.com>
 <1416297629-19024-1-git-send-email-mark.yao@rock-chips.com>
 <20141118083234.GZ25711@phenom.ffwll.local>
 <20141118142130.6c12ab50@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141118142130.6c12ab50@bbrezillon>
Sender: linux-doc-owner@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Mark Yao <mark.yao@rock-chips.com>, heiko@sntech.de, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, cf@rock-chips.com, xxm@rock-chips.com, huangtao@rock-c
List-Id: linux-api@vger.kernel.org

On Tue, Nov 18, 2014 at 02:21:30PM +0100, Boris Brezillon wrote:
> Hi Daniel,
> 
> On Tue, 18 Nov 2014 09:32:34 +0100
> Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > On Tue, Nov 18, 2014 at 04:00:29PM +0800, Mark Yao wrote:
> > > From: Mark yao <mark.yao@rock-chips.com>
> > > 
> > > This patch adds the basic structure of a DRM Driver for Rockchip Socs.
> > > 
> > > Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
> > > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > > Acked-by: Daniel Vetter <daniel@ffwll.ch>
> > > Reviewed-by: Rob Clark <robdclark@gmail.com>
> > > ---
> > > Changes in v2:
> > > - use the component framework to defer main drm driver probe
> > >   until all VOP devices have been probed.
> > > - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
> > >   master device and each vop device can shared the drm dma mapping.
> > > - use drm_crtc_init_with_planes and drm_universal_plane_init.
> > > - remove unnecessary middle layers.
> > > - add cursor set, move funcs to rockchip drm crtc.
> > > - use vop reset at first init
> > > - reference framebuffer when used and unreference when swap out vop
> > > 
> > > Changes in v3:
> > > - change "crtc->fb" to "crtc->primary-fb"
> > > Adviced by Daniel Vetter
> > > - init cursor plane with universal api, remove unnecessary cursor set,move 
> > > 
> > > Changes in v4:
> > > Adviced by David Herrmann
> > > - remove drm_platform_*() usage, use register drm device directly.
> > 
> > Minor fixup for that part below.
> > 
> > [snip]
> > 
> > > +static int rockchip_drm_bind(struct device *dev)
> > > +{
> > > +	struct drm_device *drm;
> > > +	int ret;
> > > +
> > > +	drm = drm_dev_alloc(&rockchip_drm_driver, dev);
> > > +	if (!drm)
> > > +		return -ENOMEM;
> > > +
> > > +	ret = drm_dev_set_unique(drm, "%s", dev_name(dev));
> > > +	if (ret)
> > > +		goto err_free;
> > 
> > Please call rockchip_drm_load here directly and don't put it as the ->load
> > function into the driver vtable. The point of the alloc/register split is
> > that the driver can be completely set up _before_ we register anything.
> > But for backwards compat and historical reasons ->load is called somewhere
> > in the middle (so that you could access the minor nodes if needed, since
> > some drivers do that).
> 
> I tried to do the same in the atmel-hlcdc DRM driver, but I need the
> primary drm_minor to register the connectors (see this kernel
> backtrace [1]), which means I either initialize the connector in the
> wrong place (currently part of the drm load process), or I just can't
> call atmel_hlcdc_dc_load before registering the drm device...

Hm right, wonder who that works with rockchip tbh.

We did split up the drm_connector setup into _init and register, so if you
want to do this then you need to move the call to drm_connector_register
below the call to drm_dev_register.

We should probably have a drm_connectors_register_all helper which does
this for all connectors on the connector list. And also grabs the
appropriate lock.

I guess it's somewhat obvious that no one yet actually tried this ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
