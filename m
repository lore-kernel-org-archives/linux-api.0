From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 44/55] [media] uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY
 ioctl
Date: Tue, 8 Dec 2015 17:23:40 -0200
Message-ID: <20151208172340.43a76779@recife.lan>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
	<297afcfe4c9c5ebc074f92d1badd34b94e8b28f9.1441540862.git.mchehab@osg.samsung.com>
	<1647957.hsKJGfKUVG@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1647957.hsKJGfKUVG@avalon>
Sender: linux-media-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Em Sun, 06 Dec 2015 02:47:39 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 06 September 2015 09:03:04 Mauro Carvalho Chehab wrote:
> > Add a new ioctl that will report the entire topology on
> > one go.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 7320cdc45833..2d5ad40254b7 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -181,6 +181,8 @@ struct media_interface {
> >   */
> >  struct media_intf_devnode {
> >  	struct media_interface		intf;
> > +
> > +	/* Should match the fields at media_v2_intf_devnode */
> >  	u32				major;
> >  	u32				minor;
> >  };
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index a1bd7afba110..b17f6763aff4 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -206,6 +206,10 @@ struct media_pad_desc {
> >  #define MEDIA_LNK_FL_IMMUTABLE		(1 << 1)
> >  #define MEDIA_LNK_FL_DYNAMIC		(1 << 2)
> > 
> > +#define MEDIA_LNK_FL_LINK_TYPE		(0xf << 28)
> > +#  define MEDIA_LNK_FL_DATA_LINK	(0 << 28)
> > +#  define MEDIA_LNK_FL_INTERFACE_LINK	(1 << 28)
> > +
> >  struct media_link_desc {
> >  	struct media_pad_desc source;
> >  	struct media_pad_desc sink;
> > @@ -249,11 +253,93 @@ struct media_links_enum {
> >  #define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
> >  #define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)
> > 
> > -/* TBD: declare the structs needed for the new G_TOPOLOGY ioctl */
> > +/*
> > + * MC next gen API definitions
> > + *
> > + * NOTE: The declarations below are close to the MC RFC for the Media
> > + *	 Controller, the next generation. Yet, there are a few adjustments
> > + *	 to do, as we want to be able to have a functional API before
> > + *	 the MC properties change. Those will be properly marked below.
> > + *	 Please also notice that I removed "num_pads", "num_links",
> > + *	 from the proposal, as a proper userspace application will likely
> > + *	 use lists for pads/links, just as we intend to do in Kernelspace.
> > + *	 The API definition should be freed from fields that are bound to
> > + *	 some specific data structure.
> > + *
> > + * FIXME: Currently, I opted to name the new types as "media_v2", as this
> > + *	  won't cause any conflict with the Kernelspace namespace, nor with
> > + *	  the previous kAPI media_*_desc namespace. This can be changed
> > + *	  later, before the adding this API upstream.
> 
> Yes, that's a good idea. Or at least we need to remove this comment if we 
> decide to keep the v2 names :-)

True ;)

> 
> > + */
> > +
> > +
> > +struct media_v2_entity {
> > +	__u32 id;
> > +	char name[64];		/* FIXME: move to a property? (RFC says so) */
> 
> I agree with Sakari that we can keep the name here even if we also expose it 
> as a property. However, there's one issue we need to address : we need to 
> clearly define what the name field should contain and how it should be 
> constructed, otherwise we'll end up with the exact same mess as today, and I 
> don't want that. We can discuss it in this mail thread or as replies to a 
> future documentation patch.


Well, let's discuss it then. What's your proposal?

I guess there are actually some different goals that we want to archive
with "name":

1) an ideally short name used when displaying an entity on some graph. 
It would be good if such "short name" would be unique, but it won't
hurt much if such name is not unique;

2) an unique ID identifier that will likely take the position of an
entity inside the machine bus, like PCI ID, USB ID, I2C bus + I2C addr...

I guess such UID would be better addressed via properties, as it
would likely be constructed in userspace via a different set of
properties, depending on the device and/or bus type.

> 
> > +	__u16 reserved[14];
> 
> Sakari and Hans have already commented on using __u32 instead of __u16 for 
> reserved fields, as well as on the number of reserved fields. I agree with 
> them but have nothing to add.

Ok. I'll change this on a later patch.

> 
> > +};
> > +
> > +/* Should match the specific fields at media_intf_devnode */
> > +struct media_v2_intf_devnode {
> > +	__u32 major;
> > +	__u32 minor;
> > +};
> > +
> > +struct media_v2_interface {
> > +	__u32 id;
> > +	__u32 intf_type;
> > +	__u32 flags;
> > +	__u32 reserved[9];
> > +
> > +	union {
> > +		struct media_v2_intf_devnode devnode;
> > +		__u32 raw[16];
> > +	};
> > +};
> > +
> > +struct media_v2_pad {
> > +	__u32 id;
> > +	__u32 entity_id;
> > +	__u32 flags;
> > +	__u16 reserved[9];
> > +};
> > +
> > +struct media_v2_link {
> > +    __u32 id;
> > +    __u32 source_id;
> > +    __u32 sink_id;
> > +    __u32 flags;
> > +    __u32 reserved[5];
> > +};
> > +
> > +struct media_v2_topology {
> > +	__u32 topology_version;
> > +
> > +	__u32 num_entities;
> > +	struct media_v2_entity *entities;
> 
> The kernel seems to be moving to using __u64 instead of pointers in userspace-
> facing structures to avoid compat32 code.

We had such discussion at the MC summit. I don't object to change to
__u64, but we need to reach a consensus ;)

> 
> > +
> > +	__u32 num_interfaces;
> > +	struct media_v2_interface *interfaces;
> > +
> > +	__u32 num_pads;
> > +	struct media_v2_pad *pads;
> > +
> > +	__u32 num_links;
> > +	struct media_v2_link *links;
> > +
> > +	struct {
> > +		__u32 reserved_num;
> > +		void *reserved_ptr;
> > +	} reserved_types[16];
> > +	__u32 reserved[8];
> 
> I'd just create __u32 reserved fields without any reserved_types, we can 
> always use the reserved fields to add new types later.

It used to be __u32... Hans requested to change it to an struct.

Btw, I also prefer to use __u32 here ;)

> 
> > +};
> > +
> > +/* ioctls */
> > 
> >  #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct 
> media_device_info)
> >  #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct 
> media_entity_desc)
> > #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
> > #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
> > +#define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
> > 
> >  #endif /* __LINUX_MEDIA_H */
> 
