From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCHv2 1/9] media: Fix DVB representation at media controller
 API
Date: Sun, 11 Jan 2015 12:34:35 -0200
Message-ID: <20150111123435.46c8619e@recife.lan>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
	<2274549.Xm2J2SkQ3y@avalon>
	<20150111115824.0e4acdf0@recife.lan>
	<10692325.J7AeJnuN2d@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <10692325.J7AeJnuN2d@avalon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Em Sun, 11 Jan 2015 16:05:32 +0200
Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org> escreveu:

> Hi Mauro,
> 
> On Sunday 11 January 2015 11:58:24 Mauro Carvalho Chehab wrote:
> > Em Sun, 11 Jan 2015 15:50:04 +0200 Laurent Pinchart escreveu:
> > > On Saturday 03 January 2015 12:49:03 Mauro Carvalho Chehab wrote:
> > >> The DVB devices are identified via a (major, minor) tuple,
> > >> and not by a random id. Fix it, before we start using it.
> > >> 
> > >> Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> > >> 
> > >> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > >> index e00459185d20..de333cc8261b 100644
> > >> --- a/include/media/media-entity.h
> > >> +++ b/include/media/media-entity.h
> > >> @@ -97,7 +97,10 @@ struct media_entity {
> > >>  			u32 device;
> > >>  			u32 subdevice;
> > >>  		} alsa;
> > >> -		int dvb;
> > >> +		struct {
> > >> +			u32 major;
> > >> +			u32 minor;
> > >> +		} dvb;
> > >> 
> > >>  		/* Sub-device specifications */
> > >>  		/* Nothing needed yet */
> > >> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > >> index d847c760e8f0..7902e800f019 100644
> > >> --- a/include/uapi/linux/media.h
> > >> +++ b/include/uapi/linux/media.h
> > >> @@ -27,7 +27,7 @@
> > >>  #include <linux/types.h>
> > >>  #include <linux/version.h>
> > >> 
> > >> -#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 0)
> > >> +#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 1)
> > >> 
> > >>  struct media_device_info {
> > >>  	char driver[16];
> > >> @@ -88,7 +88,10 @@ struct media_entity_desc {
> > >>  			__u32 device;
> > >>  			__u32 subdevice;
> > >>  		} alsa;
> > >> -		int dvb;
> > >> +		struct {
> > >> +			__u32 major;
> > >> +			__u32 minor;
> > >> +		} dvb;
> > > 
> > > Won't this break compilation of existing userspace code ? As DVB is not
> > > properly supported in MC at the moment we could consider that only
> > > mediactl will be affected, so it shouldn't be a big issue.
> > 
> > Well, media-ctl uses a local copy of the videodev2.h header, so it won't
> > break.
> 
> It's media.h, but you're correct here.

Ah, yes, that's what I meant ;)

Btw, I have also the patches adding support for DVB at v4l-utils:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/log/?h=dvb-media-ctl

> 
> > I'm not aware of any other application using MC for DVB.
> > 
> > Yet, imagining that such application exists, then, IMHO, it is better
> > to break compilation for it, as probably such application was written for
> > some OOT driver that might be using its own version of the media
> > controller implementation.
> 
> OK. I'll remember that argument the next time I want to break a kernel API 
> though ;-)

:)

Actually, we're not breaking the Kernel API here, as DVB support
inside the media controller were never added.

Next time, we should be sure to not add provision for an API at
the Kernel without actually implementing it ;)

Btw, eventually we'll end facing the very same issue when we
merge support for ALSA. IMHO, it is just easier to use major,minor
for all devnodes than to use anything else.

Yet, you're right: maybe we should do, instead:


	union {
		struct {
			u32 major;
			u32 minor;
		} dev;

		/* DEPRECATED: old node specifications */
		struct {
			u32 major;
			u32 minor;
		} v4l;
		struct {
			u32 major;
			u32 minor;
		} fb;
		struct {
			u32 card;
			u32 device;
			u32 subdevice;
		} alsa;
		int dvb;

		/* Sub-device specifications */
		/* Nothing needed yet */
	} info;

And change media-ctl to use info.dev for all devnodes. This will
provide a fix when we add support for alsa devnodes too.

Regards,
Mauro
