From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [RFC] Media Controller, the next generation
Date: Mon, 17 Aug 2015 09:39:23 -0300
Message-ID: <20150817093923.301ac60b@recife.lan>
References: <55BF75B4.2060301@xs4all.nl>
	<1553545.72YdKh14yc@avalon>
	<20150816103709.444d59c1@recife.lan>
	<55D1B87A.7010107@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <55D1B87A.7010107@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Em Mon, 17 Aug 2015 12:33:30 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/16/2015 03:37 PM, Mauro Carvalho Chehab wrote:
> > Em Sat, 15 Aug 2015 21:25:40 +0300
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> > 
> >> Hi Hans,
> >>
> >> Thank you for the RFC. I believe it's quite good (at least to my eyes). 
> >> Everything is of course not perfect yet so please see below for some comments.
> > 
> > (added c/c linux-api@vger.kernel.org)
> > 
> >>
> >> On Monday 03 August 2015 16:07:48 Hans Verkuil wrote:
> >>> Hi all,
> >>>
> >>> During last week's brainstorm meeting in Espoo, Finland, we discussed
> >>> how to proceed with the MC API. Trying to apply the existing API to DVB
> >>> devices caused a lot of controversy and this meeting was an attempt to
> >>> resolve these issues.
> >>>
> >>> This RFC is the proposal for the public API (NOT the internal API!) we
> >>> came up with.
> >>>
> >>> The main change is that interfaces (such as devices in /dev) get their own
> >>> object: struct media_interface. The struct media_entity as is used today
> >>> will not refer to interfaces anymore.
> >>>
> >>> Since interfaces control entities we also want to tell userspace which
> >>> entities are controlled by which interfaces. We want to keep things simple
> >>> and avoid having to create a new link structure just for this,
> > 
> > I agree with the Hans proposal. Having a single object to represent graph
> > links makes easier for both Kernelspace and Userspace to handle them.
> 
> Right.
> 
> >> During the meeting we discussed the possibility of creating a 
> >> media_interface_link structure (as drafted in 
> >> http://linuxtv.org/downloads/presentations/mc_ws_2015/media.h). What would be 
> >> the advantage of reusing media_link ?
> > 
> > I would reverse the question: what's the disadvantage?
> > 
> > By using the same type, it should be easier to change userspace programs
> > to support both interface and data links.
> > 
> > With a single struct, if/when apps need to do graph traversal, they can
> > use a single algorithm. It also means a single code to allocate and
> > fetch the structs that come from the Kernel.
> 
> Also, since all graph objects (interfaces, entities, pads) all use the same
> base struct (media_graph_obj) it makes sense that we use the same media_link
> struct for linking two graph objects.
> 
> >>> so instead a struct media_link just provides two object IDs and a flags
> >>> field. The object IDs refer to pads (for data links) or entity/interface IDs
> >>> (for associating interfaces with entities).
> >>>
> >>> To make this work we need unique pad IDs.
> >>>
> >>> We will need to represent connectors as well. The media_entity struct is
> >>> used for that, but it will be marked as a connector since connectors work
> >>> slightly different from an entity: if an entity has both input and output
> >>> pads, then that means that the entity processes the input data in some way
> >>> before passing it on to the output pads. But for a connector the input and
> >>> output pads are just hooked up to input and output pins or buses and not
> >>> to one another.
> >>>
> >>> Finally we would like to get all this information atomically in userspace.
> >>> Atomicity is desired since some of this information well be dynamic.
> >>> Currently the only dynamic thing is enabling/disabling links, but that is
> >>> too limiting for devices like FPGAs where the entities can change on the
> >>> fly as well.
> >>>
> >>> Being able to get all the information with a single ioctl will simplify
> >>> implementing this atomic behavior, and it is also more efficient than
> >>> calling lots of ENUM ioctls.
> >>>
> >>> We decided to keep the existing structs and ioctls and introduce new
> >>> versions of these structs redesigned to cope with the new insights. The
> >>> sizes of the reserved fields are suggestions only.
> >>>
> >>> We had a discussion about the object IDs. Currently we have only entity IDs,
> >>> but in the redesign we'll have interface, connector and pad IDs as well.
> >>
> >> As connectors are entities I don't think they deserve a special mention here. 
> > 
> > Hans proposal is to use a different type for connectors. So, I guess it
> > makes sense to keep the mention.
> 
> There is a difference in how connector entities behave (e.g. input pads are
> not connected to output pads, instead they represent pins on the connector) and
> how connector entities are used (V4L2 drivers might want to enumerate connector
> entities to implement VIDIOC_ENUMINPUT).
> 
> So giving them their own distinct type makes sense to me.
> 
> >> Regarding pad IDs, is there a reason to give pads IDs in the global ID space 
> >> other than reusing media_link ?
> > 
> > I actually have another usage for that ;)
> > 
> > I'll comment that below.
> > 
> >>
> >>> The idea from the meeting was to use the least significant X bits of the ID
> >>> to tell the difference of entity, interface and pad types and to use a flag
> >>> for marking connector entities. After thinking some more I would suggest
> >>> this scheme instead:
> >>>
> >>> #define MEDIA_ID_T_ENTITY 		0
> >>> #define MEDIA_ID_T_CONNECTOR 		1
> >>> #define MEDIA_ID_T_INTERFACE 		2
> >>> #define MEDIA_ID_T_PAD 			3
> > 
> > My suggestion is actually that we should have one type for every possible
> > graph object. So, I would also add a MEDIA_ID_T_LINK, in order to represent
> > the links.
> > 
> > Btw, I think that we'll end by needing a MEDIA_ID_T_GROUP too, in order
> > to properly replace the group ID, of course assuming that we keep needing
> > to have groups of objects. 
> > 
> > My idea, if we ever need a MEDIA_ID_T_GROUP is to represent a group as an
> > object that contains a list of other objects: entities, interfaces, links,
> > pads, etc.
> > 
> > At the userspace interface, the group will pass just the object IDs for
> > the objects that belong to such group, plus group name (and maybe flags).
> > 
> > This proposal still need discussions. The most important one is: do we need
> > groups on userspace? So, I would not cover groups on this RFC yet, but it
> > would be great if the API we're writing could latter be extended to support
> > groups.
> > 
> > Internally, at the Kernel, groups make sense, specially when different
> > drivers are handling the same MC graph.
> > 
> > For example, let's imagine a pipeline with ALSA, V4L, DVB and DRM entities
> > inside. It makes sense for the ALSA snd-audio-usb driver to group
> > all ALSA-related objects. The same is true for the DVB core and for
> > the V4L2 and DRM drivers/core.
> > 
> > So, that's another reason why I think we should have an unique object
> > ID for the links too: it makes easier to group them.
> 
> Note that this usage of 'group' is quite different from what the group ID
> was intended for: that was to group entities relating to the same HW device
> (e.g. group the sensor and flash together so it is clear which flash entity
> belongs to which sensor).

I know, but using a media group object, it is still possible to group sensor
and flash together too.

> My understanding is that today no in-kernel driver uses the group ID, and I
> am very skeptical about the whole concept. I think this can be much better
> described using properties.

Yeah, group ID should be removed. linking sensor/flash together could be
done using properties.

Yet, grouping analog part, digital part and alsa part of the graph
are better handled via a new graph entity to represent the groups.
I'm pretty sure we'll need it inside Kernelspace. On userspace,
I'm not so sure. Well, it could be useful, for example to generate
a dot subgraph. It could also be useful if different userspace programs
are controlling different parts of the graph (like one app for the ALSA
pipelines, another for the DRM ones, etc).

> I have no objection against a MEDIA_ID_T_LINK, but this whole group concept
> should be ignored for now and internally we should remove the group ID
> completely.
> 
> The big problem I see in general with a 'group' concept is that it is
> awfully vague. Let's just table this for now and revisit when there is a
> clear need for it.

I'm afraid that this will soon be needed in Kernelspace, in order to do
the right whing when, for example, the ALSA driver gets unbind and would
need to remove just the ALSA-related objects.

It seems easier to just store all alsa-related objects into a list and
then remove them at unbind. The same is true, of course, for other
drivers that could be unbind while leaving other objects of the media
controller enabled.

> > 
> >>>
> >>> #define MEDIA_ID_TYPE(id)		((id) >> 24)
> >>> #define MEDIA_ID_VAL(id)		((id) & 0xffffff)
> >>> #define MEDIA_ID_CREATE(type, id)	(((type) << 24) | id)
> >>>
> >>> One objection was that the IDs would be unwieldy for users when using e.g.
> >>> media-ctl since you'll get IDs >= 0x1000000. However, I think that media-ctl
> >>> can easily either deduce the type (i.e. setting up the data path would
> >>> always assume type 'pad' or require that the user specifies the type and ID
> >>> value (i.e. only the lowest 24 bits).
> >>
> >> What would be the advantage of that scheme compared to having a type field and 
> >> an id field ?
> >>
> >> The proposal makes MEDIA_ID_VAL(id) non-unique, Is there anything really wrong 
> >> with having a single ID space ?
> > 
> > My personal preference when I read Hans proposal were to keep the type separate
> > from the ID, but, after seeing the usage of the mdev.entity_id, I guess that
> > this proposal makes things simpler.
> 
> I agree with that.
> 
> > However, as Sakari doesn't want big numbers for IDs, in order to improve
> > human readability, userspace apps may eventually accept two ways to 
> > represent a graph obj that is being controlled:
> > 
> > 	as a global ID, e. g.something like: "0x010000000000001"
> > 	as something like "entity#1", "link#3", ...
> 
> I think this makes sense and shouldn't be a big deal at all.
> 
> > The drawback is that we limit the maximum number of types to 8 bits, and
> > the maximum ID range to 24 bits, but I don't think this is an issue.
> > 
> >>> Since MEDIA_ID_T_ENTITY == 0 this will be backwards compatible with the
> >>> existing entity IDs.
> >>
> >> There has never been any guarantee that entity IDs would be consecutive, so I 
> >> don't think that backward compatibility would be an issue with a single ID 
> >> space.
> > 
> > Well, if userspace implements the same algorithm for graph traversal as
> > the Kernelspace, e. g. using 1 << entity->id to identify loops, changing
> > this will break userspace.
> > 
> > So, I guess we're are bound to keep a consecutive range starting from 1
> > for entities.
> 
> We could reserve the range 1-63 for entities, and if we get more entities,
> then it will just use the global ID counter.
> 
> Not ideal, but it will make it safe for existing apps.
> 
> > 
> >>> Note that currently there are no unique pad IDs: adding this requires a
> >>> single change to struct media_pad_desc where one of the reserved fields is
> >>> used to export the unique pad ID. Existing apps can ignore this.
> >>>
> >>> The new media_entity_desc struct looks like this:
> >>>
> >>> struct mc_entity {
> >>> 	__u32 id;
> >>> 	__u16 num_pads;
> >>> 	__u16 reserved[13];
> >>> };
> > 
> > I would add flags here too. Not needing to read properties for some trivial
> > things that might be represented via flags sound a good thing to me.
> 
> No problem with that. I wasn't sure whether or not a flags field should be added
> since we don't need any flags for entities at the moment. 
> 
> > Also, I know that we'll keep num_pads at MC, but I would remove this
> > from the API,
> 
> Sorry, I'm confused: are you referring to the internal API or the public API?
> I assume the internal API.

I'm talking about both. Of course, we'll need a function to count them
for the legacy API, but let's not add one for the new one.

> > as, the way I'm coding it, the Kernel won't have the
> > numbe anymore, as my idea is to implement as a list at Kernelspace,
> > in order to support dynamic changes.
> > 
> > If we ever do such change, that would mean that the kernelspace
> > would need to count the number of pads just due to the a crap API.
> > 
> > Also, if userspace implements PAD as a list, it won't need it.
> > 
> > So, the "num_pads" on this new API is just an assumption that
> > either Kernel or userspace (or both) would use a certain data type.
> > 
> >>>
> >>> I'm going with mc_entity for now. An alternative name might be:
> >>> mediav2_entity or media_entity_v2 (I never liked the _desc suffix and
> >>> media_entity can't be used due to clashed with the internal media_entity
> >>> struct).
> > 
> > I think we should use different namespaces for the internal and external
> > representation. One alternative would be to rename the internal namespace
> > (for example, adding "graph_") and keep "media_" for the userspace API.
> > 
> > Anyway, I'm comfortable with whatever consistent namespace proposal.
> > 
> >>
> >> I'm not too fond of _desc either, mc_ is an interesting alternative, albeit 
> >> maybe slightly too generic.
> > 
> > Agreed.
> > 
> >>
> >>> A third alternative might be to use mc_entity for the internal data structs
> >>> and media_entity for the external.
> >>
> >> That's interesting too.
> > 
> > No, mc_entity is a bad prefix. Calling something like:
> > 	mc_entity_interface
> > is also confusing.
> 
> That's not what I meant. I meant using the mc_ prefix instead of the media_
> prefix for internal structs. So media_entity in the public API would map to
> mc_entity in the internal API. Ditto for media_interface/mc_interface,
> media_pad/mc_pad, etc.

Ah! that could work. Yet, I guess we decided to not use mc_ internally
in the first place several years ago because there was already some 
namespace conflict.

Ah, yes:

$ git grep -e \\bmc_
...
arch/powerpc/kernel/mce.c:      struct machine_check_event *mc_evt;
arch/powerpc/kernel/mce.c:              mc_evt = this_cpu_ptr(&mce_event[index]);
arch/powerpc/kernel/mce.c:                      *mce = *mc_evt;
...
arch/um/drivers/line.h: struct mc_device mc;
...
arch/um/drivers/net_kern.c:static struct mc_device net_mc = {
...

A total of 302 references... Among them, some arch-dependent stuff,
including x86 and powerPC error hanlding stuff (MCE, APEI).

I would avoid it, as the risk of namespace collisions are high.

> Using graph_ instead of mc_ is something I would be OK with as well.
> 
> > 
> > I would use something like:
> > 	media_controller_(entity|intf|pad|link|...)
> > or
> > 	media_graph_(entity|intf|pad|link|...)
> > or
> > 	media_obj_(entity|intf|pad|link|...)
> > 
> >>> As you can see, we didn't have time to discuss the naming for these new
> >>> structs. But for the purposes of this RFC I'm going with mc_ for now.
> >>>
> >>> This struct is much smaller than the original: both name and type will be
> >>> stored as properties of the entity (properties will be the topic of a
> >>> separate upcoming RFC). Pretty much everything else has been removed except
> >>> for num_pads: while even this is not strictly necessary, it was considered
> >>> to be useful to know for applications that use this API.
> > 
> > I would keep out those num_foo from the defines. The way I see is that
> > we'll end by removing the need of those counters internally, as, for dynamic
> > allocation/removal, we'll need to convert the internal data struct to lists.
> > I guess userspace apps relying on the new API will also do that too.
> > 
> > If we preserve those num_foo and convert internal data struct to lists,
> > the Kernel will need to artificially count the number of stuff just to satisfy
> > the userspace interface, on an assumption that userspace would keep using
> > arrays there instead of lists.
> 
> That's not a problem since the kernel will need to flatten the list of pads
> anyway, so adding a counter and filling that in is trivial.
> 
> > It is a bad design to write an userspace API that assumes that a particular
> > data struct will be used.
> 
> Hmm, OK. Let's try without num_foo and see if that causes any problems. It
> can always be added later.

Ok.

> >> To clarify the design principle here (and please correct me if my 
> >> understanding doesn't match yours), even though all fields could be exposed as 
> >> properties, the idea was to include core fields deemed of particular interest 
> >> for userspace in mc_entity as a kind of "shortcut".
> 
> Not really. The reason the entity name is a property is that the name can
> be quite long, which is hard to represent in a fixed struct (that's a problem
> in the current implementation), whereas it works fine as a property. The
> reason the type (i.e. 'sensor', 'flash', 'dma-engine') is a property is
> because there can be multiple types (bad name, type, but that's another story)
> for a single entity. Again, hard to do in a fixed struct, but it works well
> if these are represented as properties.

Makes sense.

> > 
> > That doesn't sound the best way to me.
> > 
> >>
> >>> The new mc_interface struct is defined as follows:
> >>>
> >>> #define MEDIA_INTF_T_DVB_FE    	(MEDIA_ENT_T_DEVNODE + 4)
> >>> #define MEDIA_INTF_T_DVB_DEMUX  (MEDIA_ENT_T_DEVNODE + 5)
> >>> #define MEDIA_INTF_T_DVB_DVR    (MEDIA_ENT_T_DEVNODE + 6)
> >>> #define MEDIA_INTF_T_DVB_CA     (MEDIA_ENT_T_DEVNODE + 7)
> >>> #define MEDIA_INTF_T_DVB_NET    (MEDIA_ENT_T_DEVNODE + 8)
> >>>
> >>> // TBC: #define MEDIA_INTF_T_NETIF_DVB    (MEDIA_ENT_T_DEVNODE + 9)
> >>>
> >>> #define MEDIA_INTF_T_V4L_VIDEO  (MEDIA_ENT_T_DEVNODE + 10)
> >>> #define MEDIA_INTF_T_V4L_VBI    (MEDIA_ENT_T_DEVNODE + 11)
> >>> #define MEDIA_INTF_T_V4L_RADIO  (MEDIA_ENT_T_DEVNODE + 12)
> >>> #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_ENT_T_DEVNODE + 13)
> >>> #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_ENT_T_DEVNODE + 14)
> >>>
> >>> #define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_ENT_T_DEVNODE + 15)
> >>> #define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_ENT_T_DEVNODE + 16)
> >>> #define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_ENT_T_DEVNODE + 17)
> >>> #define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_ENT_T_DEVNODE + 18)
> >>> #define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_ENT_T_DEVNODE + 19)
> >>> #define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_ENT_T_DEVNODE + 20)
> >>
> >> I wouldn't reuse MEDIA_ENT_T_DEVNODE in the definition of the new values as 
> >> that macro becomes deprecated. It needs to be kept for backward-compatibility 
> >> of course, but I'd rather define it in terms of the new macros than the other 
> >> way around.
> > 
> > Agreed.
> 
> No problem.
> 
> > 
> >> That's an implementation detail, it doesn't invalidate the above 
> >> list.
> >>
> >>> struct mc_interface {
> >>> 	__u32 id;
> >>> 	__u32 intf_type;
> >>
> >> Is there a particular reason to name this field intf_type instead of just type 
> >> ?
> 
> Hmm, mostly because 'type' is rather overloaded. But in this context calling it
> type would be OK, I guess.
> 
> >>
> >>> 	__u32 flags;
> >>> 	__u32 num_entity_links;
> >>> 	__u32 reserved[8];
> >>>
> >>> 	union {
> >>>         	/* Node specifications */
> >>>         	struct {
> >>>             		__u32 major;
> >>>             		__u32 minor;
> >>>         	} devnode;
> >>>
> >>> // TBC:       	struct {
> >>> //            		__s32 if_index;
> >>> //        	} netif;
> >>>
> >>>         	__u32 raw[16];
> >>>     	};
> >>> };
> > 
> > I'm actually in doubt keeping the union here or representing them via
> > properties. See more below.
> > 
> >>>
> >>> The type determines which interface it is, and additional details on how to
> >>> find the interface are in the union. This example also shows how to identify
> >>> network interfaces if we want to expose the network interfaces such as are
> >>> created by DVB.
> >>>
> >>> The num_entity_links field reports how many entities are controlled by this
> >>> interface. While not strictly necessary it is useful for applications to
> >>> know.
> >>>
> >>> There is currently only one flag: MEDIA_INTF_FL_DEFAULT (formerly
> >>> MEDIA_ENT_FL_DEFAULT). This flag tells applications whether this interface
> >>> is a default interface, i.e. the one apps should use by default. Useful
> >>> when there are e.g. multiple video interfaces.
> >>
> >> Still brainstorming here, would it make sense to have a "usage" field instead 
> >> ? I'm thinking about cases where different device nodes of the same type would 
> >> be considered as default for different use cases. For instance if you have a 
> >> TV capture card that can output two video streams, one for preview purpose in 
> >> YUV and the other one for capture purpose in MPEG, which one would be the 
> >> single default ? The answer will likely vary depending on whether users are 
> >> more interested in watching TV on their screen or recording it.
> > 
> > An "usage" property makes sense to me.
> 
> Definitely a property, not a field.
> 
> > 
> >>> The new pad struct looks like this:
> >>>
> >>> struct mc_pad {
> >>>     	__u32 id;
> >>
> >> Is this an ID as in the global pad ID discussed above, or an index local to 
> >> the entity ? I believe an index is still very useful at least inside the 
> >> kernel, and possibly in userspace as well, as pad IDs won't be stable and 
> >> couldn't be used to identify a pad in the context of its entity.
> > 
> > This should be a global ID. We'll need dynamic PADs for some usages on
> > DVB, so the ID may not be indexed.
> > 
> > Also, identifying a PAD by an index is problematic. One of the problems
> > I had when creating the V4L2 MC representation for TV devices is that
> > some entities have multiple PADs but each PAD is used to carry a different
> > type of signal.
> > 
> > For example, almost all tuners have:
> > - one output PAD with the TV IF signal;
> > - one output PAD with the audio IF signal.
> > 
> > Also, all analog TV demodulators have:
> > - one output PAD for video;
> > - one output PAD for raw Vertical Blank Interface (VBI) signal.
> > 
> > And a few demods also have a separate PAD for decoded VBI data.
> > 
> > On both cases, the output PADs are not interchangeable, and they're
> > bound to be linked to different entities or different entity pads.
> > 
> > Right now, as the PAD index is driver-specific, I had to create a
> > graph traversal function to connect the links inside the drivers,
> > as the core doesn't know what PADs index has video, audio or VBI.
> > 
> > That's problematic, specially when an independent driver like
> > snd-audio-usb needs to connect the audio PAD into the entity
> > that handles audio input samples inside it.
> > 
> > I would very much prefer to have an "usage" field at the PADs,
> 
> Please don't call it usage. Calling it 'pad_type' or possibly data_type
> will work.

No, "usage" is just due to the lack of a better name (and to avoid long
discussions about what name it should be ;)

pad_type works.

> 
> I am a bit worried about this. To my knowledge applications that use the MC
> today are expected to know which pad of an entity does what, and it identifies
> the pad by index.
> 
> The new public API should still provide applications with this information in
> one way or another. The pad ID won't work, certainly not in the dynamic case,
> the PAD_TYPE as suggested here will only work as long as there is only one
> pad per type. Suppose there is an entity with two output pads, both for video?
> One might be SDTV, one HDTV. How to tell the difference?

The first one will have "SDTV" as type, the other one "HDTV". So, no problem
with that.

There are, however, some usages where an index is enough. For example, the
hardware demux filter outputs can fully be identified by just an index, and
each index could (ideally) be mapped into a different DMA.

So, I guess we need to offer the flexibility to keep using indexes where
it makes sense.

That's why I proposed a find_pad function that would allow to use an
index:
	media_pad *find_pad(struct media_entity entity, enum pad_usage usage, int idx);
or
 	media_pad *find_pad(struct media_entity entity, char *pad_name);

> One option might be to have a pad_type or data_type for basic type information
> to have generic code that just wants to find VBI/VIDEO/AUDIO streaming pads,
> and a name[32] field that is uniquely identifying the pad and that can be used
> in userspace applications (or drivers for that matter by adding a find_pad_name()).

just a name could be enough:
	vbi_pad = find_pad(entity, "vbi");

However, that would require to have a strict namespace if we want the core
to rely on it.

> 
> > as this would allow to have core functions to create the links
> > between the entities and to enable/disable such links at streamon
> > and streamoff for most devices, avoiding code duplication.
> > 
> > In other words, I would replace the PAD index by something like:
> > 
> > 	media_pad *find_pad(struct media_entity entity, enum pad_usage usage, int idx);
> > 
> > 	vbi_pad = find_pad(entity, PAD_TYPE_VBI, 0);
> > 	video_pad = find_pad(entity, PAD_TYPE_VIDEO, 0);
> > 	audio_pad = find_pad(entity, PAD_TYPE_AUDIO, 0);
> > or
> > 	media_pad *find_pad(struct media_entity entity, char *pad_name);
> > 
> > 	vbi_pad = find_pad(entity, "vbi");
> > 	video_pad = find_pad(entity, "video");
> > 	audio_pad = find_pad(entity, "audio");
> > 
> > Such calls are driver-independent and can be used inside ALSA, DVB and
> > V4L2 core functions, solving the issue on common use cases.
> > 
> >>
> >>>     	__u32 entity_id;
> >>>     	__u32 flags;
> >>> 	__u16 num_links;
> >>> 	__u16 reserved[9];
> >>> };
> >>>
> >>> And links look like this:
> >>>
> >>> struct mc_link {
> >>>     	__u32 source_id;
> >>>     	__u32 sink_id;
> >>>     	__u32 flags;
> >>> 	__u32 reserved[5];
> >>> };
> >>>
> >>> The source/sink_id fields refer to pads (for data links) or interface
> >>> (source_id) and entity (sink_id) for the interface/entity relationships.
> >>>
> >>> While not implemented initially this will also make it possible to model
> >>> cases where one entity controls another entity. Whether we actually will
> >>> need this is uncertain, but at least it can be supported should we require
> >>> it.
> >>>
> >>> Finally we will need a way to retrieve all this information. To do this a
> >>> single struct is created:
> >>>
> >>> struct mc_topology {
> >>>     	__u32 topology_version;
> >>>     	__u32 num_entities;
> >>>     	struct mc_entity *entities;
> >>>     	__u32 num_interfaces;
> >>>     	struct mc_interface *interfaces;
> >>>     	__u32 num_pads;
> >>>     	struct mc_pad *pads;
> >>>     	__u32 num_links;
> >>>     	struct mc_link *links;
> >>> 	__u32 reserved[64];
> >>> };
> > 
> > This would work, and I can accept this, but my concern is that we'll have
> > a hard limit on extending the types of objects, given by the "reserved"
> > field.
> > 
> > So, an alternative proposal would be to replace it with something like:
> > 
> > struct media_graph_object {
> > 	u32 length;
> > 
> > 	/* Actually, we can merge those two, as proposed by Hans */
> > 	u32 type;
> > 	u32 id;
> > 
> > 	void *object_data;
> > }  __attribute__ ((packed));
> > 
> > struct media_graph_topology {
> >      	__u32 topology_version;
> > 	__u32 num_objects;
> 
> You will need a __u32 total_length here so userspace knows how much memory
> it should allocate for the objects pointer. 

True.

> You don't want userspace to call
> this ioctl three times: once to get the num_objects, then again to get the
> lengths of each objects, and a third time to get everything after allocating
> memory for each object.
> 
> Instead return the total_length and let the kernel fill in the object_data
> pointers. These object_data pointers will be awkward for the compat32 code,
> but doable.
> 
> So objects is sizeof(struct media_graph_object) * num_objects +
> sum_of(length of each object).
> 
> > 	struct media_graph_object *objects;
> 
> You also need a filter field: if I am only interested in interfaces, then
> I don't want to get the other object types.

Yes.

> Note that this will also require that properties are graph_objects (I'm
> not opposed to that) since it should be possible to return the properties
> with the same G_TOPOLOGY call (to keep everything atomic).

Sounds a good idea to me.

> 
> > };
> > 
> > And have the structs with (some) properties embed on it, like:
> > 
> > struct media_graph_entity {
> > 	struct media_graph_object obj;
> 
> This doesn't make sense: struct media_graph_topology would fill in an
> array of struct media_graph_object would point to media objects that
> in turn contain a struct media_graph_object.

Sorry, I didn't get your idea. Could you please give a C code example on
what you're thinking?

> 
> I wouldn't embed a struct media_graph_object in these structs, there
> is no point to that. Thinking about this some more you don't need the
> length field either, only an id (this gives you the type, so you know
> whether the object_data pointer is for a media_entity or a media_pad
> or whatever) and the pointer. Strictly speaking you would only need
> the 'type' part of the ID, but I see no reason not to fill in the full
> ID.
> 
> > 	u32 flags;
> > 	/* ... */
> > 	char name[64];
> > };
> > 
> > Please notice that we don't need to add reserved fields at the structs,
> > as we're now putting the struct length at the media_graph_object.
> > 
> > So, if we need to, for example, add a new "foo" inside the
> > media_graph_entity:
> > 
> > struct media_graph_entity {
> > 	struct media_graph_object obj;
> > 	u32 flags;
> > 	/* ... */
> > 	char name[64];
> > 	u32 foo;
> > };
> 
> No, you can't. Say you've compiled the application with a header that includes
> the foo field, and then you run the same application with an older kernel that
> doesn't have the foo field. Any access to foo would give garbage back (or fail).
> 
> You really need those reserved fields. The alternative would be to mess around
> with different struct versions, and that's painful.

No. The length will do that. All we need to do is to document that the data
should be zeroed on userspace before filling the data from G_TOPOLOGY.

For example:

let's say that, on Kernel 4.3: this is declared as:
struct media_graph_entity {
 	struct media_graph_object obj;
 	u32 flags;
 	char name[64];
};

And, on Kernel 4.4, the new "foo" field got introduced:

struct media_graph_entity {
 	struct media_graph_object obj;
 	u32 flags;
 	char name[64];
 	u32 foo;
};

Of course, just like we do with reserved fields, we should ensure that
old apps can live without the "foo" field, and that new apps will
keep working with older Kernels.

Now, we have:
	
The length of the data on 4.3 is: sizeof(obj) + 68
The length of the data on 4.4 is: sizeof(obj) + 72

As per my proposal, we need to pass the length for the public API
object.

struct media_graph_object {
 	u32 length;
 	u32 type;
 	u32 id;
	void *data;
}  __attribute__ ((packed));

An application for the G_TOPOLOGY would do something like:
	
 /* p is the pointer for the data returned from Kernel */
struct media_graph_entity
get_an_entity_graph_obj(struct media_graph_obj *obj)
{
	struct media_graph_entity *ent;
	int len;

	len = sizeof(*ent);
	if (len > obj->length)
		len = obj->length;

	ent = calloc(len, 1);
	memcpy (ent, obj->data, len);

	return ent;
}

There are three cases:

1) both app and Kernel are compiled against the same headers

No problem.

2) app is compiled against v4.4 headers
   kernel compiled against v4.3 headers

As the struct were zeroed before memcpy, all entities will have foo = 0.

No problem.

3) app is compiled against v4.3 headers
   kernel compiled against v4.4 headers

As the struct won't have the "foo" field, and it will be ignored.

No problem.

So, I don't see any usage to add reserved fields.

> 
> > 
> > There are some advantages of this approach:
> > - If the size of the entity will change, and obj.length will be bigger.
> >   Userspace will allocate more space to store the object, but will be
> >   backward compatible;
> > - We can add new object types anytime. If userspace doesn't know the new
> >   type, it should simply discard the object and go to the next one. Again,
> >   backward compatible.
> > 
> > We may eventually add a way for userspace to request only a subset of
> > the graph elements or to add an ioctl or some other sort of event that
> > will report topology changes.
> 
> It's an option, but the first 'advantage' doesn't actually work, and I am
> not sure about the second. Yes, it is an advantage but it comes at a price:
> the void pointer. I very much prefer strict typing.

See above.

We can avoid the void pointer with something like:

struct media_graph_object {
 	u32 length;
 	u32 type;
 	u32 id;
}  __attribute__ ((packed));

struct media_graph_entity {
	struct media_graph_object obj;
 	char name[64];
}  __attribute__ ((packed));

Of course, length is needed, in order to avoid filling it with reserved
stuff.

> 
> BTW, my initial proposal had a __u32 reserved[64] field, I'd redo that as
> follows:
> 
> 	struct
> 		__u32 num_reserved;
> 		void *ptr_reserved;
> 	} reserved[32];
> 
> This will make 32/64 bit pointer size differences much easier to handle.
> 
> And in my opinion, if we end up with so many different object types, then
> we have a much bigger problem and another redesign would be required.

Redesign the API because we add more things is crappy! We should do
something that, ideally, will never require us to redesign it again.

> In general, I prefer strict typing over void pointers, and having to cast
> all the time is something I'd really like to avoid. This API also gives
> you filtering for free (just leave the relevant pointers NULL).

Adding a filter field is not hard, and, as pointed above, we don't need
void pointers.

Regards,
Mauro

> 
> Regards,
> 
> 	Hans
> 
> > 
> >>>
> >>> #define MEDIA_IOC_G_TOPOLOGY        _IOWR('|', 0x04, struct mc_topology)
> >>>
> >>> Applications can allocate arrays for each type that they want to retrieve
> >>> (or NULL if they are not interested) and fill in the num_ fields with the
> >>> size of these arrays. Existing DVB/V4L applications that are typically only
> >>> interested in the interfaces created by a device will only need the
> >>> interfaces and can set the others to NULL.
> >>>
> >>> The driver will copy the data to the arrays and set the num_ fields to the
> >>> total number of elements.
> >>>
> >>> So by zeroing the struct and calling the ioctl once the num_ fields will be
> >>> filled in with the number of elements each array requires. The application
> >>> can allocate the memory and call the ioctl again to get the full topology.
> >>> The topology_version will be increased whenever the topology changes.
> >>> Static topologies that cannot change will always return 0 here. Topologies
> >>> that can change will start with version 1 and never return 0 here.
> >>>
> >>> As mentioned before, the property description is absent in this discussion,
> >>> but the idea is to allow properties for each object type except links (at
> >>> least for now) and to report all properties as part of the mc_topology
> >>> ioctl.
> >>>
> >>> A separate RFC will be written by Sakari for this.
> >>>
> >>> Backwards compatibility notes:
> >>>
> >>> - currently only entities are enumerated and that will be unchanged. So
> >>> neither interfaces nor connectors will be seen by the existing API.
> >>> - the v4l-subdev interface will still be reported in the union of the old
> >>>   media_entity_desc struct.
> >>> - currently entities representing DMA engines are reported as type
> >>> MEDIA_ENT_T_DEVNODE_V4L. This will change: such entities should be reported
> >>> as having type DMA engine. I think we can make an alias for
> >>> MEDIA_ENT_T_DEVNODE_V4L called MEDIA_ENT_T_DMA_ENGINE. The major/minor in
> >>> the dev struct in the union will point to the video device. - These are the
> >>> only two cases where the dev struct is used, for all other cases it will be
> >>> 0.
> >>> - struct media_pad_desc needs to be extended with a unique pad ID field.
> >>>
> >>> Regards,
> >>>
> >>> 	Hans
> >>>
> >>> PS: I'm on vacation this week, so don't expect quick replies from me :-)
> >>
> 
