From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v7 39/44] [media] uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY
 ioctl
Date: Tue, 25 Aug 2015 08:36:37 -0300
Message-ID: <20150825083637.35e0ca77@recife.lan>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<31b28b78f6a37ca7ff4554207bb05cd1a1db788c.1440359643.git.mchehab@osg.samsung.com>
	<55DC366C.5050509@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55DC366C.5050509-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Em Tue, 25 Aug 2015 11:33:32 +0200
Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> escreveu:

> On 08/23/15 22:17, Mauro Carvalho Chehab wrote:
> > Add a new ioctl that will report the entire topology on
> > one go.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> > 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 796e4a490af8..0111d9652b78 100644
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
> > index ceea791dd6e9..7fcf7f477ae3 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -238,11 +238,94 @@ struct media_links_enum {
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
> > + *	 The API definition should be freed from fields that are bound to
> > + *	 some specific data structure.
> > + *
> > + * FIXME: Currently, I opted to name the new types as "media_v2", as this
> > + *	  won't cause any conflict with the Kernelspace namespace, nor with
> > + *	  the previous kAPI media_*_desc namespace. This can be changed
> > + *	  latter, before the adding this API upstream.
> > + */
> > +
> > +
> > +#define MEDIA_NEW_LNK_FL_ENABLED		MEDIA_LNK_FL_ENABLED
> > +#define MEDIA_NEW_LNK_FL_IMMUTABLE		MEDIA_LNK_FL_IMMUTABLE
> > +#define MEDIA_NEW_LNK_FL_DYNAMIC		MEDIA_NEW_FL_DYNAMIC
> > +#define MEDIA_NEW_LNK_FL_INTERFACE_LINK		(1 << 3)
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
> As I suggested elsewhere, replace this by:
> 
> 	struct {
> 		__u32 num_reserved;
> 		void *ptr_reserved;
> 	} reserved_ptrs[8];
> 
> This will keep the number of reserved num/pointer pairs identical
> between 32 and 64 bit architectures. Without that doing compat32
> handling will be very difficult indeed.
> 
> We might want a separate __u32 reserved[] array so we're able to add
> non-pointer fields in the future.

OK.

> 
> Regards,
> 
> 	Hans
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
