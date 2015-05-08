From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH 07/18] media controller: rename the tuner entity
Date: Fri, 08 May 2015 16:32:03 +0200
Message-ID: <554CC8E3.2030308@xs4all.nl>
References: <cover.1431046915.git.mchehab@osg.samsung.com>	<6d88ece22cbbbaa72bbddb8b152b0d62728d6129.1431046915.git.mchehab@osg.samsung.com>	<554CA862.8070407@xs4all.nl>	<20150508095754.1c39a276@recife.lan>	<554CB863.1040006@xs4all.nl> <20150508110826.00e4e954@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150508110826.00e4e954-+RedX5hVuTR+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matthias Schwarzott <zzam-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Olli Salonen <olli.salonen-X3B1VOXEql0@public.gmane.org>, Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/08/2015 04:08 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 08 May 2015 15:21:39 +0200
> Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> escreveu:
> 
>> On 05/08/2015 02:57 PM, Mauro Carvalho Chehab wrote:
>>> Em Fri, 08 May 2015 14:13:22 +0200
>>> Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> escreveu:
>>>
>>>> On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
>>>>> Finally, let's rename the tuner entity. inside the media subsystem,
>>>>> a tuner can be used by AM/FM radio, SDR radio, analog TV and digital TV.
>>>>> It could even be used on other subsystems, like network, for wireless
>>>>> devices.
>>>>>
>>>>> So, it is not constricted to V4L2 API, or to a subdev.
>>>>>
>>>>> Let's then rename it as:
>>>>> 	MEDIA_ENT_T_V4L2_SUBDEV_TUNER -> MEDIA_ENT_T_TUNER
>>>>
>>>> See patch 04/18.
>>>
>>> Mapping the tuner as a V4L2_SUBDEV is plain wrong. We can't assume
>>> that a tuner will always be mapped via V4L2 subdev API.
>>
>> True. Today we have subdevs that have no device node to control them, so
>> in that case it would just be a SUBDEV entity. There are subdevs that make
>> a v4l-subdev device node, so those can be V4L(2)_SUBDEV entities.
>>
>> The question is: what are your ideas for e.g. DVB-only tuners? Would they
>> get a DVB-like device node? (so DTV_SUBDEV)
> 
> I guess we may need DVB subdevs in the future. For now, I don't see
> much usage.
> 
>> Would hybrid tuners have two
>> device nodes? One v4l-subdev, one dvb/dtv-subdev?
> 
> No. A tuner is a tuner. The very same device can be used for analog or
> digital TV. Ok, there are tuners that only work for digital TV (satellite
> tuners, typically), because satellite requires a different tuning range,
> and require an extra hardware to power up the satellite antena. So, on
> most devices, the tuner is integrated with SEC.
> 
> In any case, I don't see any reason why artificially one piece of hardware
> component (tuner) into one subdevice entity per API.
> 
> What it might make sense in the future is to have some DVB-specific ioctls
> for a hybrid tuner,  in order to allow adjusting its internal filters to
> an specific digital TV standard.
> 
>> Just curious what your thoughts are.
>>
>> Brainstorming:
>>
>> It might be better to map each device node to an entity and each hardware
>> component (tuner, DMA engine) to an entity, and avoid this mixing of
>> hw entity vs device node entity.
> 
> Ok, but then we need to properly define the namespaces for HW and for
> Linux API components.
> 
> So, we would have a namespace like:
>  
> 	- ENT_T_DEVNODE_DVB_(FE|CA|NET|DEMUX|DVR) for the DVB API device nodes;
> 	- ENT_T_DEVNODE_V4L for the radio/swradio/video/vbi devnodes, or,
> alternatively, use ENT_T_DEVNODE_V4L_(RADIO|SWRADIO|VIDEO|VBI);
> 	- ENT_T_HW_(TUNER|CAM_SENSOR|ATV_DEMOD|DTV_DEMOD|...) for the
> hardware components.
> 
> In other words, the namespace would actually define two subtypes:
> 	- devnodes;
> 	- hardware components
> 
> There's one advantage on this strategy: it is easier to keep backward
> compatibility, IMHO, as we'll be preserving 1 << 16 for device nodes

Right, that will work.

> and 2 << 16 for hardware components.

This remains problematic since I believe this should be done as a list
of properties. Instead the entity type would be ENT_T_HW (if it represents
actual hardware), ENT_T_SW (if it is a software implementation, for example
for the DVB demux if there is no HW demux), and perhaps ENT_T_IP for
representing IP blocks (not sure about this one).

And the properties will tell what functions it supports.

The existing 2 << 16 defines would only be used if the property list matches
the original meaning of the define to keep it backwards compatible.

> 
> Yet, we'll need to add an entity for the V4L2 hardware DMA (with makes
> sense to me), and this might break backward compatibility if not done
> well.

I see this as a property as well, but otherwise I agree with this.

> 
> It should be said that, in such case, hardware components will then
> mean not only V4L2-specific hardware (V4L2_SUBDEV_foo), but also DVB,
> ALSA, ... components.
> 
> So, we'll still need a way to identify what of those components are
> V4L2 subdevs, probably using the properties API.

Why? A hardware component that can be controlled via a v4l-subdev node
would be linked to an entity for that v4l-subdev node. That's an API
entity. The whole 'is this a v4l-subdev' question disappears, since that
is now no longer relevant. Instead you will have an ENT_T_DEVNODE_V4L_SUBDEV
entity linked to the hw entity.

Even a radio device would fit cleanly into this: the tuner entity simply
has a link to a radio device node entity.

Hmm, does this also solve the control vs DMA issue? If a DEVNODE entity
is hooked up to an entity with the DMA functionality, then you can stream,
otherwise it is just for control.

I'm not sure if this is always true, though. Of course, we can also just
add the streaming/dma property to the DEVNODE entity as well.

> If you all agree with that, I'll respin the patch series to map the
> entities like that.

We can interpret the existing ENT_T_HW_TUNER etc. as shorthand for a
property while the property API isn't there yet (we need that anyway
for backwards compat).

So we would need to add a ENT_T_HW_DMA as well (to be replaced by a
property later).

Basically I see the 1 << 16 range as device node types, the 2 << 16 range
as shorthands for what should be properties (this really defined functions
and entities can combine multiple functions), and we would need to have a
new range (4 << 16) for non-DEVNODE entity types. Although we could keep
it in range 1 << 16 as well, but I think it might make sense to keep it
separate.

And there you would get ENT_T_HW/SW/IP (not sure about the last one). And
perhaps FPGA.

Again, just brainstorming here.

Regards,

	Hans
