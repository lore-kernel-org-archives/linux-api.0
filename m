From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [RFC] Media Controller, the next generation
Date: Sun, 16 Aug 2015 10:37:09 -0300
Message-ID: <20150816103709.444d59c1@recife.lan>
References: <55BF75B4.2060301@xs4all.nl>
	<1553545.72YdKh14yc@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1553545.72YdKh14yc@avalon>
Sender: linux-media-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Linux Media Mailing List <linux-media@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Em Sat, 15 Aug 2015 21:25:40 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Hans,
> 
> Thank you for the RFC. I believe it's quite good (at least to my eyes). 
> Everything is of course not perfect yet so please see below for some comments.

(added c/c linux-api@vger.kernel.org)

> 
> On Monday 03 August 2015 16:07:48 Hans Verkuil wrote:
> > Hi all,
> > 
> > During last week's brainstorm meeting in Espoo, Finland, we discussed
> > how to proceed with the MC API. Trying to apply the existing API to DVB
> > devices caused a lot of controversy and this meeting was an attempt to
> > resolve these issues.
> > 
> > This RFC is the proposal for the public API (NOT the internal API!) we
> > came up with.
> > 
> > The main change is that interfaces (such as devices in /dev) get their own
> > object: struct media_interface. The struct media_entity as is used today
> > will not refer to interfaces anymore.
> > 
> > Since interfaces control entities we also want to tell userspace which
> > entities are controlled by which interfaces. We want to keep things simple
> > and avoid having to create a new link structure just for this,

I agree with the Hans proposal. Having a single object to represent graph
links makes easier for both Kernelspace and Userspace to handle them.

> During the meeting we discussed the possibility of creating a 
> media_interface_link structure (as drafted in 
> http://linuxtv.org/downloads/presentations/mc_ws_2015/media.h). What would be 
> the advantage of reusing media_link ?

I would reverse the question: what's the disadvantage?

By using the same type, it should be easier to change userspace programs
to support both interface and data links.

With a single struct, if/when apps need to do graph traversal, they can
use a single algorithm. It also means a single code to allocate and
fetch the structs that come from the Kernel.

> > so instead a struct media_link just provides two object IDs and a flags
> > field. The object IDs refer to pads (for data links) or entity/interface IDs
> > (for associating interfaces with entities).
> > 
> > To make this work we need unique pad IDs.
> >
> > We will need to represent connectors as well. The media_entity struct is
> > used for that, but it will be marked as a connector since connectors work
> > slightly different from an entity: if an entity has both input and output
> > pads, then that means that the entity processes the input data in some way
> > before passing it on to the output pads. But for a connector the input and
> > output pads are just hooked up to input and output pins or buses and not
> > to one another.
> > 
> > Finally we would like to get all this information atomically in userspace.
> > Atomicity is desired since some of this information well be dynamic.
> > Currently the only dynamic thing is enabling/disabling links, but that is
> > too limiting for devices like FPGAs where the entities can change on the
> > fly as well.
> > 
> > Being able to get all the information with a single ioctl will simplify
> > implementing this atomic behavior, and it is also more efficient than
> > calling lots of ENUM ioctls.
> > 
> > We decided to keep the existing structs and ioctls and introduce new
> > versions of these structs redesigned to cope with the new insights. The
> > sizes of the reserved fields are suggestions only.
> > 
> > We had a discussion about the object IDs. Currently we have only entity IDs,
> > but in the redesign we'll have interface, connector and pad IDs as well.
> 
> As connectors are entities I don't think they deserve a special mention here. 

Hans proposal is to use a different type for connectors. So, I guess it
makes sense to keep the mention.

> Regarding pad IDs, is there a reason to give pads IDs in the global ID space 
> other than reusing media_link ?

I actually have another usage for that ;)

I'll comment that below.

> 
> > The idea from the meeting was to use the least significant X bits of the ID
> > to tell the difference of entity, interface and pad types and to use a flag
> > for marking connector entities. After thinking some more I would suggest
> > this scheme instead:
> > 
> > #define MEDIA_ID_T_ENTITY 		0
> > #define MEDIA_ID_T_CONNECTOR 		1
> > #define MEDIA_ID_T_INTERFACE 		2
> > #define MEDIA_ID_T_PAD 			3

My suggestion is actually that we should have one type for every possible
graph object. So, I would also add a MEDIA_ID_T_LINK, in order to represent
the links.

Btw, I think that we'll end by needing a MEDIA_ID_T_GROUP too, in order
to properly replace the group ID, of course assuming that we keep needing
to have groups of objects. 

My idea, if we ever need a MEDIA_ID_T_GROUP is to represent a group as an
object that contains a list of other objects: entities, interfaces, links,
pads, etc.

At the userspace interface, the group will pass just the object IDs for
the objects that belong to such group, plus group name (and maybe flags).

This proposal still need discussions. The most important one is: do we need
groups on userspace? So, I would not cover groups on this RFC yet, but it
would be great if the API we're writing could latter be extended to support
groups.

Internally, at the Kernel, groups make sense, specially when different
drivers are handling the same MC graph.

For example, let's imagine a pipeline with ALSA, V4L, DVB and DRM entities
inside. It makes sense for the ALSA snd-audio-usb driver to group
all ALSA-related objects. The same is true for the DVB core and for
the V4L2 and DRM drivers/core.

So, that's another reason why I think we should have an unique object
ID for the links too: it makes easier to group them.

> > 
> > #define MEDIA_ID_TYPE(id)		((id) >> 24)
> > #define MEDIA_ID_VAL(id)		((id) & 0xffffff)
> > #define MEDIA_ID_CREATE(type, id)	(((type) << 24) | id)
> > 
> > One objection was that the IDs would be unwieldy for users when using e.g.
> > media-ctl since you'll get IDs >= 0x1000000. However, I think that media-ctl
> > can easily either deduce the type (i.e. setting up the data path would
> > always assume type 'pad' or require that the user specifies the type and ID
> > value (i.e. only the lowest 24 bits).
> 
> What would be the advantage of that scheme compared to having a type field and 
> an id field ?
> 
> The proposal makes MEDIA_ID_VAL(id) non-unique, Is there anything really wrong 
> with having a single ID space ?

My personal preference when I read Hans proposal were to keep the type separate
from the ID, but, after seeing the usage of the mdev.entity_id, I guess that
this proposal makes things simpler.

However, as Sakari doesn't want big numbers for IDs, in order to improve
human readability, userspace apps may eventually accept two ways to 
represent a graph obj that is being controlled:

	as a global ID, e. g.something like: "0x010000000000001"
	as something like "entity#1", "link#3", ...

The drawback is that we limit the maximum number of types to 8 bits, and
the maximum ID range to 24 bits, but I don't think this is an issue.

> > Since MEDIA_ID_T_ENTITY == 0 this will be backwards compatible with the
> > existing entity IDs.
> 
> There has never been any guarantee that entity IDs would be consecutive, so I 
> don't think that backward compatibility would be an issue with a single ID 
> space.

Well, if userspace implements the same algorithm for graph traversal as
the Kernelspace, e. g. using 1 << entity->id to identify loops, changing
this will break userspace.

So, I guess we're are bound to keep a consecutive range starting from 1
for entities.

> > Note that currently there are no unique pad IDs: adding this requires a
> > single change to struct media_pad_desc where one of the reserved fields is
> > used to export the unique pad ID. Existing apps can ignore this.
> > 
> > The new media_entity_desc struct looks like this:
> > 
> > struct mc_entity {
> > 	__u32 id;
> > 	__u16 num_pads;
> > 	__u16 reserved[13];
> > };

I would add flags here too. Not needing to read properties for some trivial
things that might be represented via flags sound a good thing to me.

Also, I know that we'll keep num_pads at MC, but I would remove this
from the API, as, the way I'm coding it, the Kernel won't have the
numbe anymore, as my idea is to implement as a list at Kernelspace,
in order to support dynamic changes.

If we ever do such change, that would mean that the kernelspace
would need to count the number of pads just due to the a crap API.

Also, if userspace implements PAD as a list, it won't need it.

So, the "num_pads" on this new API is just an assumption that
either Kernel or userspace (or both) would use a certain data type.

> > 
> > I'm going with mc_entity for now. An alternative name might be:
> > mediav2_entity or media_entity_v2 (I never liked the _desc suffix and
> > media_entity can't be used due to clashed with the internal media_entity
> > struct).

I think we should use different namespaces for the internal and external
representation. One alternative would be to rename the internal namespace
(for example, adding "graph_") and keep "media_" for the userspace API.

Anyway, I'm comfortable with whatever consistent namespace proposal.

> 
> I'm not too fond of _desc either, mc_ is an interesting alternative, albeit 
> maybe slightly too generic.

Agreed.

> 
> > A third alternative might be to use mc_entity for the internal data structs
> > and media_entity for the external.
> 
> That's interesting too.

No, mc_entity is a bad prefix. Calling something like:
	mc_entity_interface
is also confusing.

I would use something like:
	media_controller_(entity|intf|pad|link|...)
or
	media_graph_(entity|intf|pad|link|...)
or
	media_obj_(entity|intf|pad|link|...)

> > As you can see, we didn't have time to discuss the naming for these new
> > structs. But for the purposes of this RFC I'm going with mc_ for now.
> > 
> > This struct is much smaller than the original: both name and type will be
> > stored as properties of the entity (properties will be the topic of a
> > separate upcoming RFC). Pretty much everything else has been removed except
> > for num_pads: while even this is not strictly necessary, it was considered
> > to be useful to know for applications that use this API.

I would keep out those num_foo from the defines. The way I see is that
we'll end by removing the need of those counters internally, as, for dynamic
allocation/removal, we'll need to convert the internal data struct to lists.
I guess userspace apps relying on the new API will also do that too.

If we preserve those num_foo and convert internal data struct to lists,
the Kernel will need to artificially count the number of stuff just to satisfy
the userspace interface, on an assumption that userspace would keep using
arrays there instead of lists.

It is a bad design to write an userspace API that assumes that a particular
data struct will be used.

> To clarify the design principle here (and please correct me if my 
> understanding doesn't match yours), even though all fields could be exposed as 
> properties, the idea was to include core fields deemed of particular interest 
> for userspace in mc_entity as a kind of "shortcut".

That doesn't sound the best way to me.

> 
> > The new mc_interface struct is defined as follows:
> > 
> > #define MEDIA_INTF_T_DVB_FE    	(MEDIA_ENT_T_DEVNODE + 4)
> > #define MEDIA_INTF_T_DVB_DEMUX  (MEDIA_ENT_T_DEVNODE + 5)
> > #define MEDIA_INTF_T_DVB_DVR    (MEDIA_ENT_T_DEVNODE + 6)
> > #define MEDIA_INTF_T_DVB_CA     (MEDIA_ENT_T_DEVNODE + 7)
> > #define MEDIA_INTF_T_DVB_NET    (MEDIA_ENT_T_DEVNODE + 8)
> > 
> > // TBC: #define MEDIA_INTF_T_NETIF_DVB    (MEDIA_ENT_T_DEVNODE + 9)
> > 
> > #define MEDIA_INTF_T_V4L_VIDEO  (MEDIA_ENT_T_DEVNODE + 10)
> > #define MEDIA_INTF_T_V4L_VBI    (MEDIA_ENT_T_DEVNODE + 11)
> > #define MEDIA_INTF_T_V4L_RADIO  (MEDIA_ENT_T_DEVNODE + 12)
> > #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_ENT_T_DEVNODE + 13)
> > #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_ENT_T_DEVNODE + 14)
> > 
> > #define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_ENT_T_DEVNODE + 15)
> > #define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_ENT_T_DEVNODE + 16)
> > #define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_ENT_T_DEVNODE + 17)
> > #define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_ENT_T_DEVNODE + 18)
> > #define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_ENT_T_DEVNODE + 19)
> > #define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_ENT_T_DEVNODE + 20)
> 
> I wouldn't reuse MEDIA_ENT_T_DEVNODE in the definition of the new values as 
> that macro becomes deprecated. It needs to be kept for backward-compatibility 
> of course, but I'd rather define it in terms of the new macros than the other 
> way around.

Agreed.

> That's an implementation detail, it doesn't invalidate the above 
> list.
> 
> > struct mc_interface {
> > 	__u32 id;
> > 	__u32 intf_type;
> 
> Is there a particular reason to name this field intf_type instead of just type 
> ?
> 
> > 	__u32 flags;
> > 	__u32 num_entity_links;
> > 	__u32 reserved[8];
> > 
> > 	union {
> >         	/* Node specifications */
> >         	struct {
> >             		__u32 major;
> >             		__u32 minor;
> >         	} devnode;
> > 
> > // TBC:       	struct {
> > //            		__s32 if_index;
> > //        	} netif;
> > 
> >         	__u32 raw[16];
> >     	};
> > };

I'm actually in doubt keeping the union here or representing them via
properties. See more below.

> > 
> > The type determines which interface it is, and additional details on how to
> > find the interface are in the union. This example also shows how to identify
> > network interfaces if we want to expose the network interfaces such as are
> > created by DVB.
> > 
> > The num_entity_links field reports how many entities are controlled by this
> > interface. While not strictly necessary it is useful for applications to
> > know.
> > 
> > There is currently only one flag: MEDIA_INTF_FL_DEFAULT (formerly
> > MEDIA_ENT_FL_DEFAULT). This flag tells applications whether this interface
> > is a default interface, i.e. the one apps should use by default. Useful
> > when there are e.g. multiple video interfaces.
> 
> Still brainstorming here, would it make sense to have a "usage" field instead 
> ? I'm thinking about cases where different device nodes of the same type would 
> be considered as default for different use cases. For instance if you have a 
> TV capture card that can output two video streams, one for preview purpose in 
> YUV and the other one for capture purpose in MPEG, which one would be the 
> single default ? The answer will likely vary depending on whether users are 
> more interested in watching TV on their screen or recording it.

An "usage" property makes sense to me.

> > The new pad struct looks like this:
> > 
> > struct mc_pad {
> >     	__u32 id;
> 
> Is this an ID as in the global pad ID discussed above, or an index local to 
> the entity ? I believe an index is still very useful at least inside the 
> kernel, and possibly in userspace as well, as pad IDs won't be stable and 
> couldn't be used to identify a pad in the context of its entity.

This should be a global ID. We'll need dynamic PADs for some usages on
DVB, so the ID may not be indexed.

Also, identifying a PAD by an index is problematic. One of the problems
I had when creating the V4L2 MC representation for TV devices is that
some entities have multiple PADs but each PAD is used to carry a different
type of signal.

For example, almost all tuners have:
- one output PAD with the TV IF signal;
- one output PAD with the audio IF signal.

Also, all analog TV demodulators have:
- one output PAD for video;
- one output PAD for raw Vertical Blank Interface (VBI) signal.

And a few demods also have a separate PAD for decoded VBI data.

On both cases, the output PADs are not interchangeable, and they're
bound to be linked to different entities or different entity pads.

Right now, as the PAD index is driver-specific, I had to create a
graph traversal function to connect the links inside the drivers,
as the core doesn't know what PADs index has video, audio or VBI.

That's problematic, specially when an independent driver like
snd-audio-usb needs to connect the audio PAD into the entity
that handles audio input samples inside it.

I would very much prefer to have an "usage" field at the PADs,
as this would allow to have core functions to create the links
between the entities and to enable/disable such links at streamon
and streamoff for most devices, avoiding code duplication.

In other words, I would replace the PAD index by something like:

	media_pad *find_pad(struct media_entity entity, enum pad_usage usage, int idx);

	vbi_pad = find_pad(entity, PAD_TYPE_VBI, 0);
	video_pad = find_pad(entity, PAD_TYPE_VIDEO, 0);
	audio_pad = find_pad(entity, PAD_TYPE_AUDIO, 0);
or
	media_pad *find_pad(struct media_entity entity, char *pad_name);

	vbi_pad = find_pad(entity, "vbi");
	video_pad = find_pad(entity, "video");
	audio_pad = find_pad(entity, "audio");

Such calls are driver-independent and can be used inside ALSA, DVB and
V4L2 core functions, solving the issue on common use cases.

> 
> >     	__u32 entity_id;
> >     	__u32 flags;
> > 	__u16 num_links;
> > 	__u16 reserved[9];
> > };
> > 
> > And links look like this:
> > 
> > struct mc_link {
> >     	__u32 source_id;
> >     	__u32 sink_id;
> >     	__u32 flags;
> > 	__u32 reserved[5];
> > };
> > 
> > The source/sink_id fields refer to pads (for data links) or interface
> > (source_id) and entity (sink_id) for the interface/entity relationships.
> > 
> > While not implemented initially this will also make it possible to model
> > cases where one entity controls another entity. Whether we actually will
> > need this is uncertain, but at least it can be supported should we require
> > it.
> > 
> > Finally we will need a way to retrieve all this information. To do this a
> > single struct is created:
> > 
> > struct mc_topology {
> >     	__u32 topology_version;
> >     	__u32 num_entities;
> >     	struct mc_entity *entities;
> >     	__u32 num_interfaces;
> >     	struct mc_interface *interfaces;
> >     	__u32 num_pads;
> >     	struct mc_pad *pads;
> >     	__u32 num_links;
> >     	struct mc_link *links;
> > 	__u32 reserved[64];
> > };

This would work, and I can accept this, but my concern is that we'll have
a hard limit on extending the types of objects, given by the "reserved"
field.

So, an alternative proposal would be to replace it with something like:

struct media_graph_object {
	u32 length;

	/* Actually, we can merge those two, as proposed by Hans */
	u32 type;
	u32 id;

	void *object_data;
}  __attribute__ ((packed));

struct media_graph_topology {
     	__u32 topology_version;
	__u32 num_objects;
	struct media_graph_object *objects;
};

And have the structs with (some) properties embed on it, like:

struct media_graph_entity {
	struct media_graph_object obj;
	u32 flags;
	/* ... */
	char name[64];
};

Please notice that we don't need to add reserved fields at the structs,
as we're now putting the struct length at the media_graph_object.

So, if we need to, for example, add a new "foo" inside the
media_graph_entity:

struct media_graph_entity {
	struct media_graph_object obj;
	u32 flags;
	/* ... */
	char name[64];
	u32 foo;
};

There are some advantages of this approach:
- If the size of the entity will change, and obj.length will be bigger.
  Userspace will allocate more space to store the object, but will be
  backward compatible;
- We can add new object types anytime. If userspace doesn't know the new
  type, it should simply discard the object and go to the next one. Again,
  backward compatible.

We may eventually add a way for userspace to request only a subset of
the graph elements or to add an ioctl or some other sort of event that
will report topology changes.

> > 
> > #define MEDIA_IOC_G_TOPOLOGY        _IOWR('|', 0x04, struct mc_topology)
> > 
> > Applications can allocate arrays for each type that they want to retrieve
> > (or NULL if they are not interested) and fill in the num_ fields with the
> > size of these arrays. Existing DVB/V4L applications that are typically only
> > interested in the interfaces created by a device will only need the
> > interfaces and can set the others to NULL.
> > 
> > The driver will copy the data to the arrays and set the num_ fields to the
> > total number of elements.
> > 
> > So by zeroing the struct and calling the ioctl once the num_ fields will be
> > filled in with the number of elements each array requires. The application
> > can allocate the memory and call the ioctl again to get the full topology.
> > The topology_version will be increased whenever the topology changes.
> > Static topologies that cannot change will always return 0 here. Topologies
> > that can change will start with version 1 and never return 0 here.
> > 
> > As mentioned before, the property description is absent in this discussion,
> > but the idea is to allow properties for each object type except links (at
> > least for now) and to report all properties as part of the mc_topology
> > ioctl.
> > 
> > A separate RFC will be written by Sakari for this.
> > 
> > Backwards compatibility notes:
> > 
> > - currently only entities are enumerated and that will be unchanged. So
> > neither interfaces nor connectors will be seen by the existing API.
> > - the v4l-subdev interface will still be reported in the union of the old
> >   media_entity_desc struct.
> > - currently entities representing DMA engines are reported as type
> > MEDIA_ENT_T_DEVNODE_V4L. This will change: such entities should be reported
> > as having type DMA engine. I think we can make an alias for
> > MEDIA_ENT_T_DEVNODE_V4L called MEDIA_ENT_T_DMA_ENGINE. The major/minor in
> > the dev struct in the union will point to the video device. - These are the
> > only two cases where the dev struct is used, for all other cases it will be
> > 0.
> > - struct media_pad_desc needs to be extended with a unique pad ID field.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > PS: I'm on vacation this week, so don't expect quick replies from me :-)
> 
