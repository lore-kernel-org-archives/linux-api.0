From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
Date: Tue, 23 Sep 2014 10:11:34 +0200
Message-ID: <3217883.XVKPdbd6UA@wuerfel>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com> <3102396.6rAQmqkXXM@wuerfel> <54211CB1.6050002@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54211CB1.6050002-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cf@rock-ch
List-Id: linux-api@vger.kernel.org

On Tuesday 23 September 2014 15:09:37 Mark yao wrote:
> On 2014=E5=B9=B409=E6=9C=8822=E6=97=A5 23:54, Arnd Bergmann wrote:
> > On Monday 22 September 2014 17:15:06 Boris BREZILLON wrote:
> >>>> +
> >>>> +   /* TODO(djkurtz): fetch the mapping start/size from somewher=
e */
> >>>> +   mapping =3D arm_iommu_create_mapping(&platform_bus_type, 0x1=
0000000,
> >>>> +                                      SZ_1G);
> >>>> +   if (IS_ERR(mapping)) {
> >>>> +           ret =3D PTR_ERR(mapping);
> >>>> +           goto err_config_cleanup;
> >>>> +   }
> >>>> +
> >>>> +   dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
> >>> This is the default coherent mask. If you call this function, you
> >>> should normally check the return value, or call dma_set_mask firs=
t,
> >>> which you apparently don't do here, and in another place in this
> >>> patch.
> >> By "This is the default mask" do you mean it shouldn't be called a=
t
> >> all ? Cause I ran into some trouble when not calling this in my
> >> atmel-hlcdc driver.
> > We used to get this wrong in the of_platform code, but it should
> > work now.
> >
> >> Actually, in my case the platform device is created by the MFD cor=
e
> >> which seems to let the coherent_dma_mask uninitialized.
> > That may well be different, but it seems like a good idea to allow
> > the MFD core to set this up as well.
> >
> > In general, we expect that devices that are capable of doing DMA
> > start with a 32-bit mask for both dma_mask and dma_coherent_mask,
> > and a driver that requires a smaller masks or wants a larger mask
> > has to call the appropriate interface to set these, and check the
> > return value.
> so I think we can use dma_set_mask_and_coherent(...) to set dma_mask =
and=20
> dma_coherent_mark
> at the same time, and check the return value.

Yes, that would be good.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
