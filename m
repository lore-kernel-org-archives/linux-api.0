From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 0/4] Add support for V4L2_PIX_FMT_Y16_BE
Date: Mon, 18 May 2015 16:26:57 -0300
Message-ID: <20150518162657.031a86fc@recife.lan>
References: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430726852-11715-1-git-send-email-ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ramakrishnan Muthukrishnan <ramakrmu-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Em Mon,  4 May 2015 10:07:28 +0200
Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> escreveu:

> New pixel format type Y16_BE (16 bits greyscale big-endian).
> 
> Once I get the fist feedback on this patch I will send the patches for
> v4lconvert and qv4l2.

Hmm...

	Error: no ID for constraint linkend: V4L2-PIX-FMT-Y16-BE.

Where's the documentation for this new format?

Regards,
Mauro


> 
> 
> Thanks
> 
> Ricardo Ribalda Delgado (4):
>   media/vivid: Add support for Y16 format
>   media/v4l2-core: Add support for V4L2_PIX_FMT_Y16_BE
>   media/vivid: Add support for Y16_BE format
>   media/vivid: Code cleanout
> 
>  drivers/media/platform/vivid/vivid-tpg.c        | 20 ++++++++++++++++----
>  drivers/media/platform/vivid/vivid-vid-common.c | 16 ++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c            |  1 +
>  include/uapi/linux/videodev2.h                  |  1 +
>  4 files changed, 34 insertions(+), 4 deletions(-)
> 
