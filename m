From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v8 44/55] [media] uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY
 ioctl
Date: Mon, 31 Aug 2015 10:35:18 -0300
Message-ID: <20150831103518.218ecca1@recife.lan>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<ed72ef83c937fe6f665001eb9d6a54f25f253391.1440902901.git.mchehab@osg.samsung.com>
	<55E441EA.4020206@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55E441EA.4020206-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Em Mon, 31 Aug 2015 14:00:42 +0200
Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> escreveu:

> On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> > Add a new ioctl that will report the entire topology on
> > one go.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> > 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 756e1960fd7f..358a0c6b1f86 100644
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
> > index 4186891e5e81..fa0b68e670b0 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -251,11 +251,94 @@ struct media_links_enum {
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
> > + *	 use lists for pads/links, just as we intend todo in Kernelspace.
> 
> s/todo/to do/
> 
> > + *	 The API definition should be freed from fields that are bound to
> > + *	 some specific data structure.
> > + *
> > + * FIXME: Currently, I opted to name the new types as "media_v2", as this
> > + *	  won't cause any conflict with the Kernelspace namespace, nor with
> > + *	  the previous kAPI media_*_desc namespace. This can be changed
> > + *	  latter, before the adding this API upstream.
> 
> s/latter/later/ :-)
> 
> I think this comment belongs to the commit log and not in this header.

True, but I opted to keep it here for now to produce some discussions ;)

I'm actually in doubt if we should rename the flags as proposed below,
and use the newer flags only at G_TOPOLOGY or if we should keep the same
namespace for them and accept newer flags with legacy ioctls.

> 
> > + */
> > +
> > +
> > +#define MEDIA_NEW_LNK_FL_ENABLED		MEDIA_LNK_FL_ENABLED
> > +#define MEDIA_NEW_LNK_FL_IMMUTABLE		MEDIA_LNK_FL_IMMUTABLE
> > +#define MEDIA_NEW_LNK_FL_DYNAMIC		MEDIA_NEW_FL_DYNAMIC
> > +#define MEDIA_NEW_LNK_FL_INTERFACE_LINK		(1 << 3)
> 
> Shouldn't this be MEDIA_V2_ instead of MEDIA_NEW_?
> 
> Do we need the INTERFACE_LINK flag? You can deduce it by checking the
> ID type.

Yes, this can be deduced from the type of the objects inside the link.

I guess I added it because of some comment from your media.h RFC
proposal.

Right now, I'm using it at the application to better represent the graph
elements:

	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/tree/contrib/test/mc_nextgen_test.c?h=mc-next-gen&id=fdc16ece9732c94cfa76eee86978158c5976c00a#n438 
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/tree/contrib/test/mc_nextgen_test.c?h=mc-next-gen&id=fdc16ece9732c94cfa76eee86978158c5976c00a#n444

But it could, instead, be doing something like:

	if media_type(link->gobj1.id == MEDIA_GRAPH_PAD)
		link_is_pad = true;
	else
		link_is_pad = false;


Btw, I'm using the same type for both data and interface links, as
I don't see any reason why to differentiate internally: they all share
the same linked list at mdev and the same object ID range.

> 
> I don't have a clear preference one way or another, just wondering about the
> reason for adding it.
> 
> > +
> > +struct media_v2_entity {
> > +	__u32 id;
> > +	char name[64];		/* FIXME: move to a property? (RFC says so) */
> > +	__u16 reserved[14];
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
> 
> Like in media_link I would use a union here as well to be able to refer to
> source/sink_id and entity/interface_id.

That would be overkill, and won't help.

Unions make the code harder to read and kernel-doc-nano doesn't like unions
very much.

Ok, there are some cases where it helps, but there's no good reason
for doing it here.

If you don't like the name, let's just rename it to something else.

> 
> > +    __u32 flags;
> > +    __u32 reserved[5];
> > +};
> > +
> > +struct media_v2_topology {
> > +	__u32 topology_version;
> > +
> > +	__u32 num_entities;
> > +	struct media_v2_entity *entities;
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
> > +	__u32 reserved[64];
> 
> As mentioned before: use this instead to prevent horrible 32/64 bit arch
> compat code:
> 
> 	struct {
> 		__u32 reserved_num;
> 		void *reserved_ptr;
> 	} reserved_types[16];
> 	__u32 reserved[8];
> 
> Sizes for these arrays are TBD.

OK. Sorry, I forgot to do this change.

> 
> > +};
> > +
> > +/* ioctls */
> >  
> >  #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
> >  #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
> >  #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
> >  #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
> > +#define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
> >  
> >  #endif /* __LINUX_MEDIA_H */
> > 
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
