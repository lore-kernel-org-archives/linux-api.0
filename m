From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 07/18] media controller: rename the tuner entity
Date: Fri, 8 May 2015 12:46:29 -0300
Message-ID: <20150508124629.4e00c9a3@recife.lan>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
	<6d88ece22cbbbaa72bbddb8b152b0d62728d6129.1431046915.git.mchehab@osg.samsung.com>
	<554CA862.8070407@xs4all.nl>
	<20150508095754.1c39a276@recife.lan>
	<554CB863.1040006@xs4all.nl>
	<20150508110826.00e4e954@recife.lan>
	<554CC8E3.2030308@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <554CC8E3.2030308@xs4all.nl>
Sender: linux-doc-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Matthias Schwarzott <zzam@gentoo.org>, Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>, Prabhakar Lad <prabhakar.csengg@gmail.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Em Fri, 08 May 2015 16:32:03 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 05/08/2015 04:08 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 08 May 2015 15:21:39 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> On 05/08/2015 02:57 PM, Mauro Carvalho Chehab wrote:
> >>> Em Fri, 08 May 2015 14:13:22 +0200
> >>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>
> >>>> On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> >>>>> Finally, let's rename the tuner entity. inside the media subsystem,
> >>>>> a tuner can be used by AM/FM radio, SDR radio, analog TV and digital TV.
> >>>>> It could even be used on other subsystems, like network, for wireless
> >>>>> devices.
> >>>>>
> >>>>> So, it is not constricted to V4L2 API, or to a subdev.
> >>>>>
> >>>>> Let's then rename it as:
> >>>>> 	MEDIA_ENT_T_V4L2_SUBDEV_TUNER -> MEDIA_ENT_T_TUNER
> >>>>
> >>>> See patch 04/18.
> >>>
> >>> Mapping the tuner as a V4L2_SUBDEV is plain wrong. We can't assume
> >>> that a tuner will always be mapped via V4L2 subdev API.
> >>
> >> True. Today we have subdevs that have no device node to control them, so
> >> in that case it would just be a SUBDEV entity. There are subdevs that make
> >> a v4l-subdev device node, so those can be V4L(2)_SUBDEV entities.
> >>
> >> The question is: what are your ideas for e.g. DVB-only tuners? Would they
> >> get a DVB-like device node? (so DTV_SUBDEV)
> > 
> > I guess we may need DVB subdevs in the future. For now, I don't see
> > much usage.
> > 
> >> Would hybrid tuners have two
> >> device nodes? One v4l-subdev, one dvb/dtv-subdev?
> > 
> > No. A tuner is a tuner. The very same device can be used for analog or
> > digital TV. Ok, there are tuners that only work for digital TV (satellite
> > tuners, typically), because satellite requires a different tuning range,
> > and require an extra hardware to power up the satellite antena. So, on
> > most devices, the tuner is integrated with SEC.
> > 
> > In any case, I don't see any reason why artificially one piece of hardware
> > component (tuner) into one subdevice entity per API.
> > 
> > What it might make sense in the future is to have some DVB-specific ioctls
> > for a hybrid tuner,  in order to allow adjusting its internal filters to
> > an specific digital TV standard.
> > 
> >> Just curious what your thoughts are.
> >>
> >> Brainstorming:
> >>
> >> It might be better to map each device node to an entity and each hardware
> >> component (tuner, DMA engine) to an entity, and avoid this mixing of
> >> hw entity vs device node entity.
> > 
> > Ok, but then we need to properly define the namespaces for HW and for
> > Linux API components.
> > 
> > So, we would have a namespace like:
> >  
> > 	- ENT_T_DEVNODE_DVB_(FE|CA|NET|DEMUX|DVR) for the DVB API device nodes;
> > 	- ENT_T_DEVNODE_V4L for the radio/swradio/video/vbi devnodes, or,
> > alternatively, use ENT_T_DEVNODE_V4L_(RADIO|SWRADIO|VIDEO|VBI);
> > 	- ENT_T_HW_(TUNER|CAM_SENSOR|ATV_DEMOD|DTV_DEMOD|...) for the
> > hardware components.
> > 
> > In other words, the namespace would actually define two subtypes:
> > 	- devnodes;
> > 	- hardware components
> > 
> > There's one advantage on this strategy: it is easier to keep backward
> > compatibility, IMHO, as we'll be preserving 1 << 16 for device nodes
> 
> Right, that will work.
> 
> > and 2 << 16 for hardware components.
> 
> This remains problematic since I believe this should be done as a list
> of properties. Instead the entity type would be ENT_T_HW (if it represents
> actual hardware), ENT_T_SW (if it is a software implementation, for example
> for the DVB demux if there is no HW demux), and perhaps ENT_T_IP for
> representing IP blocks (not sure about this one).

I don't think we should distinguish IP block from HW. I would also use
a different namespace for SW implementation like the DVB demux or
for API devnodes.

Perhaps:
	ENT_T_API - for non-subdev API device nodes;
	ENT_T_HW - for hardware/firmware/IP blocks;
	ENT_T_SW - for software emulation blocks like DVB demux

I would not map subdev API as a separate entity, as those should have
a 1:1 map to the entity. So, a property (or a flag) should be enough
to indicate that either a ENT_T_HW_ or a ENT_T_SW_ is exposed via a
subdev.

With regards to the API mapping, I would have a set of properties that
would be grouping V4L2, subdev, DVB, ... parts of the API.

So, for example, if the entity that represents a video devnode
controls the tuner, the analog demod and the DMA engine, such
entity would have 3 properties:
	- ENT_PROP_V4L2_TUNER
	- ENT_PROP_V4L2_ATV_DEMOD
	- ENT_PROP_V4L2_DMA

> And the properties will tell what functions it supports.

Yes, but, as the API right now groups the subtypes, it would
be better to keep it splitted, not for userspace to use this as
subtype. Just as a matter of keeping things well organized.

I mean, if you take a look at the resulting namespace after all
those patches I wrote, the end result is:

#define MEDIA_ENT_T_UNKNOWN	0

#define MEDIA_ENT_T_AV_DMA		(((1 << 16)) + 1)
#define MEDIA_ENT_T_DTV_DEMOD	(MEDIA_ENT_T_AV_DMA + 3)
#define MEDIA_ENT_T_DTV_DEMUX	(MEDIA_ENT_T_AV_DMA + 4)
#define MEDIA_ENT_T_DTV_DVR	(MEDIA_ENT_T_AV_DMA + 5)
#define MEDIA_ENT_T_DTV_CA	(MEDIA_ENT_T_AV_DMA + 6)
#define MEDIA_ENT_T_DTV_NET	(MEDIA_ENT_T_AV_DMA + 7)

#define MEDIA_ENT_T_CAM_SENSOR	((2 << 16) + 1)
#define MEDIA_ENT_T_CAM_FLASH	(MEDIA_ENT_T_CAM_SENSOR + 1)
#define MEDIA_ENT_T_CAM_LENS	(MEDIA_ENT_T_CAM_SENSOR + 2)
#define MEDIA_ENT_T_ATV_DECODER	(MEDIA_ENT_T_CAM_SENSOR + 3)
#define MEDIA_ENT_T_TUNER	(MEDIA_ENT_T_CAM_SENSOR + 4)

We cannot renumber them, or otherwise things will break. So, we'll have
to deal with at least 2 number spaces: 1 << 16 and 2 << 16.

If we use the 1<<16 number space for ENT_T_API and the 2<<16 for
ENT_T_HW, the above will keep fitting, and it will be easier to maintain,
as we'll be grouping by name.

> The existing 2 << 16 defines would only be used if the property list matches
> the original meaning of the define to keep it backwards compatible.
> 
> > 
> > Yet, we'll need to add an entity for the V4L2 hardware DMA (with makes
> > sense to me), and this might break backward compatibility if not done
> > well.
> 
> I see this as a property as well, but otherwise I agree with this.

Yes, this could be a property.

> > 
> > It should be said that, in such case, hardware components will then
> > mean not only V4L2-specific hardware (V4L2_SUBDEV_foo), but also DVB,
> > ALSA, ... components.
> > 
> > So, we'll still need a way to identify what of those components are
> > V4L2 subdevs, probably using the properties API.
> 
> Why? A hardware component that can be controlled via a v4l-subdev node
> would be linked to an entity for that v4l-subdev node. That's an API
> entity. The whole 'is this a v4l-subdev' question disappears, since that
> is now no longer relevant. Instead you will have an ENT_T_DEVNODE_V4L_SUBDEV
> entity linked to the hw entity.

I see V4L_SUBDEV as a set of properties, specifying exactly what group
of subdev ioctls controls an specific hardware entity.

> Even a radio device would fit cleanly into this: the tuner entity simply
> has a link to a radio device node entity.

Yes.

> Hmm, does this also solve the control vs DMA issue? If a DEVNODE entity
> is hooked up to an entity with the DMA functionality, then you can stream,
> otherwise it is just for control.

Probably yes.

> I'm not sure if this is always true, though. Of course, we can also just
> add the streaming/dma property to the DEVNODE entity as well.
> 
> > If you all agree with that, I'll respin the patch series to map the
> > entities like that.
> 
> We can interpret the existing ENT_T_HW_TUNER etc. as shorthand for a
> property while the property API isn't there yet (we need that anyway
> for backwards compat).

I do prefer using a switch() like I did on patch 10/18, specifying the
entities that belong to subdev. After we add the property API, we can
convert is_media_entity_v4l2_subdev and is_media_entity_av_dma (with
should likely be renamed to is_media_entity_v4l_dma) to use the
properties API.

I don't think we'll need to create a separate number space for the new
entities in order to be backward-compatible.

> 
> So we would need to add a ENT_T_HW_DMA as well (to be replaced by a
> property later).

Let's add this directly when we add the Property API.

> Basically I see the 1 << 16 range as device node types, the 2 << 16 range
> as shorthands for what should be properties (this really defined functions
> and entities can combine multiple functions), and we would need to have a
> new range (4 << 16) for non-DEVNODE entity types. Although we could keep
> it in range 1 << 16 as well, but I think it might make sense to keep it
> separate.

Keeping a backward-compatible separate range would create messy graphs.
I don't think we should do it.

> 
> And there you would get ENT_T_HW/SW/IP (not sure about the last one). And
> perhaps FPGA.
> 
> Again, just brainstorming here.
> 
> Regards,
> 
> 	Hans
