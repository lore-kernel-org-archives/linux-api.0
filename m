From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 7/9] [media] v4l2: introduce v4l2_timeval
Date: Fri, 18 Sep 2015 11:09:48 +0200
Message-ID: <8200227.6XAMdOOJfW@wuerfel>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de> <1442524780-781677-8-git-send-email-arnd@arndb.de> <55FBC5B2.10808@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <55FBC5B2.10808@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Friday 18 September 2015 10:05:06 Hans Verkuil wrote:
> On 09/17/15 23:19, Arnd Bergmann wrote:
> > The v4l2 API uses a 'struct timeval' to communicate time stamps to user
> > space. This is broken on 32-bit architectures as soon as we have a C library
> > that defines time_t as 64 bit, which then changes the structure layout of
> > struct v4l2_buffer.
> > 
> > Since existing user space source code relies on the type to be 'struct
> > timeva' and we want to preserve compile-time compatibility when moving
> 
> s/timeva/timeval/

Fixed

> > to a new libc, we cannot make user-visible changes to the header file.
> > 
> > In this patch, we change the type of the timestamp to 'struct v4l2_timeval'
> 
> Don't we need a kernel-wide timeval64? Rather than adding a v4l2-specific
> struct?

I still hope to avoid doing that. All in-kernel users should be changed to
use timespec64 or ktime_t, which are always more efficient and accurate.

For the system call interface, all timeval APIs are deprecated and have
replacements using timespec64 (e.g. clock_gettime() replaces gettimeofday).

Only a handful of ioctls pass timeval, and so far my impression is that
we are better off handling each one separately. The total amount of code
we need to add this way should be less than if we have to duplicate all
common code functions that today operate on timeval and can eventually
get removed.

> > diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> > index 295fde5fdb75..df5daac6d099 100644
> > --- a/drivers/media/platform/vim2m.c
> > +++ b/drivers/media/platform/vim2m.c
> > @@ -235,7 +235,7 @@ static int device_process(struct vim2m_ctx *ctx,
> >  	in_vb->v4l2_buf.sequence = q_data->sequence++;
> >  	memcpy(&out_vb->v4l2_buf.timestamp,
> >  			&in_vb->v4l2_buf.timestamp,
> > -			sizeof(struct timeval));
> > +			sizeof(struct v4l2_timeval));
> >  	if (in_vb->v4l2_buf.flags & V4L2_BUF_FLAG_TIMECODE)
> >  		memcpy(&out_vb->v4l2_buf.timecode, &in_vb->v4l2_buf.timecode,
> >  			sizeof(struct v4l2_timecode));
> 
> See https://patchwork.linuxtv.org/patch/31405/
> 
> I'll merge that one for 4.4 very soon.

Ok.

	Arnd
