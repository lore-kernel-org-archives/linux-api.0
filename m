From: "Zhi, Yong" <yong.zhi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/2] Add V4L2_BUF_TYPE_META_OUTPUT buffer type
Date: Tue, 17 Oct 2017 23:04:53 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE2A376@ORSMSX106.amr.corp.intel.com>
References: <1503091856-18294-1-git-send-email-sakari.ailus@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503091856-18294-1-git-send-email-sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tfiga-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <tfiga-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Mani, Rajmohan" <rajmohan.mani-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi, Sakari,

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org]
> Sent: Friday, August 18, 2017 2:31 PM
> To: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; tfiga-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org; Zhi, Yong
> <yong.zhi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: [PATCH 0/2] Add V4L2_BUF_TYPE_META_OUTPUT buffer type
> 
> Hi folks,
> 
> Here's a non-RFC version of the META_OUTPUT buffer type patches.
> 
> The V4L2_BUF_TYPE_META_OUTPUT buffer type complements the metadata
> buffer types support for OUTPUT buffers, capture being already supported.
> This is intended for similar cases than V4L2_BUF_TYPE_META_CAPTURE but
> for output buffers, e.g. device parameters that may be complex and highly
> hierarchical data structure. Statistics are a current use case for metadata
> capture buffers.
> 
> Yong: could you take these to your IPU3 ImgU patchset, please? As that
> would be the first user, the patches would be merged with the driver itself.
> 

We implemented the meta format support in IPU3, the changes will be in ImgU v4, thanks!!

> since RFC:
> 
> - Fix make htmldocs build.
> 
> - Fix CAPTURE -> OUTPUT in buffer.rst.
> 
> - Added " for specifying how the device processes images" in the
>   documentation.
> 
> Sakari Ailus (2):
>   v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
>   docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT interface
> 
>  Documentation/media/uapi/v4l/buffer.rst          |  3 +++
>  Documentation/media/uapi/v4l/dev-meta.rst        | 33 ++++++++++++++------
> ----
>  Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 +++
>  Documentation/media/videodev2.h.rst.exceptions   |  2 ++
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |  2 ++
>  drivers/media/v4l2-core/v4l2-ioctl.c             | 25 ++++++++++++++++++
>  drivers/media/v4l2-core/videobuf2-v4l2.c         |  1 +
>  include/media/v4l2-ioctl.h                       | 17 ++++++++++++
>  include/uapi/linux/videodev2.h                   |  2 ++
>  9 files changed, 75 insertions(+), 13 deletions(-)
> 
> --
> 2.7.4
