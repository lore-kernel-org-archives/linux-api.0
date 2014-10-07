From: Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH v9 1/3] drm: rockchip: Add basic drm driver
Date: Tue, 07 Oct 2014 08:13:24 +0200
Message-ID: <54338484.5070809@samsung.com>
References: <1412081870-27535-1-git-send-email-mark.yao@rock-chips.com>
 <1412082181-27703-1-git-send-email-mark.yao@rock-chips.com>
 <542AB0B2.6000207@samsung.com> <54336474.1010503@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <54336474.1010503@rock-chips.com>
Sender: linux-doc-owner@vger.kernel.org
To: Mark yao <mark.yao@rock-chips.com>, heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com
List-Id: linux-api@vger.kernel.org

On 10/07/2014 05:56 AM, Mark yao wrote:
> On 2014=E5=B9=B409=E6=9C=8830=E6=97=A5 21:31, Andrzej Hajda wrote:
>> Hi Mark,
> Hi Andrzej,
>     Sorry for replying late, I have a vacation before.
>     Thanks for your review.
>> On 09/30/2014 03:03 PM, Mark Yao wrote:
>>> From: Mark yao <mark.yao@rock-chips.com>
>>>
(...)
>>> +#ifdef CONFIG_PM_SLEEP
>>> +static int rockchip_drm_suspend(struct drm_device *dev, pm_message=
_t state)
>>> +{
>>> +	struct drm_connector *connector;
>>> +
>>> +	drm_modeset_lock_all(dev);
>>> +	list_for_each_entry(connector, &dev->mode_config.connector_list, =
head) {
>>> +		int old_dpms =3D connector->dpms;
>>> +
>>> +		if (connector->funcs->dpms)
>>> +			connector->funcs->dpms(connector, DRM_MODE_DPMS_OFF);
>>> +
>>> +		/* Set the old mode back to the connector for resume */
>>> +		connector->dpms =3D old_dpms;
>>> +	}
>>> +	drm_modeset_unlock_all(dev);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int rockchip_drm_resume(struct drm_device *dev)
>>> +{
>>> +	struct drm_connector *connector;
>>> +
>>> +	drm_modeset_lock_all(dev);
>>> +	list_for_each_entry(connector, &dev->mode_config.connector_list, =
head) {
>>> +		if (connector->funcs->dpms)
>>> +			connector->funcs->dpms(connector, connector->dpms);
>>> +	}
>>> +	drm_modeset_unlock_all(dev);
>>> +
>>> +	drm_helper_resume_force_mode(dev);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int rockchip_drm_sys_suspend(struct device *dev)
>>> +{
>>> +	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
>>> +	pm_message_t message;
>>> +
>>> +	if (pm_runtime_suspended(dev))
>>> +		return 0;
>>> +
>>> +	message.event =3D PM_EVENT_SUSPEND;
>>> +
>>> +	return rockchip_drm_suspend(drm_dev, message);
>> drm_dev can be NULL here, it can happen when system is suspended
>> before all components are bound. It can also contain invalid pointer
>> if after successfull drm initialization de-initialization happens fo=
r
>> some reason.
>>
>> Some workaround is to check for null here and set drvdata to null on
>> master unbind. But I guess it should be protected somehow to avoid r=
aces
>> in accessing drvdata.
> So, can I use the way that check for null here and set drvdata to nul=
l
> on master unbind?
> I don't know which way is better to protect somehow.

It seems to be a core problem, I have proposed some solution using drm
driver PM callbacks [1]
but it appears these callbacks are obsolete, so different solution
should be found. According to
Russel probably some extension of component framework.
As a temporary solution I guess null checks should work in most cases.

Regards
Andrzej


[1]: https://lkml.org/lkml/2014/10/3/60

>
> -Mark.
>>> +}
>>> +
>>> +static int rockchip_drm_sys_resume(struct device *dev)
>>> +{
>>> +	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
>>> +
>>> +	if (!pm_runtime_suspended(dev))
>>> +		return 0;
>>> +
>>> +	return rockchip_drm_resume(drm_dev);
>> Ditto.
>>
>> Regards
>> Andrzej
>>
>>

