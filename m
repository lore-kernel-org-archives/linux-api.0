From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH 07/18] media controller: rename the tuner entity
Date: Mon, 11 May 2015 11:38:39 +0200
Message-ID: <5550789F.60304@xs4all.nl>
References: <cover.1431046915.git.mchehab@osg.samsung.com>	<6d88ece22cbbbaa72bbddb8b152b0d62728d6129.1431046915.git.mchehab@osg.samsung.com>	<554CA862.8070407@xs4all.nl>	<20150508095754.1c39a276@recife.lan>	<554CB863.1040006@xs4all.nl>	<20150508110826.00e4e954@recife.lan>	<554CC8E3.2030308@xs4all.nl>	<554DD3FE.1070806@xs4all.nl> <20150511063138.1ea10ccf@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150511063138.1ea10ccf-+RedX5hVuTR+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matthias Schwarzott <zzam-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Olli Salonen <olli.salonen-X3B1VOXEql0@public.gmane.org>, Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/11/2015 11:31 AM, Mauro Carvalho Chehab wrote:
> Em Sat, 09 May 2015 11:31:42 +0200
> Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> escreveu:
> 
>>>>> Brainstorming:
>>>>>
>>>>> It might be better to map each device node to an entity and each hardware
>>>>> component (tuner, DMA engine) to an entity, and avoid this mixing of
>>>>> hw entity vs device node entity.
>>
>> There are two options here:
>>
>> either make each device node an entity, or expose the device node information
>> as properties of an entity.
>>
>> The latter would be backwards compatible with what we do today. I'm trying to
>> think of reasons why you would want to make each device node an entity in its
>> own right.
>>
>> The problem today is that a video_device representing a video/vbi/radio/swradio
>> device node is an entity, but it is really representing the dma engine. Which
>> is weird for radio devices since there is no dma engine there.
>>
>> Implementing device nodes as entities in their own right does solve this problem,
>> but implementing it as properties would be weird since a radio device node would
>> be a property of a radio tuner entity, which can be a subdevice driver which means
>> that the bridge driver would have to add the radio device property to a subdev
>> driver, which feels really wrong to me.
>>
>> With this in mind I do think representing device nodes as entities in their own
>> right makes sense.
> 
> I agree with that: devnodes should be entities, as they're the points to control
> the hardware, and need to be known by the Kernel, no matter if they have DMA
> engines associated with it or not. The better seems to map the DMA engine
> as a property on those entities.
> 
>> But I would do this also for a v4l-subdev node. It's very
>> inconsistent not to do that.
> 
> It should be easy to create an entity for each v4l-subdev node. I just
> don't see much usage on it, and this will almost double the number of
> entities.

The memory is already allocated for that since it is part of struct video_device,
which v4l-subdev uses. So I don't see this as a problem.

> Also, in order to keep it backward-compatible, both the subdev
> devnode and the subdev no-devnode entity should accept the same set of
> ioctls.

The ioctls always go through the video_device, that will not be changed by
this.

But I agree that there are other backward-compat issues. Unfortunately I cannot
dedicate much time on this at the moment.

Regards,

	Hans
