From: Sakari Ailus <sakari.ailus-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH/RFC 0/2] Repurpose the v4l2_plane data_offset field
Date: Wed, 22 Apr 2015 16:19:59 +0300
Message-ID: <20150422131959.GS27451@valkosipuli.retiisi.org.uk>
References: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <5530E01D.3050105@xs4all.nl>
 <20150418130415.GM27451@valkosipuli.retiisi.org.uk>
 <5534C405.9010307@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5534C405.9010307-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pawel Osciak <pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Hans,

On Mon, Apr 20, 2015 at 11:16:53AM +0200, Hans Verkuil wrote:
> Hi Sakari,
> 
> On 04/18/2015 03:04 PM, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Fri, Apr 17, 2015 at 12:27:41PM +0200, Hans Verkuil wrote:
> >> Hi Laurent,
> >>
> >> On 04/14/2015 09:44 PM, Laurent Pinchart wrote:
> >>> Hello,
> >>>
> >>> The v4l2_plane data_offset field has been introduced at the same time as the
> >>> the multiplane API to convey header size information between kernelspace and
> >>> userspace.
> >>>
> >>> The API then became slightly controversial, both because different developers
> >>> understood the purpose of the field differently (resulting for instance in an
> >>> out-of-tree driver abusing the field for a different purpose), and because of
> >>> competing proposals (see for instance "[RFC] Multi format stream support" at
> >>> http://www.spinics.net/lists/linux-media/msg69130.html).
> >>>
> >>> Furthermore, the data_offset field isn't used by any mainline driver except
> >>> vivid (for testing purpose).
> >>>
> >>> I need a different data offset in planes to allow data capture to or data
> >>> output from a userspace-selected offset within a buffer (mainly for the
> >>> DMABUF and MMAP memory types). As the data_offset field already has the
> >>> right name, is unused, and ill-defined, I propose repurposing it. This is what
> >>> this RFC is about.
> >>>
> >>> If the proposal is accepted I'll add another patch to update data_offset usage
> >>> in the vivid driver.
> >>
> >> I am skeptical about all this for a variety of reasons:
> >>
> >> 1) The data_offset field is well-defined in the spec. There really is no doubt
> >> about the meaning of the field.
> > 
> > I think that's debatable. :-) The specification doesn't say much what the
> > data_offset is really about. For instance, it does not specify what may be
> > in the buffer before data_offset.
> 
> That's correct. Now, it is my view that, while it would be nice if a fourcc like
> value would be available to tell the format of that header, in practice that format
> is so tied to a specific type of hardware that you either know it (i.e. it is a custom
> app for that hardware), or you ignore it altogether. There may be some exceptions for
> somewhat standardized types of metadata (SMIA), but those never materialized as actual
> code.

At least not yet, and part of the reason is that we have no generic means to
pass that to tell which format if actually is and pass that to the user
space.

Also not every SMIA compliant sensor produces metadata at all.

When they do, however, there's often also a footer, of the same format than
the header. Some sensors produce statistics after that footer as well.

> > The kerneldoc documentation next to struct v4l2_plane suggests there might
> > be a header, but that's primarily for driver developers rather than users.
> > 
> > I, for instance, understood data_offset to mean essentially how this set
> > "re-purposes" it. I wonder if there are others who have originally
> > understood it as such.
> 
> I know it was mis-understood, the spec was fairly vague in the past, and while more
> specific you are right in that it does not actually tell the reason for the field
> (i.e. skip headers).
> 
> In no way can you re-purpose the field, though.
> 
> 1) It is in use.

How is it being used? It'd be nice to have a guesstimate for different
usages (the original intent vs. how apparently quite a few have understood
it).

> 2) If you thought it was confusing today, then that's nothing compared to the confusion
>    once you change the meaning from one kernel to another.
> 
> Either keep the current meaning and improve the specification, or deprecate it: warn
> when it is non-zero and just mark it as 'don't use' in the spec.
> 
> > 
> >>
> >> 2) We really don't know who else might be using it, or which applications might
> >> be using it (a lot of work was done in gstreamer recently, I wonder if data_offset
> >> support was implemented there).
> >>
> >> 3) You offer no alternative to this feature. Basically this is my main objection.
> >> It is not at all unusual to have headers in front of the frame data. We (Cisco)
> >> use it in one of our product series for example. And I suspect it is something that
> >> happens especially in systems with an FPGA that does custom processing, and those
> >> systems are exactly the ones that are generally not upstreamed and so are not
> >> visible to us.
> > 
> > If you have a header before the image, the header probably has a format as
> > well. Some headers are device specific whereas some are more generic. The
> > SMIA standard, for example, does specify a metadata (header or footer!)
> > format.
> > 
> > It'd be useful to be able to tell the user what kind of header there is. For
> > that, the header could be located on a different plane, with a specific
> > format.
> > 
> > There's room for format information in struct v4l2_plane_pix_format but
> > hardly much else. It still would cover a number of potential use cases.
> > 
> > I might still consider making the planes independent of each other;
> > conveniently there's 8 bytes of free space in struct v4l2_pix_format_mplane
> > for alternative plane related information. It'd be nice to be able to do
> > this without an additional buffer type since that's visible in a large
> > number of other places: there's plenty of room in struct v4l2_plane for
> > any video buffer related information.
> 
> Please don't confuse things: each struct v4l2_plane_pix_format relates to a
> single buffer that contains the data for that plane. If one buffer contains
> both metadata and actual image data, then that's all part of the same plane
> since it was all transferred to the buffer with the same DMA transfer.

The API does not prevent using the same DMA-BUF buffer (nor USERPTR for that
matter) on multiple planes. Then the question would be how would the user
know when to do that and when not. We could add a V4L2_PIX_FMT_FLAG telling
the plane uses the same memory buffer than the previous one, for instance.

Alternatively, one more layer of abstraction could be used: multi-format
planes. That would mean an array of one or more formatted sections inside a
plane. 

> 
> You cannot put the header/footer into separate planes since the only way to
> achieve that would be a memcpy and the header/footer would still be part of
> the actual plane data.

Assuming it's a separate memory buffer, yes.

For most of the time the hardware can do either one, but there could be
cases where the user would benefit from being able to choose. This can be
made easily by making no difference between a memory buffer with sections of
different formats and several memory buffers with a single format each.

> If the metadata arrives through its own DMA channel, then I would have no
> objection to seeing that as a separate plane. But I think in general that
> might be a bad idea because such metadata may come at an earlier/later time
> compared to the image data, and usually apps want to receive things asap.

Indeed. That's another interesting matter. Sometimes a part of e.g. a
statistics buffer may be interesting (and available from hardware) before
the entire buffer is done.

That was why the different parts of the frame were split into different
video buffer queues:

<URL:http://www.retiisi.org.uk/v4l2/foil/v4l2-multi-format.pdf>

But it won't help in all cases, like the one described above.

> 
> I still see it as a simple problem: I have a buffer, it contains a picture
> of a given pixel format, but there may be a header and (currently not implemented)
> a footer. Header and/or footer may have a format (also not implemented yet).
> 
> Applications can use the offsets to ignore all those headers/footers and just
> go straight to the image data. Or they use it to interpret the data in the
> headers/footers.
> 
> Perhaps it is a total lack of imagination, but I really cannot see what else
> it is you would need. Of course, you can think of really crazy schemes, but
> then you likely need to just use a new pixelformat since it is so crazy that
> it doesn't fit into anything existing.

The statistics I mentioned above; they are not related to the header or the
footer. It'd be very good to be able to describe them in a generic way;
adding a header and a footer support now in a way that recognises they're
the header and the footer is unlikely to be meaningfully extendable when
something else comes up.

These are still just examples, we all know hardware engineers have a
virtually unlimited imagination. :-)

> 
> The whole point of data_offset was that it is nuts to have to come up with a
> new pixelformat for otherwise standard pixelformats that just happen to have
> a header in front of them. You can't duplicate all pixel formats just for that.

I fully agree with the problem statement and the undesirable solution. :-)

> Proposals welcome!

I can send an RFC this or the next week, with more detailed description of
the use cases.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus-X3B1VOXEql0@public.gmane.org	XMPP: sailus-PCDdDYkjdNMDXYZnReoRVg@public.gmane.org
