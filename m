From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH 1/3] media: Fix ALSA and DVB representation at media controller
 API
Date: Mon, 26 Jan 2015 14:41:53 +0100
Message-ID: <54C64421.1030302@xs4all.nl>
References: <cover.1422273497.git.mchehab@osg.samsung.com>	<cb0517f150942a2d3657c1f2e55754061bfae2c4.1422273497.git.mchehab@osg.samsung.com>	<54C63D16.3070607@xs4all.nl> <20150126113416.311fb376@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150126113416.311fb376-+RedX5hVuTR+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Ricardo Ribalda <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishnan Muthukrishnan <ramakrmu-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/26/2015 02:34 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 26 Jan 2015 14:11:50 +0100
> Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> escreveu:
> 
>> On 01/26/2015 01:47 PM, Mauro Carvalho Chehab wrote:
>>> The previous provision for DVB media controller support were to
>>> define an ID (likely meaning the adapter number) for the DVB
>>> devnodes.
>>>
>>> This is just plain wrong. Just like V4L, DVB devices (and ALSA,
>>> or whatever) are identified via a (major, minor) tuple.
>>>
>>> This is enough to uniquely identify a devnode, no matter what
>>> API it implements.
>>>
>>> So, before we go too far, let's mark the old v4l, dvb and alsa
>>> "devnode" info as deprecated, and just call it as "dev".
>>>
>>> As we don't want to break compilation on already existing apps,
>>> let's just keep the old definitions as-is, adding a note that
>>> those are deprecated at media-entity.h.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
>>> index 86bb93fd7db8..d89d5cb465d9 100644
>>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>>> @@ -943,8 +943,8 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>>>  	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
>>>  		vdev->entity.type = MEDIA_ENT_T_DEVNODE_V4L;
>>>  		vdev->entity.name = vdev->name;
>>> -		vdev->entity.info.v4l.major = VIDEO_MAJOR;
>>> -		vdev->entity.info.v4l.minor = vdev->minor;
>>> +		vdev->entity.info.dev.major = VIDEO_MAJOR;
>>> +		vdev->entity.info.dev.minor = vdev->minor;
>>>  		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
>>>  			&vdev->entity);
>>>  		if (ret < 0)
>>> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
>>> index 015f92aab44a..204cc67c84e8 100644
>>> --- a/drivers/media/v4l2-core/v4l2-device.c
>>> +++ b/drivers/media/v4l2-core/v4l2-device.c
>>> @@ -248,8 +248,8 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
>>>  			goto clean_up;
>>>  		}
>>>  #if defined(CONFIG_MEDIA_CONTROLLER)
>>> -		sd->entity.info.v4l.major = VIDEO_MAJOR;
>>> -		sd->entity.info.v4l.minor = vdev->minor;
>>> +		sd->entity.info.dev.major = VIDEO_MAJOR;
>>> +		sd->entity.info.dev.minor = vdev->minor;
>>>  #endif
>>>  		sd->devnode = vdev;
>>>  	}
>>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>>> index e00459185d20..d6d74bcfe183 100644
>>> --- a/include/media/media-entity.h
>>> +++ b/include/media/media-entity.h
>>> @@ -87,17 +87,7 @@ struct media_entity {
>>>  		struct {
>>>  			u32 major;
>>>  			u32 minor;
>>> -		} v4l;
>>> -		struct {
>>> -			u32 major;
>>> -			u32 minor;
>>> -		} fb;
>>> -		struct {
>>> -			u32 card;
>>> -			u32 device;
>>> -			u32 subdevice;
>>> -		} alsa;
>>
>> I don't think the alsa entity information can be replaced by major/minor.
>> In particular you will loose the subdevice information which you need as
>> well. In addition, alsa devices are almost never referenced via major and
>> minor numbers, but always by card/device/subdevice numbers.
> 
> For media-ctl, it is easier to handle major/minor, in order to identify
> the associated devnode name. Btw, media-ctl currently assumes that all
> devnode devices are specified by v4l.major/v4l.minor.
> 
> Ok, maybe for alsa we'll need also card/device/subdevice, but I think this
> should be mapped elsewhere, if this can't be retrieved via its sysfs/udev
> interface (with seems to be doubtful).

The card/device tuple can likely be mapped to major/minor, but not subdevice.
And since everything inside alsa is based on card/device I wouldn't change
that.

> 
>>
>>> -		int dvb;
>>> +		} dev;
>>>  
>>>  		/* Sub-device specifications */
>>>  		/* Nothing needed yet */
>>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>>> index d847c760e8f0..418f4fec391a 100644
>>> --- a/include/uapi/linux/media.h
>>> +++ b/include/uapi/linux/media.h
>>> @@ -78,6 +78,20 @@ struct media_entity_desc {
>>>  		struct {
>>>  			__u32 major;
>>>  			__u32 minor;
>>> +		} dev;
>>> +
>>> +#if 1
>>> +		/*
>>> +		 * DEPRECATED: previous node specifications. Kept just to
>>> +		 * avoid breaking compilation, but media_entity_desc.dev
>>> +		 * should be used instead. In particular, alsa and dvb
>>> +		 * fields below are wrong: for all devnodes, there should
>>> +		 * be just major/minor inside the struct, as this is enough
>>> +		 * to represent any devnode, no matter what type.
>>> +		 */
>>> +		struct {
>>> +			__u32 major;
>>> +			__u32 minor;
>>>  		} v4l;
>>>  		struct {
>>>  			__u32 major;
>>> @@ -89,6 +103,7 @@ struct media_entity_desc {
>>>  			__u32 subdevice;
>>>  		} alsa;
>>>  		int dvb;
>>
>> I wouldn't merge all the v4l/fb/etc. structs into one struct. That will make it
>> difficult in the future if you need to add a field for e.g. v4l entities.
> 
> No. You could just create another union for the API-specific bits, using the
> reserved bytes.
> 
>> So I would keep the v4l, fb and alsa structs, and just add a new struct for
>> dvb. I wonder if the dvb field can't just be replaced since I doubt anyone is
>> using it. And even if someone does, then it can't be right since a single
>> int isn't enough and never worked anyway.
> 
> All devnodes have major/minor. Making it standard for all devices makes
> easy for userspace to properly get the data it requires to work.

I think you are making assumptions here that may not be true. I don't see any
reason to make a 'dev' struct here. The real problem is the dvb int, so that's
what needs to be addressed. Changing anything else will cause API headaches
for no good reason.

Regards,

	Hans
