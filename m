From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 03/18] media controller: use MEDIA_ENT_T_AV_DMA for A/V
 DMA engines
Date: Fri, 08 May 2015 13:54:07 +0200
Message-ID: <554CA3DF.9030700@xs4all.nl>
References: <cover.1431046915.git.mchehab@osg.samsung.com> <afb84e3d80fc4f6f2465a123012f161b8c29f1c4.1431046915.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <afb84e3d80fc4f6f2465a123012f161b8c29f1c4.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Hyun Kwon <hyun.kwon@xilinx.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Michal Simek <michal.simek@xilinx.com>, =?windows-1252?Q?S=F6ren_Brink?= =?windows-1252?Q?mann?= <soren.brinkmann@xilinx.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>, Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>, Markus Elfring <elfring@users.sourceforge.net>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> At the Video4Linux API, the /dev/video?, /dev/vbi? and
> /dev/radio? device nodes are used for the chipset that

You should add /dev/swradio? for SDR devices.

> provides the bridge between video/radio streams and the
> USB, PCI or CPU buses.
> 
> Such bridge is also typically used to control the V4L2 device
> as a hole.

hole -> whole

> 
> For video streaming devices and SDR radio devices, they're
> also associated with the DMA engines that transfer the
> video stream (or SDR stream) to the CPU's memory.
> 
> It should be noticed, however, this is not true on non-SDR
> radio devices,

I think you forgot that SDR devices are not using /dev/radio
but /dev/swradio. They have different names. Radio devices never
stream (OK, I think there are one or two exceptions, but that's really
because nobody bothered to make an alsa driver. Those boards are
in practice out of spec.)

> and may also not be true on embedded devices
> that, due to DRM reasons, don't allow writing unencrypted
> data on a memory that could be seen by the CPU.

This actually might still work by using opaque DMABUF handles. But that's
under discussion right now in the Secure Data Path thread.

Another reason can also be that the SoC vendor re-invented the wheel
and made there own DMA streaming solution. You can still make V4L drivers
that control the video receivers/transmitters, but for the actual streaming
you are forced to use the vendor's crap code (hello TI!).

I've bitter experiences with that :-(
 
> So, we'll eventually need to add another entity for such
> bridge chipsets that have a video/vbi/radio device node
> associated, but don't have DMA engines on (some) devnodes.
> 
> As, currently, we don't have any such case,

??? Radio devices are exactly that.

> let's for now
> just rename the device nodes that are associated with a
> DMA engine as MEDIA_ENT_T_AV_DMA.
> 
> So,
> 	MEDIA_ENT_T_DEVNODE_V4L -> MEDIA_ENT_T_AV_DMA
> 
> PS.: This is not actually true for USB devices, as the
> DMA engine is an internal component, as it is up to the
> Kernel to strip the stream payload from the URB packages.

How about MEDIA_ENT_T_DATA_STREAMING? Or perhaps DATA_IO? Perhaps even just
"IO"?

That would cover USB as well, and I dislike the use of "AV", since the
data might contain other things besides audio and/or video.

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> index 5872f8bbf774..5b8147629159 100644
> --- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> @@ -183,7 +183,7 @@
>  	    <entry>Unknown device node</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE_V4L</constant></entry>
> +	    <entry><constant>MEDIA_ENT_T_AV_DMA</constant></entry>
>  	    <entry>V4L video, radio or vbi device node</entry>
>  	  </row>
>  	  <row>
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index efde88adf624..7fa0cc0f08f0 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -193,7 +193,7 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
>  		struct xvip_dma *dma;
>  
> -		if (entity->type != MEDIA_ENT_T_DEVNODE_V4L)
> +		if (entity->type != MEDIA_ENT_T_AV_DMA)
>  			continue;
>  
>  		dma = to_xvip_dma(media_entity_to_video_device(entity));
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 71a1b93b0790..9ef920221b5a 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -912,7 +912,7 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>  	/* Part 5: Register the entity. */
>  	if (vdev->v4l2_dev->mdev &&
>  	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
> -		vdev->entity.type = MEDIA_ENT_T_DEVNODE_V4L;
> +		vdev->entity.type = MEDIA_ENT_T_AV_DMA;
>  		vdev->entity.name = vdev->name;
>  		vdev->entity.info.dev.major = VIDEO_MAJOR;
>  		vdev->entity.info.dev.minor = vdev->minor;
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 63596063b213..9f8fc8330b3e 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -535,7 +535,7 @@ v4l2_subdev_link_validate_get_format(struct media_pad *pad,
>  		return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
>  	}
>  
> -	WARN(pad->entity->type != MEDIA_ENT_T_DEVNODE_V4L,
> +	WARN(pad->entity->type != MEDIA_ENT_T_AV_DMA,
>  	     "Driver bug! Wrong media entity type 0x%08x, entity %s\n",
>  	     pad->entity->type, pad->entity->name);
>  
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 775c11c6b173..a7aa2aac9c23 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -44,12 +44,12 @@ struct media_device_info {
>  
>  /* Used values for media_entity_desc::type */
>  
> -#define MEDIA_ENT_T_DEVNODE_V4L		(((1 << 16)) + 1)
> -#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_DEVNODE_V4L + 3)
> -#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_DEVNODE_V4L + 4)
> -#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_DEVNODE_V4L + 5)
> -#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_DEVNODE_V4L + 6)
> -#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_DEVNODE_V4L + 7)
> +#define MEDIA_ENT_T_AV_DMA		(((1 << 16)) + 1)
> +#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_AV_DMA + 3)
> +#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_AV_DMA + 4)
> +#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_AV_DMA + 5)
> +#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_AV_DMA + 6)
> +#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_AV_DMA + 7)
>  
>  #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	((2 << 16) + 1)
>  #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV_SENSOR + 1)
> 

