From: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH/RFC 0/2] Repurpose the v4l2_plane data_offset field
Date: Sat, 18 Apr 2015 16:04:15 +0300
Message-ID: <20150418130415.GM27451@valkosipuli.retiisi.org.uk>
References: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <5530E01D.3050105@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-media-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5530E01D.3050105@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, linux-api@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>, Pawel Osciak <pawel@osciak.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Hi Hans,

On Fri, Apr 17, 2015 at 12:27:41PM +0200, Hans Verkuil wrote:
> Hi Laurent,
> 
> On 04/14/2015 09:44 PM, Laurent Pinchart wrote:
> > Hello,
> > 
> > The v4l2_plane data_offset field has been introduced at the same time as the
> > the multiplane API to convey header size information between kernelspace and
> > userspace.
> > 
> > The API then became slightly controversial, both because different developers
> > understood the purpose of the field differently (resulting for instance in an
> > out-of-tree driver abusing the field for a different purpose), and because of
> > competing proposals (see for instance "[RFC] Multi format stream support" at
> > http://www.spinics.net/lists/linux-media/msg69130.html).
> > 
> > Furthermore, the data_offset field isn't used by any mainline driver except
> > vivid (for testing purpose).
> > 
> > I need a different data offset in planes to allow data capture to or data
> > output from a userspace-selected offset within a buffer (mainly for the
> > DMABUF and MMAP memory types). As the data_offset field already has the
> > right name, is unused, and ill-defined, I propose repurposing it. This is what
> > this RFC is about.
> > 
> > If the proposal is accepted I'll add another patch to update data_offset usage
> > in the vivid driver.
> 
> I am skeptical about all this for a variety of reasons:
> 
> 1) The data_offset field is well-defined in the spec. There really is no doubt
> about the meaning of the field.

I think that's debatable. :-) The specification doesn't say much what the
data_offset is really about. For instance, it does not specify what may be
in the buffer before data_offset.

The kerneldoc documentation next to struct v4l2_plane suggests there might
be a header, but that's primarily for driver developers rather than users.

I, for instance, understood data_offset to mean essentially how this set
"re-purposes" it. I wonder if there are others who have originally
understood it as such.

> 
> 2) We really don't know who else might be using it, or which applications might
> be using it (a lot of work was done in gstreamer recently, I wonder if data_offset
> support was implemented there).
> 
> 3) You offer no alternative to this feature. Basically this is my main objection.
> It is not at all unusual to have headers in front of the frame data. We (Cisco)
> use it in one of our product series for example. And I suspect it is something that
> happens especially in systems with an FPGA that does custom processing, and those
> systems are exactly the ones that are generally not upstreamed and so are not
> visible to us.

If you have a header before the image, the header probably has a format as
well. Some headers are device specific whereas some are more generic. The
SMIA standard, for example, does specify a metadata (header or footer!)
format.

It'd be useful to be able to tell the user what kind of header there is. For
that, the header could be located on a different plane, with a specific
format.

There's room for format information in struct v4l2_plane_pix_format but
hardly much else. It still would cover a number of potential use cases.

I might still consider making the planes independent of each other;
conveniently there's 8 bytes of free space in struct v4l2_pix_format_mplane
for alternative plane related information. It'd be nice to be able to do
this without an additional buffer type since that's visible in a large
number of other places: there's plenty of room in struct v4l2_plane for
any video buffer related information.

Frame descriptors are not needed for this --- you're quite right in that.
But the frame descriptors, when implemented, will very probably need plane
specific formats in the end as not many receivers are able to separate
different parts of the image to different buffers.

> 
> IMHO the functionality it provides is very much relevant, and I would like to see
> an alternative in place before it is repurposed.
> 
> But frankly, I really don't see why you would want to repurpose it. Adding a new
> field (buf_offset) would do exactly what you want it to do without causing an ABI
> change.

I said I ok with adding buf_offset field, but it might not be the best
choice we can make: it's a temporary solution for a very specific problem,
leaves the API with similar field names with different meanings (data_offset
vs. buf_offset, where the other is about the header and the other about the
data) and is not extensible. In addition, the size of the header is not
specified; it might be smaller than what's between buf_offset and
data_offset. Some devices produce footers as well; currently we have no way
to specify how they are dealt with.

I'd like to at least investigate if we could have something more
future-proof for this purpose.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
