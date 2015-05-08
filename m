From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH 07/18] media controller: rename the tuner entity
Date: Fri, 08 May 2015 15:21:39 +0200
Message-ID: <554CB863.1040006@xs4all.nl>
References: <cover.1431046915.git.mchehab@osg.samsung.com>	<6d88ece22cbbbaa72bbddb8b152b0d62728d6129.1431046915.git.mchehab@osg.samsung.com>	<554CA862.8070407@xs4all.nl> <20150508095754.1c39a276@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150508095754.1c39a276-+RedX5hVuTR+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matthias Schwarzott <zzam-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Olli Salonen <olli.salonen-X3B1VOXEql0@public.gmane.org>, Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/08/2015 02:57 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 08 May 2015 14:13:22 +0200
> Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> escreveu:
> 
>> On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
>>> Finally, let's rename the tuner entity. inside the media subsystem,
>>> a tuner can be used by AM/FM radio, SDR radio, analog TV and digital TV.
>>> It could even be used on other subsystems, like network, for wireless
>>> devices.
>>>
>>> So, it is not constricted to V4L2 API, or to a subdev.
>>>
>>> Let's then rename it as:
>>> 	MEDIA_ENT_T_V4L2_SUBDEV_TUNER -> MEDIA_ENT_T_TUNER
>>
>> See patch 04/18.
> 
> Mapping the tuner as a V4L2_SUBDEV is plain wrong. We can't assume
> that a tuner will always be mapped via V4L2 subdev API.

True. Today we have subdevs that have no device node to control them, so
in that case it would just be a SUBDEV entity. There are subdevs that make
a v4l-subdev device node, so those can be V4L(2)_SUBDEV entities.

The question is: what are your ideas for e.g. DVB-only tuners? Would they
get a DVB-like device node? (so DTV_SUBDEV) Would hybrid tuners have two
device nodes? One v4l-subdev, one dvb/dtv-subdev?

Just curious what your thoughts are.

Brainstorming:

It might be better to map each device node to an entity and each hardware
component (tuner, DMA engine) to an entity, and avoid this mixing of
hw entity vs device node entity.

Hmm, we need a another brainstorm meeting...

Regards,

	Hans
