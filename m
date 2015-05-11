From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 07/18] media controller: rename the tuner entity
Date: Mon, 11 May 2015 06:31:38 -0300
Message-ID: <20150511063138.1ea10ccf@recife.lan>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
	<6d88ece22cbbbaa72bbddb8b152b0d62728d6129.1431046915.git.mchehab@osg.samsung.com>
	<554CA862.8070407@xs4all.nl>
	<20150508095754.1c39a276@recife.lan>
	<554CB863.1040006@xs4all.nl>
	<20150508110826.00e4e954@recife.lan>
	<554CC8E3.2030308@xs4all.nl>
	<554DD3FE.1070806@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <554DD3FE.1070806@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Matthias Schwarzott <zzam@gentoo.org>, Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>, Prabhakar Lad <prabhakar.csengg@gmail.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Em Sat, 09 May 2015 11:31:42 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> >>> Brainstorming:
> >>>
> >>> It might be better to map each device node to an entity and each hardware
> >>> component (tuner, DMA engine) to an entity, and avoid this mixing of
> >>> hw entity vs device node entity.
> 
> There are two options here:
> 
> either make each device node an entity, or expose the device node information
> as properties of an entity.
> 
> The latter would be backwards compatible with what we do today. I'm trying to
> think of reasons why you would want to make each device node an entity in its
> own right.
> 
> The problem today is that a video_device representing a video/vbi/radio/swradio
> device node is an entity, but it is really representing the dma engine. Which
> is weird for radio devices since there is no dma engine there.
> 
> Implementing device nodes as entities in their own right does solve this problem,
> but implementing it as properties would be weird since a radio device node would
> be a property of a radio tuner entity, which can be a subdevice driver which means
> that the bridge driver would have to add the radio device property to a subdev
> driver, which feels really wrong to me.
> 
> With this in mind I do think representing device nodes as entities in their own
> right makes sense.

I agree with that: devnodes should be entities, as they're the points to control
the hardware, and need to be known by the Kernel, no matter if they have DMA
engines associated with it or not. The better seems to map the DMA engine
as a property on those entities.

> But I would do this also for a v4l-subdev node. It's very
> inconsistent not to do that.

It should be easy to create an entity for each v4l-subdev node. I just
don't see much usage on it, and this will almost double the number of
entities. Also, in order to keep it backward-compatible, both the subdev
devnode and the subdev no-devnode entity should accept the same set of
ioctls.

Regards,
Mauro
