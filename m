From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 14/18] [media] media-device: export the entity function
 via new ioctl
Date: Tue, 24 Nov 2015 08:27:14 -0200
Message-ID: <20151124082714.63d2530b@recife.lan>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
	<13a08789f63775c6f014c08969bc8ed3f0550c82.1441559233.git.mchehab@osg.samsung.com>
	<2850958.hkaPDHPL2k@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2850958.hkaPDHPL2k@avalon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Em Mon, 23 Nov 2015 19:46:22 +0200
Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 06 September 2015 14:30:57 Mauro Carvalho Chehab wrote:
> > Now that entities have a main function, expose it via
> > MEDIA_IOC_G_TOPOLOGY ioctl.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index ccef9621d147..32090030c342 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -263,6 +263,7 @@ static long __media_device_get_topology(struct
> > media_device *mdev, /* Copy fields to userspace struct if not error */
> >  		memset(&uentity, 0, sizeof(uentity));
> >  		uentity.id = entity->graph_obj.id;
> > +		uentity.function = entity->function;
> >  		strncpy(uentity.name, entity->name,
> >  			sizeof(uentity.name));
> > 
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index 69433405aec2..d232cc680c67 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -284,7 +284,8 @@ struct media_links_enum {
> >  struct media_v2_entity {
> >  	__u32 id;
> >  	char name[64];		/* FIXME: move to a property? (RFC says so) */
> > -	__u16 reserved[14];
> > +	__u32 function;		/* Main function of the entity */
> 
> Shouldn't we use kerneldoc instead of inline comments ?

We don't use kernel-doc for uAPI. Instead, we document those via the
media infrastructure DocBook.

I don't object to use the same format here, but adding the uAPI stuff
to both device-drivers.xml and media_api.xml doesn't seem right.

That's said, we may eventually change the media infrastructure DocBook
to also run the kernel-doc script and benefit of kernel-doc markups
also for the uAPI, but this is out of the scope of this work, and would
take some time to do it.

So, at least for now, I would keep the comments like the above.

> 
> Also, as this is the main function only, I'd mention that in the subject line. 

OK.

> The implementation itself looks fine to me, I'll discuss the API over the 
> documentation patch.

Ok.
> 
> > +	__u16 reserved[12];
> >  };
> > 
> >  /* Should match the specific fields at media_intf_devnode */
> 
