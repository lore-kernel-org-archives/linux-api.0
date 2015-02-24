From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 1/3] media: Fix ALSA and DVB representation at media
 controller API
Date: Tue, 24 Feb 2015 00:51:30 -0300
Message-ID: <20150224005130.2e7e724c@recife.lan>
References: <cover.1422273497.git.mchehab@osg.samsung.com>
	<20150126113416.311fb376@recife.lan>
	<54C64421.1030302@xs4all.nl>
	<2131864.KjrDFSJfqE@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <2131864.KjrDFSJfqE@avalon>
Sender: linux-media-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Hans Verkuil <hans.verkuil@cisco.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>, Ricardo Ribalda <ricardo.ribalda@gmail.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Em Tue, 24 Feb 2015 00:58:23 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro and Hans,
> 
> On Monday 26 January 2015 14:41:53 Hans Verkuil wrote:
> > On 01/26/2015 02:34 PM, Mauro Carvalho Chehab wrote:
> > > Em Mon, 26 Jan 2015 14:11:50 +0100 Hans Verkuil escreveu:
> > >> On 01/26/2015 01:47 PM, Mauro Carvalho Chehab wrote:
> > >>> The previous provision for DVB media controller support were to
> > >>> define an ID (likely meaning the adapter number) for the DVB
> > >>> devnodes.
> > >>> 
> > >>> This is just plain wrong. Just like V4L, DVB devices (and ALSA,
> > >>> or whatever) are identified via a (major, minor) tuple.
> > >>> 
> > >>> This is enough to uniquely identify a devnode, no matter what
> > >>> API it implements.
> > >>> 
> > >>> So, before we go too far, let's mark the old v4l, dvb and alsa
> > >>> "devnode" info as deprecated, and just call it as "dev".
> > >>> 
> > >>> As we don't want to break compilation on already existing apps,
> > >>> let's just keep the old definitions as-is, adding a note that
> > >>> those are deprecated at media-entity.h.
> > >>> 
> > >>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> [snip]
> 
> > >>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > >>> index e00459185d20..d6d74bcfe183 100644
> > >>> --- a/include/media/media-entity.h
> > >>> +++ b/include/media/media-entity.h
> > >>> @@ -87,17 +87,7 @@ struct media_entity {
> > >>>  		struct {
> > >>>  			u32 major;
> > >>>  			u32 minor;
> > >>> -		} v4l;
> > >>> -		struct {
> > >>> -			u32 major;
> > >>> -			u32 minor;
> > >>> -		} fb;
> > >>> -		struct {
> > >>> -			u32 card;
> > >>> -			u32 device;
> > >>> -			u32 subdevice;
> > >>> -		} alsa;
> > >> 
> > >> I don't think the alsa entity information can be replaced by major/minor.
> > >> In particular you will loose the subdevice information which you need as
> > >> well. In addition, alsa devices are almost never referenced via major and
> > >> minor numbers, but always by card/device/subdevice numbers.
> > > 
> > > For media-ctl, it is easier to handle major/minor, in order to identify
> > > the associated devnode name. Btw, media-ctl currently assumes that all
> > > devnode devices are specified by v4l.major/v4l.minor.
> > > 
> > > Ok, maybe for alsa we'll need also card/device/subdevice, but I think this
> > > should be mapped elsewhere, if this can't be retrieved via its sysfs/udev
> > > interface (with seems to be doubtful).
> > 
> > The card/device tuple can likely be mapped to major/minor, but not
> > subdevice. And since everything inside alsa is based on card/device I
> > wouldn't change that.
> 
> I think we'll likely need changes for ALSA, but I don't think we know which 
> ones yet. For that reason I'd avoid creating any ALSA-specific API for now 
> until we implement proper support for ALSA devices. I'm fine, however, with 
> deprecating the ALSA API we have now, before it gets (ab)used.

That's my opinion too: deprecate it before it gets (ab)used.

> 
> > >>> -		int dvb;
> > >>> +		} dev;
> > >>> 
> > >>>  		/* Sub-device specifications */
> > >>>  		/* Nothing needed yet */
> > >>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > >>> index d847c760e8f0..418f4fec391a 100644
> > >>> --- a/include/uapi/linux/media.h
> > >>> +++ b/include/uapi/linux/media.h
> > >>> @@ -78,6 +78,20 @@ struct media_entity_desc {
> > >>>  		struct {
> > >>>  			__u32 major;
> > >>>  			__u32 minor;
> > >>> +		} dev;
> > >>> +
> > >>> +#if 1
> > >>> +		/*
> > >>> +		 * DEPRECATED: previous node specifications. Kept just to
> > >>> +		 * avoid breaking compilation, but media_entity_desc.dev
> > >>> +		 * should be used instead. In particular, alsa and dvb
> > >>> +		 * fields below are wrong: for all devnodes, there should
> > >>> +		 * be just major/minor inside the struct, as this is enough
> > >>> +		 * to represent any devnode, no matter what type.
> > >>> +		 */
> > >>> +		struct {
> > >>> +			__u32 major;
> > >>> +			__u32 minor;
> > >>>  		} v4l;
> > >>>  		struct {
> > >>>  			__u32 major;
> > >>> @@ -89,6 +103,7 @@ struct media_entity_desc {
> > >>>  			__u32 subdevice;
> > >>>  		} alsa;
> > >>>  		int dvb;
> > >> 
> > >> I wouldn't merge all the v4l/fb/etc. structs into one struct. That will
> > >> make it difficult in the future if you need to add a field for e.g. v4l
> > >> entities.
> 
> This is something Hans and I have discussed at the FOSDEM, and ended up 
> disagreeing.
> 
> I like the single struct dev here, but I believe it should be moved before the 
> union, or, as Hans proposed, that the reserved bytes should be moved after the 
> union. However, the reason why I like your proposal has probably nothing to do 
> with your intents.

We can't move it before the union, as it would otherwise break userspace.
The union should contain both the new name and the legacy ones.

Moving the reserved fields out of the union seems fine for me.

> To start directly with the big news, I believe the MC device node entity types 
> are bogus. They should never have been created in the first place, and your 
> proposal for DVB support in MC clearly shows it in my opinion.
> 
> The media controller model is supposed to describe the device hardware 
> topology, or at least a logical view of that topology mapped to the operating 
> system from a hardware point of view. Device nodes, on the other hand, are 
> purely Linux concepts, and have nothing to do with the hardware topology.

That's somewhat true, but all device nodes are the points where the hardware
can be controlled. Any userspace software that needs to control the hardware
need some way to detect the device nodes, in order to use them

> What 
> we have tried to describe with the MEDIA_ENT_T_DEVNODE_V4L entity type is 
> essentially a DMA engine. As DMA engines are mapped 1:1 to device nodes in 
> V4L2, we have mixed the two concepts and have called those entities device 
> nodes, while they should really have been called DMA engines.

As I said, it is, in practice, more than just the DMA, even for V4L2. It
is the control point of the device to where an specific API is used to
control the hardware.

Btw, calling them as DMA is a simplification. On simple devices, yes
there's a DMA directly associated with the devnode, but on devices like
USB, the DMA is actually hidden, and a piece of software at the Kernel
filters out the payload from the USB headers.

So, a devnode is actually several blocks:

	[hw control] or, eventually, [kernel control]
	[DMA] ---> [payload filter] ---> [userspace stream I/O]

> One additional clue that made me realize this is that we now have device nodes 
> for subdevs, which we don't report through the MC API. That's wrong, and 
> should be fixed.

A subdev node is actually:
	[hw control] or, eventually, [kernel control]

I agree that they should be reported via the MC API.

> We could simply consider that V4L2 subdevs, as they're V4L2 
> entities, can use the media_entity_desc v4l union and report the device node 
> major and minor there, but I think that would be a short-term solution.

> Instead, I believe we should start describing our media entities based on the 
> hardware point of view, and consider device nodes to be an entity property 
> instead of an entity identity. In other words, a V4L2 DMA engine is not a 
> device node by hardware nature, but has the property of exposing a device node 
> to userspace. The same applies to other entities, such as V4L2 subdevices or 
> DVB entities.

Well, for me a devnode has always an API associated to it, as all devnodes
allow some set of ioctls to use to control it.

So, for me, each media entity that is a devnode should have a property or
identity that will tell what API is supported there. This is so important
for userspace that I would keep using "type" for that.

Ok, some devnodes have more than just [hw control].

> I've used the word property for a reason, as we've discussed numerous times in 
> the past an MC API extension to report detailed entity properties. However, 
> considering that exposing a device node is a very common property for 
> entities, I believe it makes sense to report that information through 
> media_entity_desc instead of requiring a separate, not implemented yet ioctl.

Agreed.

> For those reasons, I believe that we should have a single struct dev in struct 
> media_entity_desc used to report the "entity exposes a device node" property. 
> This isn't linked to v4l, fb, dvb or alsa, and is independent from the entity 
> type as such, so I wouldn't describe that property with subsystem-specific 
> structures.

Agreed.

> This doesn't preclude struct media_entity_desc from exposing subsystem-
> specific information in v4l, fb, dvb or alsa structures, even though I 
> currently believe that only core properties should be exposed through that 
> structure, and subsystem-specific properties would likely not qualified, but 
> that should be decided on a case-by-case basis. The struct dev, however, isn't 
> a subsystem-specific property, and I would thus like it to be reported as 
> such. A flag could also be used to report whether the entity has a device 
> node, although that could be inferred from major:minor not being equal to 0:0.

Fully agreed.

> With the above explanation hopefully clear, I believe that the following DVB 
> entity types are wrong.
> 
> #define MEDIA_ENT_T_DEVNODE_DVB_FE      (MEDIA_ENT_T_DEVNODE + 4)
> #define MEDIA_ENT_T_DEVNODE_DVB_DEMUX   (MEDIA_ENT_T_DEVNODE + 5)
> #define MEDIA_ENT_T_DEVNODE_DVB_DVR     (MEDIA_ENT_T_DEVNODE + 6)
> #define MEDIA_ENT_T_DEVNODE_DVB_CA      (MEDIA_ENT_T_DEVNODE + 7)
> #define MEDIA_ENT_T_DEVNODE_DVB_NET     (MEDIA_ENT_T_DEVNODE + 8)
> 
> We should get rid of DEVNODE_ there.

I'm fine with such change.

> Let's take http://linuxtv.org/downloads/presentations/cx231xx.ps as an 
> example. If I understand it correctly, the frontend has a dedicated device 
> node for control purposes (it has no DMA engine, no data can be transferred 
> through that device node), while the demux and dvr have DMA engines. The demux 
> can pass data to the dvr DMA engine, and also capture "raw" data directly. 
> Please correct me if that's not correct.

Well, this is actually a simplification. It works fine for now, but
we'll need to go deeper in some future to properly describe the DVB
pipeline.

The frontend is actually composed of two parts:
	- A tuner;
	- A digital TV demodulator.

(On some devices, it is impossible to distinguish between them,
as the tuner is controlled by the firmware inside the demod)

The demodulator has a serial or parallel bus that either sends
the data to a hardware demux or sends it to the Kernel via DMA.

In the first case, the diagram is:

	[tuner] ---> [demod] --> [hw demux] --> [DMA] --> Kernel --> userspace (either via dmx or dvr devnode)

In the second case, it is:

	[tuner] ---> [demod] --> [DMA] --> Kernel --> [sw demux in Kernel] --> userspace (either via dmx or dvr devnode)

The DMA is thus hidden in the middle of the pipeline.

For userspace, it doesn't matter if the hardware has or not a demux.
The logic is that the DVB Demux API is used to set a filter at the
demux.

The demux filter will select the packet IDs (PID) that userspace
wants from the MPEG-TS stream, and either dynamically wire the hardware
to send the selected program via DMA (for hardware demux) or it will
program the Kernel to filter it in kernelspace.

Btw, the above diagrams are for PC typical hardware. For Set Top Boxes
and TV sets, in order to meet DRM (Digital Rights Management)
requirements at the DVB specs, they may not have any DMA engine. In
such case, the demuxed video should be passed to a CA module (CAM), that
handles the decrypt, and then the output should go to the video adapter
for display.

So, the diagram would be something like:

	[tuner] ---> [demod] --> [hw demux] --> [CAM] --> [/dev/fb0]

In such case, all device nodes are just for hardware control.

To make things a little worse, it is not [hw demux] but, actually
[hw demux filter #0] ... [[hw demux filter #n].

A typical PC hardware with hw demux implements something like 32 filters.

A TV set hardware supports a way more filters and some can even have
dynamically created filters that can be shared between different DVB adapters.

> The frontend should in my opinion be represented as a green box, not a yellow 
> box, as it's a processing entity and not a DMA engine. It should, however, 
> expose its device node property through struct dev.

I see your point.

> The dvr, on the other side, is a DMA engine, for which a yellow box is thus 
> correct. Its device node used for data transmission (and I suppose also some 
> DMA-related configuration) should also be exposed through struct dev.

A dvr interface is always associated with the stream output to userspace.

> 
> The demux is, if my understanding is correct, a hybrid beast, with both 
> processing and DMA capabilities.

Yes. it is hw/sw control and can be stream output too.

> I lack proper DVB knowledge here, but based 
> on what I understand it might make sense to split it in two entities, one to 
> handle the data processing capability, and the other one to handle the DMA 
> engine. The processing entity could have one sink pad and two source pads, one 
> connected to the dvr and the other one connected to the demux DMA engine 
> entity.

Actually, the processing unity can have one sink pad with the TS input, and
a dynamically created number of PADs, one for each filter.

Please notice that a filter is associated with a file descriptor, and not
with a devnode.

So, from devnode perspective, we have:

	/dev/adapter0/frontend0 - to control the tuner/demod
	/dev/adapter0/demux0 - to create the filters
	/dev/adapter0/dvr0 - to receive the data
	/dev/adapter0/ca0 - to control data decrypt

but, from the data flux, we have:

	frontend0 -> demux0 input pad

	demux0 output pad filter 0 --> DMA --> dvr0 fd 5 
	demux0 output pad filter 1 --> DMA --> dvr0 fd 6
	demux0 output pad filter 2 --> DMA --> dvr0 fd 7
	demux0 output pad filter 3 --> ca0 --> DMA --> dvr0 fd 8
	demux0 output pad filter 4 --> /dev/fb0
	...

So, what we're really mapping right now is the hardware/software
control points associated with the device nodes. So, the way I see
is that we'll still need to represent at the media controller
the device nodes as such, as this is the point where the hardware
(and the Kernel) can be controlled.

The data flux can be simplified as we're doing right now, but we'll
need to add more features at the media controller (and to better
discuss) how to implement the DVB data flux.

In other words, for DVB, we'll need to represent:

- all devnodes used to control the DVB API (that's the goal of the
  current patchset);

- the demux processing unit with their filter outputs and the userspace
  file descriptors. I intend to discuss this further during the
  Media summit, and should be object of another set of patches.

> This model departs from your proposal, but I think it would be a better base 
> for future developments, for DVB but also other subsystems.
> 
> > > No. You could just create another union for the API-specific bits, using
> > > the reserved bytes.
> > > 
> > >> So I would keep the v4l, fb and alsa structs, and just add a new struct
> > >> for dvb. I wonder if the dvb field can't just be replaced since I doubt
> > >> anyone is using it. And even if someone does, then it can't be right
> > >> since a single int isn't enough and never worked anyway.
> > > 
> > > All devnodes have major/minor. Making it standard for all devices makes
> > > easy for userspace to properly get the data it requires to work.
> > 
> > I think you are making assumptions here that may not be true. I don't see
> > any reason to make a 'dev' struct here. The real problem is the dvb int, so
> > that's what needs to be addressed. Changing anything else will cause API
> > headaches for no good reason.
> 
