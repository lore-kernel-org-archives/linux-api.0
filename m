From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 03/18] media controller: use MEDIA_ENT_T_AV_DMA for A/V
 DMA engines
Date: Fri, 8 May 2015 09:32:39 -0300
Message-ID: <20150508093239.28644ad4@recife.lan>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
	<afb84e3d80fc4f6f2465a123012f161b8c29f1c4.1431046915.git.mchehab@osg.samsung.com>
	<554CA3DF.9030700@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <554CA3DF.9030700@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Hyun Kwon <hyun.kwon@xilinx.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Michal Simek <michal.simek@xilinx.com>, =?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>, Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>, Markus Elfring <elfring@users.sourceforge.net>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Em Fri, 08 May 2015 13:54:07 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> > At the Video4Linux API, the /dev/video?, /dev/vbi? and
> > /dev/radio? device nodes are used for the chipset that

I knew that this patch would cause some discussions ;)

> 
> You should add /dev/swradio? for SDR devices.

I will.

> 
> > provides the bridge between video/radio streams and the
> > USB, PCI or CPU buses.
> > 
> > Such bridge is also typically used to control the V4L2 device
> > as a hole.
> 
> hole -> whole

Ok.

> > 
> > For video streaming devices and SDR radio devices, they're
> > also associated with the DMA engines that transfer the
> > video stream (or SDR stream) to the CPU's memory.
> > 
> > It should be noticed, however, this is not true on non-SDR
> > radio devices,
> 
> I think you forgot that SDR devices are not using /dev/radio
> but /dev/swradio.

Yeah, true. I forgot that, in the end of the day, we used a
different naming for SDR radio devnodes. I'll fix the comments.

> They have different names. Radio devices never
> stream (OK, I think there are one or two exceptions, but that's really
> because nobody bothered to make an alsa driver. Those boards are
> in practice out of spec.)

Yes, I know.

> > and may also not be true on embedded devices
> > that, due to DRM reasons, don't allow writing unencrypted
> > data on a memory that could be seen by the CPU.
> 
> This actually might still work by using opaque DMABUF handles. But that's
> under discussion right now in the Secure Data Path thread.

Well, a DMABUF opaque handler like that actually refers to either a
buffer that is shared only between 2 devices or to a device-to-device
DMA transfer.

Such dataflow is different than the usual meaning of the video devnode,
where the devnode is used to do I/O transfers. So, it may actually 
be mapped as a different type of entity.

We'll need to discuss further when we start mapping this via MC.

> Another reason can also be that the SoC vendor re-invented the wheel
> and made there own DMA streaming solution. You can still make V4L drivers
> that control the video receivers/transmitters, but for the actual streaming
> you are forced to use the vendor's crap code (hello TI!).
> 
> I've bitter experiences with that :-(
>  
> > So, we'll eventually need to add another entity for such
> > bridge chipsets that have a video/vbi/radio device node
> > associated, but don't have DMA engines on (some) devnodes.
> > 
> > As, currently, we don't have any such case,
> 
> ??? Radio devices are exactly that.

I actually meant to say:

	"As, currently, no driver uses Media Controller on such cases,"

> > let's for now
> > just rename the device nodes that are associated with a
> > DMA engine as MEDIA_ENT_T_AV_DMA.
> > 
> > So,
> > 	MEDIA_ENT_T_DEVNODE_V4L -> MEDIA_ENT_T_AV_DMA
> > 
> > PS.: This is not actually true for USB devices, as the
> > DMA engine is an internal component, as it is up to the
> > Kernel to strip the stream payload from the URB packages.
> 
> How about MEDIA_ENT_T_DATA_STREAMING? Or perhaps DATA_IO? Perhaps even just
> "IO"?

Almost entities do I/O and data streaming (exceptions are flash controller,
SEC and similar control subdevices). So, DATA_STREAMING, DATA_IO or IO
are a way too generic.

DMA is a little bit more restrictive than we wanted.

Actually, I originally named those as MEDIA_ENT_T_AV_BRIDGE, because
the hardware component that implements the device->CPU I/O is typically
a bridge. But then I went into the drivers, and I noticed that several
devices with just one bridge have several different entities for I/O.

So, I ran this script:
	$ git filter-branch -f --msg-filter 'cat && sed s,MEDIA_ENT_T_AV_BRIDGE,MEDIA_ENT_T_AV_DMA,g' origin/patchwork..
	$ git filter-branch -f --tree-filter 'for i in $(git grep -l MEDIA_ENT_T_AV_BRIDGE); do sed s,MEDIA_ENT_T_AV_BRIDGE,MEDIA_ENT_T_AV_DMA,g $i >a && mv a $i; done' origin/patchwork..

To replace the name everywere. Provided that we decide a better name,
this can be easily fixable by doing the above scripting.

Perhaps MEDIA_ENT_T_DEV_CPU_AV_IO would be a better name?

> That would cover USB as well, and I dislike the use of "AV", since the
> data might contain other things besides audio and/or video.

True, but how to distinguish such device from an ALSA DEV/CPU IO?

Answering myself, I see one alternative for that... we could use
MEDIA_ENT_T_DEV_CPU_IO for all device->CPU I/O devices, and use
properties to tell what APIs are valid on such entity. The bad thing
is that someone could add multiple "incompatible" APIs at the same
device (like ALSA, V4L and DVB - all on the dame sevnode).

I'm running out of ideas here ;)

In the lack of a better name, I would keep MEDIA_ENT_T_AV_DMA, as
it is the closest one to what's provided by such entities (or the
less wrong one).


Regards,
Mauro
