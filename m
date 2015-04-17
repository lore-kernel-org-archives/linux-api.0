From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH/RFC 0/2] Repurpose the v4l2_plane data_offset field
Date: Fri, 17 Apr 2015 12:27:41 +0200
Message-ID: <5530E01D.3050105@xs4all.nl>
References: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Cc: linux-api@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>, Pawel Osciak <pawel@osciak.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Hi Laurent,

On 04/14/2015 09:44 PM, Laurent Pinchart wrote:
> Hello,
> 
> The v4l2_plane data_offset field has been introduced at the same time as the
> the multiplane API to convey header size information between kernelspace and
> userspace.
> 
> The API then became slightly controversial, both because different developers
> understood the purpose of the field differently (resulting for instance in an
> out-of-tree driver abusing the field for a different purpose), and because of
> competing proposals (see for instance "[RFC] Multi format stream support" at
> http://www.spinics.net/lists/linux-media/msg69130.html).
> 
> Furthermore, the data_offset field isn't used by any mainline driver except
> vivid (for testing purpose).
> 
> I need a different data offset in planes to allow data capture to or data
> output from a userspace-selected offset within a buffer (mainly for the
> DMABUF and MMAP memory types). As the data_offset field already has the
> right name, is unused, and ill-defined, I propose repurposing it. This is what
> this RFC is about.
> 
> If the proposal is accepted I'll add another patch to update data_offset usage
> in the vivid driver.

I am skeptical about all this for a variety of reasons:

1) The data_offset field is well-defined in the spec. There really is no doubt
about the meaning of the field.

2) We really don't know who else might be using it, or which applications might
be using it (a lot of work was done in gstreamer recently, I wonder if data_offset
support was implemented there).

3) You offer no alternative to this feature. Basically this is my main objection.
It is not at all unusual to have headers in front of the frame data. We (Cisco)
use it in one of our product series for example. And I suspect it is something that
happens especially in systems with an FPGA that does custom processing, and those
systems are exactly the ones that are generally not upstreamed and so are not
visible to us.

IMHO the functionality it provides is very much relevant, and I would like to see
an alternative in place before it is repurposed.

But frankly, I really don't see why you would want to repurpose it. Adding a new
field (buf_offset) would do exactly what you want it to do without causing an ABI
change.

Should we ever implement a better alternative for data_offset, then that field can
be renamed to 'reserved2' or whatever at some point.

Frankly, I don't think data_offset is all that bad. What is missing is info about
the format (so add a 'data_format' field) and possible similar info about a footer
(footer_size, footer_format). Yes, the name could have been better (header_size),
but nobody is perfect...

Regards,

	Hans
