From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 8/9] [media] handle 64-bit time_t in v4l2_buffer
Date: Fri, 18 Sep 2015 11:26:43 +0200
Message-ID: <2032750.MT8vj0PRkR@wuerfel>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de> <1442524780-781677-9-git-send-email-arnd@arndb.de> <55FBBAD5.4010002@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55FBBAD5.4010002@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Friday 18 September 2015 09:18:45 Hans Verkuil wrote:
> Hi Arnd,
> 
> Thanks once again for working on this! Unfortunately, this approach won't
> work, see my comments below.
> 
> BTW, I would expect to see compile errors when compiling for 32 bit. Did
> you try that?

I only tested on 32-bit, both ARM and x86, but had a longer set of patches
applied below.

> > +static void v4l_put_buffer_time32(struct v4l2_buffer_time32 *to,
> > +				  const struct v4l2_buffer *from)
> > +{
> > +	to->index		= from->index;
> > +	to->type		= from->type;
> > +	to->bytesused		= from->bytesused;
> > +	to->flags		= from->flags;
> > +	to->field		= from->field;
> > +	to->timestamp.tv_sec	= from->timestamp.tv_sec;
> > +	to->timestamp.tv_usec	= from->timestamp.tv_usec;
> > +	to->timecode		= from->timecode;
> > +	to->sequence		= from->sequence;
> > +	to->memory		= from->memory;
> > +	to->m.offset		= from->m.offset;
> > +	to->length		= from->length;
> > +	to->reserved2		= from->reserved2;
> > +	to->reserved		= from->reserved;
> > +}
> 
> Is there a reason why you didn't use memcpy like you did for VIDIOC_DQEVENT (path 5/9)?
> I would prefer that over these explicit assignments.

No strong reason. I went back and forth a bit on the m.offset field that
is part of a union: In a previous version, I planned to move all the
compat handling here, and doing the conversion one field at a time would
make it easier to share the code between 32-bit and 64-bit kernels
handling old 32-bit user space. This version doesn't do that, so I can
use the memcpy approach instead.

> >  static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
> >  				struct file *file, void *fh, void *arg)
> >  {
> > @@ -2408,12 +2524,21 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
> >  	IOCTL_INFO_FNC(VIDIOC_S_FMT, v4l_s_fmt, v4l_print_format, INFO_FL_PRIO),
> >  	IOCTL_INFO_FNC(VIDIOC_REQBUFS, v4l_reqbufs, v4l_print_requestbuffers, INFO_FL_PRIO | INFO_FL_QUEUE),
> >  	IOCTL_INFO_FNC(VIDIOC_QUERYBUF, v4l_querybuf, v4l_print_buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
> > +#ifndef CONFIG_64BIT
> > +	IOCTL_INFO_FNC(VIDIOC_QUERYBUF_TIME32, v4l_querybuf_time32, v4l_print_buffer_time32, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
> > +#endif
> 
> This doesn't work. These IOCTL macros use the ioctl nr as the index in the array. Since
> VIDIOC_QUERYBUF and VIDIOC_QUERYBUF_TIME32 have the same index, this will fail.

Ah, I see. No idea why that did not cause a compile-time error. I got some
errors for duplicate 'case' values when the structures are the same size
(that's why we need the '#ifdef CONFIG_64BIT' in some places) but not here.

> I think (not 100% certain, there may be better suggestions) that the conversion is best
> done in video_usercopy(): just before func() is called have a switch for the TIME32
> variants, convert to the regular variant, call func() and convert back.

Does the handler have access to the _IOC_SIZE() value that was passed? If
it does, we could add a conditional inside of v4l_querybuf().
I did not see an easy way to do that though.

> My only concern here is that an additional v4l2_buffer struct (68 bytes) is needed on the
> stack. I don't see any way around that, though.

Agreed.

> > +struct v4l2_buffer_time32 {
> > +	__u32			index;
> > +	__u32			type;
> > +	__u32			bytesused;
> > +	__u32			flags;
> > +	__u32			field;
> > +	struct {
> > +		__s32		tv_sec;
> > +		__s32		tv_usec;
> > +	}			timestamp;
> > +	struct v4l2_timecode	timecode;
> > +	__u32			sequence;
> > +
> > +	/* memory location */
> > +	__u32			memory;
> > +	union {
> > +		__u32           offset;
> > +		unsigned long   userptr;
> > +		struct v4l2_plane *planes;
> > +		__s32		fd;
> > +	} m;
> > +	__u32			length;
> > +	__u32			reserved2;
> > +	__u32			reserved;
> > +};
> 
> Should this be part of a public API at all? Userspace will never use this struct
> or the TIME32 ioctls in the source code, right? This would be more appropriate for
> v4l2-ioctl.h.

Yes, makes sense. I think for the other structures I just enclosed them
inside #ifdef __KERNEL__ so they get stripped at 'make headers_install'
time, but I forgot to do that here.

My intention was to keep the structure close to the other one, so any
changes to them would be more likely to make it into both versions.

Let me know if you prefer to have an #ifdef added here, or if I should
move all three structures to v4l2-ioctl.h.

Thanks a lot for the review!

	Arnd
