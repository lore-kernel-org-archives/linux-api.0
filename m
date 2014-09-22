From: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v3 1/5] drm/rockchip: Add basic drm driver
Date: Mon, 22 Sep 2014 09:27:33 +0800
Message-ID: <541F7B05.2000605@rock-chips.com>
References: <1411105668-32722-1-git-send-email-mark.yao@rock-chips.com>	<1411105668-32722-2-git-send-email-mark.yao@rock-chips.com> <CANq1E4Ti0yOQ+jCiXy7=NtFQ9cbWLOSLf6q-HWVdDFtMB1n29Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4Ti0yOQ+jCiXy7=NtFQ9cbWLOSLf6q-HWVdDFtMB1n29Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B409=E6=9C=8819=E6=97=A5 21:04, David Herrmann wrote:
> Hi
>
> On Fri, Sep 19, 2014 at 7:47 AM, Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> w=
rote:
> [snip]
>> +static int rockchip_drm_bind(struct device *dev)
>> +{
>> +       return drm_platform_init(&rockchip_drm_driver, to_platform_d=
evice(dev));
> Please avoid drm_platform_*() usage. We're about to drop all the
> drm_bus midlayers. See the tegra driver how to do it, but basically
> just this:
OK, I will do it.
> struct drm_device *ddev;
>
> ddev =3D drm_dev_alloc(&rockchip_drm_driver, &to_platform_device(dev)=
->dev);
> if (!ddev)
>          return -ENOMEM;
>
> r =3D drm_dev_set_unique(ddev, dev_name(&ddev->dev));
> if (r < 0) {
>          drm_dev_unref(ddev);
>          return r;
> }
>
> r =3D drm_dev_register(ddev);
> if (r < 0) {
>          drm_dev_unref(ddev);
>          return r;
> }
>
>> +}
>> +
>> +static void rockchip_drm_unbind(struct device *dev)
>> +{
>> +       drm_put_dev(dev_get_drvdata(dev));
> Please use:
>
> struct drm_device *ddev =3D dev_get_drvdata(dev);
>
> drm_dev_unregister(ddev);
> drm_dev_unref(ddev);
>
>
> Thanks
> David
>
>
>
