From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 07/35] dvb: split enum from typedefs at frontend.h
Date: Thu, 28 May 2015 19:22:23 -0300
Message-ID: <20150528192223.70b36203@recife.lan>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
	<6576f479a6e2449132811f5681e35d3794110d25.1432844837.git.mchehab@osg.samsung.com>
	<55678F64.6080801@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55678F64.6080801-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Em Thu, 28 May 2015 23:57:56 +0200
Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> escreveu:

> On 05/28/2015 11:49 PM, Mauro Carvalho Chehab wrote:
> > Using typedefs is already bad enough, but doing it together
> > with enum declaration is even worse.
> > 
> > Also, it breaks the scripts at DocBook that would be generating
> > reference pointers for the enums.
> > 
> > Well, we can't get rid of typedef right now, but let's at least
> > declare it on a separate line, and let the scripts to generate
> > the cross-reference, as this is needed for the next DocBook
> > patches.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> > 
> > diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
> > index 466f56997272..7aeeb5a69fdf 100644
> > --- a/include/uapi/linux/dvb/frontend.h
> > +++ b/include/uapi/linux/dvb/frontend.h
> > @@ -36,7 +36,7 @@ typedef enum fe_type {
> >  } fe_type_t;
> >  
> >  
> > -typedef enum fe_caps {
> > +enum fe_caps {
> >  	FE_IS_STUPID			= 0,
> >  	FE_CAN_INVERSION_AUTO		= 0x1,
> >  	FE_CAN_FEC_1_2			= 0x2,
> > @@ -68,7 +68,9 @@ typedef enum fe_caps {
> >  	FE_NEEDS_BENDING		= 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
> >  	FE_CAN_RECOVER			= 0x40000000, /* frontend can recover from a cable unplug automatically */
> >  	FE_CAN_MUTE_TS			= 0x80000000  /* frontend can stop spurious TS data output */
> > -} fe_caps_t;
> > +};
> > +
> > +typedef enum fe_caps_t;
> 
> This can't be right. This should be:
> 
> typedef enum fe_caps fe_caps_t;
> 
> Does it even compile?
> 
> Regards,
> 
> 	Hans


Heh, true. Thanks for checking.

Yeah, this won't likely compile. 


I'll double check the building troubles and fix them.

Thanks for pointing it.

Regards,
Mauro
