From: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH/RFC 1/2] v4l: Repurpose the v4l2_plane data_offset field
Date: Tue, 14 Apr 2015 23:10:05 +0300
Message-ID: <20150414201004.GA27451@valkosipuli.retiisi.org.uk>
References: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1429040689-23808-2-git-send-email-laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-media-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429040689-23808-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-api@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>, Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Hi Laurent,

Thank you for the patchset.

On Tue, Apr 14, 2015 at 10:44:48PM +0300, Laurent Pinchart wrote:
> The data_offset field has been introduced along with the multiplane API
> to convey header size information between kernelspace and userspace.
> It's not used by any mainline driver except vivid (for testing purpose).
> 
> A different data offset is needed to allow data capture to or data
> output from a userspace-selected offset within a buffer (mainly for the
> DMABUF and MMAP memory types). As the data_offset field already has the
> right name and is unused, repurpose it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/DocBook/media/v4l/io.xml | 19 +++++++++++--------
>  include/uapi/linux/videodev2.h         |  6 ++++--
>  2 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 1c17f80..416c05a 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -870,7 +870,7 @@ should set this to 0.</entry>
>  	      If the application sets this to 0 for an output stream, then
>  	      <structfield>bytesused</structfield> will be set to the size of the
>  	      plane (see the <structfield>length</structfield> field of this struct)
> -	      by the driver. Note that the actual image data starts at
> +	      by the driver. Note that the actual plane data content starts at
>  	      <structfield>data_offset</structfield> which may not be 0.</entry>
>  	  </row>
>  	  <row>
> @@ -917,13 +917,16 @@ should set this to 0.</entry>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>data_offset</structfield></entry>
>  	    <entry></entry>
> -	    <entry>Offset in bytes to video data in the plane.
> -	      Drivers must set this field when <structfield>type</structfield>
> -	      refers to an input stream, applications when it refers to an output stream.
> -	      Note that data_offset is included in <structfield>bytesused</structfield>.
> -	      So the size of the image in the plane is
> -	      <structfield>bytesused</structfield>-<structfield>data_offset</structfield> at
> -	      offset <structfield>data_offset</structfield> from the start of the plane.
> +	    <entry>Offset in bytes from the start of the plane buffer to the start of
> +	      captured or output data. Applications set this field for all stream types
> +	      when calling the <link linkend="vidioc-qbuf">VIDIOC_PREPARE_BUF</link> or
> +	      <link linkend="vidioc-qbuf">VIDIOC_QBUF</link> ioctls to instruct the driver
> +	      to capture or output data starting at an offset in the plane buffer. If the
> +	      requested data offset doesn't match device or driver constraints, device
> +	      drivers must return the &EINVAL; and either leave the field value untouched
> +	      if they support data offsets, or set it to 0 if they don't support data
> +	      offsets at all. Note that <structfield>data_offset</structfield> is not
> +	      included in <structfield>bytesused</structfield>.

At most 80 characters per line would be nice.

How does the user discover what data_offsets are possible if the driver
returns an error if the data_offset does not match hardware capabilities?

I'd rather have the driver to adjust data_offset to match what it can do. If
the user needs to know that the data_offset was not modified, it should
check the field value after QBUF/PREPARE_BUF.

>  	    </entry>
>  	  </row>
>  	  <row>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index fa376f7..261fb66 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -706,8 +706,10 @@ struct v4l2_requestbuffers {
>   *			pointing to this plane
>   * @fd:			when memory is V4L2_MEMORY_DMABUF, a userspace file
>   *			descriptor associated with this plane
> - * @data_offset:	offset in the plane to the start of data; usually 0,
> - *			unless there is a header in front of the data
> + * @data_offset:	offset in bytes from the start of the plane buffer to
> + *			the start of data; usually 0 unless applications need to
> + *			capture data to or output data from elsewhere than the
> + *			start of the buffer
>   *
>   * Multi-planar buffers consist of one or more planes, e.g. an YCbCr buffer
>   * with two planes can have one plane for Y, and another for interleaved CbCr

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
