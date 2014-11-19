From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v12 1/3] drm: rockchip: Add basic drm driver
Date: Wed, 19 Nov 2014 10:04:13 +0100
Message-ID: <20141119100413.7ab613e9@bbrezillon>
References: <1416297587-18959-1-git-send-email-mark.yao@rock-chips.com>
	<1416297629-19024-1-git-send-email-mark.yao@rock-chips.com>
	<20141118083234.GZ25711@phenom.ffwll.local>
	<20141118142130.6c12ab50@bbrezillon>
	<20141118142447.GC25711@phenom.ffwll.local>
	<546BEDD9.1000205@rock-chips.com>
	<546BFA4D.3090700@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <546BFA4D.3090700@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark yao <mark.yao@rock-chips.com>
Cc: heiko@sntech.de, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, cf@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com, yxj@rock-chips.com, xw@rock-chips
List-Id: linux-api@vger.kernel.org

On Wed, 19 Nov 2014 10:02:53 +0800
Mark yao <mark.yao@rock-chips.com> wrote:

> On 2014=E5=B9=B411=E6=9C=8819=E6=97=A5 09:09, Mark yao wrote:
> > On 2014=E5=B9=B411=E6=9C=8818=E6=97=A5 22:24, Daniel Vetter wrote:
> >> On Tue, Nov 18, 2014 at 02:21:30PM +0100, Boris Brezillon wrote:
> >>> Hi Daniel,
> >>>
> >>> On Tue, 18 Nov 2014 09:32:34 +0100
> >>> Daniel Vetter <daniel@ffwll.ch> wrote:
> >>>
> >>>> On Tue, Nov 18, 2014 at 04:00:29PM +0800, Mark Yao wrote:
> >>>>> From: Mark yao <mark.yao@rock-chips.com>
> >>>>>
> >>>>> This patch adds the basic structure of a DRM Driver for Rockchi=
p=20
> >>>>> Socs.
> >>>>>
> >>>>> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
> >>>>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> >>>>> Acked-by: Daniel Vetter <daniel@ffwll.ch>
> >>>>> Reviewed-by: Rob Clark <robdclark@gmail.com>
> >>>>> ---
> >>>>> Changes in v2:
> >>>>> - use the component framework to defer main drm driver probe
> >>>>>    until all VOP devices have been probed.
> >>>>> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mappin=
g by
> >>>>>    master device and each vop device can shared the drm dma map=
ping.
> >>>>> - use drm_crtc_init_with_planes and drm_universal_plane_init.
> >>>>> - remove unnecessary middle layers.
> >>>>> - add cursor set, move funcs to rockchip drm crtc.
> >>>>> - use vop reset at first init
> >>>>> - reference framebuffer when used and unreference when swap out=
 vop
> >>>>>
> >>>>> Changes in v3:
> >>>>> - change "crtc->fb" to "crtc->primary-fb"
> >>>>> Adviced by Daniel Vetter
> >>>>> - init cursor plane with universal api, remove unnecessary curs=
or=20
> >>>>> set,move
> >>>>>
> >>>>> Changes in v4:
> >>>>> Adviced by David Herrmann
> >>>>> - remove drm_platform_*() usage, use register drm device direct=
ly.
> >>>> Minor fixup for that part below.
> >>>>
> >>>> [snip]
> >>>>
> >>>>> +static int rockchip_drm_bind(struct device *dev)
> >>>>> +{
> >>>>> +    struct drm_device *drm;
> >>>>> +    int ret;
> >>>>> +
> >>>>> +    drm =3D drm_dev_alloc(&rockchip_drm_driver, dev);
> >>>>> +    if (!drm)
> >>>>> +        return -ENOMEM;
> >>>>> +
> >>>>> +    ret =3D drm_dev_set_unique(drm, "%s", dev_name(dev));
> >>>>> +    if (ret)
> >>>>> +        goto err_free;
> >>>> Please call rockchip_drm_load here directly and don't put it as =
the=20
> >>>> ->load
> >>>> function into the driver vtable. The point of the alloc/register=
=20
> >>>> split is
> >>>> that the driver can be completely set up _before_ we register=20
> >>>> anything.
> >>>> But for backwards compat and historical reasons ->load is called=
=20
> >>>> somewhere
> >>>> in the middle (so that you could access the minor nodes if neede=
d,=20
> >>>> since
> >>>> some drivers do that).
> >>> I tried to do the same in the atmel-hlcdc DRM driver, but I need =
the
> >>> primary drm_minor to register the connectors (see this kernel
> >>> backtrace [1]), which means I either initialize the connector in =
the
> >>> wrong place (currently part of the drm load process), or I just c=
an't
> >>> call atmel_hlcdc_dc_load before registering the drm device...
> >> Hm right, wonder who that works with rockchip tbh.
> >>
> >> We did split up the drm_connector setup into _init and register, s=
o=20
> >> if you
> >> want to do this then you need to move the call to drm_connector_re=
gister
> >> below the call to drm_dev_register.
> >>
> >> We should probably have a drm_connectors_register_all helper which=
 does
> >> this for all connectors on the connector list. And also grabs the
> >> appropriate lock.
> >>
> >> I guess it's somewhat obvious that no one yet actually tried this =
;-)
> >> -Daniel
> > right, I re-test the driver with it, get the same problem with Bori=
s.
> > I should move drm_connector_register below the drm_dev_register.
> I try move connector_register below drm_dev_register, but unfortunate=
ly,=20
> drm_dev_register call
> drm_mode_group_init_legacy_group to save crtc, connector into list, i=
t=20
> need below  connector_register.
> so that problem is that now: connector_register need bewteen minor no=
de=20
> create and
> drm_mode_group_init_legacy_group.

AFAIU, the suggestion was to split drm_connector_init and
drm_connector_register calls:
 - drm_connector_init call should still be part of the load procedure
   (this function adds the connector to the connector list which is use=
d
   by drm_mode_group_init_legacy_group)
 - drm_connector_register should be called after the device has been
   registered

Here what I've done and it seems to work:

static int atmel_hlcdc_dc_connector_plug_all(struct drm_device *dev)
{
	struct drm_connector *connector, *failed;
	int ret;

	mutex_lock(&dev->mode_config.mutex);
	list_for_each_entry(connector,
	&dev->mode_config.connector_list, head) { ret =3D
	drm_connector_register(connector); if (ret) {
			failed =3D connector;
			goto err;
		}
	}
	mutex_unlock(&dev->mode_config.mutex);
	return 0;

err:
	list_for_each_entry(connector, &dev->mode_config.connector_list, head)=
 {
		if (failed =3D=3D connector)
			break;

		drm_connector_unregister(connector);
	}
	mutex_unlock(&dev->mode_config.mutex);

	return ret;
}

[...]

static int atmel_hlcdc_dc_drm_probe(struct platform_device *pdev)
{
	struct drm_device *ddev;
	int ret;

	ddev =3D drm_dev_alloc(&atmel_hlcdc_dc_driver, &pdev->dev);
	if (!ddev)
		return -ENOMEM;

	ret =3D drm_dev_set_unique(ddev, dev_name(ddev->dev));
	if (ret)
		goto err_unref;

	ret =3D atmel_hlcdc_dc_load(ddev);
	if (ret)
		goto err_unref;

	ret =3D drm_dev_register(ddev, 0);
	if (ret)
		goto err_unload;

	ret =3D atmel_hlcdc_dc_connector_plug_all(ddev);
	if (ret)
		goto err_unregister;

	return 0;

err_unregister:
	drm_dev_unregister(ddev);

err_unload:
	atmel_hlcdc_dc_unload(ddev);

err_unref:
	drm_dev_unref(ddev);

	return ret;
}

Daniel, can you confirm that's what you had in mind ?

Regards,

Boris

--=20
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
