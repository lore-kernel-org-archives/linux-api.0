From: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: Re: [PATCH/RFC 1/2] v4l: Repurpose the v4l2_plane data_offset field
Date: Wed, 15 Apr 2015 23:37:27 +0300
Message-ID: <1663968.IkQMnejUTA@avalon>
References: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com> <1429040689-23808-2-git-send-email-laurent.pinchart@ideasonboard.com> <20150414201004.GA27451@valkosipuli.retiisi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150414201004.GA27451-S+BSfZ9RZZmRSg0ZkenSGLdO1Tsj/99ntUK59QYPAWc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sakari Ailus <sakari.ailus-X3B1VOXEql0@public.gmane.org>
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Pawel Osciak <pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Sakari,

Thank you for the review.

On Tuesday 14 April 2015 23:10:05 Sakari Ailus wrote:
> On Tue, Apr 14, 2015 at 10:44:48PM +0300, Laurent Pinchart wrote:
> > The data_offset field has been introduced along with the multiplane API
> > to convey header size information between kernelspace and userspace.
> > It's not used by any mainline driver except vivid (for testing purpose).
> > 
> > A different data offset is needed to allow data capture to or data
> > output from a userspace-selected offset within a buffer (mainly for the
> > DMABUF and MMAP memory types). As the data_offset field already has the
> > right name and is unused, repurpose it.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
> > ---
> > 
> >  Documentation/DocBook/media/v4l/io.xml | 19 +++++++++++--------
> >  include/uapi/linux/videodev2.h         |  6 ++++--
> >  2 files changed, 15 insertions(+), 10 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/io.xml
> > b/Documentation/DocBook/media/v4l/io.xml index 1c17f80..416c05a 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -870,7 +870,7 @@ should set this to 0.</entry>
> > 
> >  	      If the application sets this to 0 for an output stream, then
> >  	      <structfield>bytesused</structfield> will be set to the size of
> >  	      the
> >  	      plane (see the <structfield>length</structfield> field of this
> >  	      struct)
> > -	      by the driver. Note that the actual image data starts at
> > +	      by the driver. Note that the actual plane data content starts 
at
> >  	      <structfield>data_offset</structfield> which may not be 
0.</entry>
> >  	  </row>
> >  	  <row>
> > @@ -917,13 +917,16 @@ should set this to 0.</entry>
> >  	    <entry>__u32</entry>
> >  	    <entry><structfield>data_offset</structfield></entry>
> >  	    <entry></entry>
> > -	    <entry>Offset in bytes to video data in the plane.
> > -	      Drivers must set this field when 
<structfield>type</structfield>
> > -	      refers to an input stream, applications when it refers to an
> > output stream. -	      Note that data_offset is included in
> > <structfield>bytesused</structfield>. -	      So the size of the image 
in
> > the plane is
> > -	     
> > <structfield>bytesused</structfield>-<structfield>data_offset</structfiel
> > d> at -	      offset <structfield>data_offset</structfield> from the 
start
> > of the plane. +	    <entry>Offset in bytes from the start of the plane
> > buffer to the start of +	      captured or output data. Applications 
set
> > this field for all stream types +	      when calling the <link
> > linkend="vidioc-qbuf">VIDIOC_PREPARE_BUF</link> or +	      <link
> > linkend="vidioc-qbuf">VIDIOC_QBUF</link> ioctls to instruct the driver +	
> >      to capture or output data starting at an offset in the plane buffer.
> > If the +	      requested data offset doesn't match device or driver
> > constraints, device +	      drivers must return the &EINVAL; and either
> > leave the field value untouched +	      if they support data offsets, 
or
> > set it to 0 if they don't support data +	      offsets at all. Note that
> > <structfield>data_offset</structfield> is not +	      included in
> > <structfield>bytesused</structfield>.
> 
> At most 80 characters per line would be nice.

I've followed the coding style of the file, but I can certainly change that, 
no issue.

> How does the user discover what data_offsets are possible if the driver
> returns an error if the data_offset does not match hardware capabilities?
> 
> I'd rather have the driver to adjust data_offset to match what it can do. If
> the user needs to know that the data_offset was not modified, it should
> check the field value after QBUF/PREPARE_BUF.

I've discussed this with Hans before, and we thought negotiating data_offset 
wasn't very useful. data_offset values used by applications are pretty much 
mandatory, if you need to write the UV plane of an NV12 image at a given 
offset in a Y+UV contiguous buffer, using a different negotiated offset is 
pointless. Feel free to point us to use cases though.

> >  	    </entry>
> >  	  </row>
> >  	  <row>
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h index fa376f7..261fb66 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -706,8 +706,10 @@ struct v4l2_requestbuffers {
> >   *			pointing to this plane
> >   * @fd:			when memory is V4L2_MEMORY_DMABUF, a userspace file
> >   *			descriptor associated with this plane
> > - * @data_offset:	offset in the plane to the start of data; usually 0,
> > - *			unless there is a header in front of the data
> > + * @data_offset:	offset in bytes from the start of the plane buffer to
> > + *			the start of data; usually 0 unless applications need to
> > + *			capture data to or output data from elsewhere than the
> > + *			start of the buffer
> >   *
> >   * Multi-planar buffers consist of one or more planes, e.g. an YCbCr
> >   buffer
> >   * with two planes can have one plane for Y, and another for interleaved
> >   CbCr

-- 
Regards,

Laurent Pinchart
