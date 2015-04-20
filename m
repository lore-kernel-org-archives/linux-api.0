From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH/RFC 0/2] Repurpose the v4l2_plane data_offset field
Date: Mon, 20 Apr 2015 11:34:44 +0200
Message-ID: <5534C834.6000001@xs4all.nl>
References: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com> <5530E01D.3050105@xs4all.nl> <7986966.gGAFkYegjs@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7986966.gGAFkYegjs@avalon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pawel Osciak <pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/17/2015 02:53 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 17 April 2015 12:27:41 Hans Verkuil wrote:
>> On 04/14/2015 09:44 PM, Laurent Pinchart wrote:
>>> Hello,
>>>
>>> The v4l2_plane data_offset field has been introduced at the same time as
>>> the the multiplane API to convey header size information between
>>> kernelspace and userspace.
>>>
>>> The API then became slightly controversial, both because different
>>> developers understood the purpose of the field differently (resulting for
>>> instance in an out-of-tree driver abusing the field for a different
>>> purpose), and because of competing proposals (see for instance "[RFC]
>>> Multi format stream support" at
>>> http://www.spinics.net/lists/linux-media/msg69130.html).
>>>
>>> Furthermore, the data_offset field isn't used by any mainline driver
>>> except vivid (for testing purpose).
>>>
>>> I need a different data offset in planes to allow data capture to or data
>>> output from a userspace-selected offset within a buffer (mainly for the
>>> DMABUF and MMAP memory types). As the data_offset field already has the
>>> right name, is unused, and ill-defined, I propose repurposing it. This is
>>> what this RFC is about.
>>>
>>> If the proposal is accepted I'll add another patch to update data_offset
>>> usage in the vivid driver.
>>
>> I am skeptical about all this for a variety of reasons:
> 
> That's all good, it's an RFC :-)
> 
>> 1) The data_offset field is well-defined in the spec. There really is no
>> doubt about the meaning of the field.
> 
> I only partly agree. I believe the purpose of the data_offset field to be 
> clear among the core V4L2 developers, but the documentation isn't precise 
> enough. I've seen out-of-tree drivers using the data_offset field for other 
> purposes than specifying the header size. The situation is a bit better now 
> that videobuf2 handles the field properly (and avoids copying it from user to 
> kernel for capture devices for instance), but there are still many users of 
> older kernels.
> 
> This being said, the problem wouldn't be difficult to fix, it just requires a 
> documentation patch.
> 
>> 2) We really don't know who else might be using it, or which applications
>> might be using it (a lot of work was done in gstreamer recently, I wonder
>> if data_offset support was implemented there).
> 
> It's funny you mention that. I cloned the gstreamer repositories and tried to 
> investigate. The gstreamer v4l2 elements started using data_offset a year ago 
> in
> 
> commit 92bdd596f2b07dbf4ccc9b8bf3d17620d44f131a
> Author: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
> Date:   Fri Apr 11 17:10:11 2014 -0400
> 
>     v4l2: Add DMABUF and USERPTR importation
> 
> (I've CC'ed Nicolas to this e-mail)
> 
> I'm not too familiar with the latest gstreamer code, but after a first 
> investigation it seems that gstreamer uses the data_offset field for the 
> purpose introduced by this patch, not to convey the header size. One more 
> argument in favour of repurposing the field ;-)
> 
>> 3) You offer no alternative to this feature. Basically this is my main
>> objection. It is not at all unusual to have headers in front of the frame
>> data. We (Cisco) use it in one of our product series for example. And I
>> suspect it is something that happens especially in systems with an FPGA
>> that does custom processing, and those systems are exactly the ones that
>> are generally not upstreamed and so are not visible to us.
>>
>> IMHO the functionality it provides is very much relevant, and I would like
>> to see an alternative in place before it is repurposed.
>>
>> But frankly, I really don't see why you would want to repurpose it. Adding a
>> new field (buf_offset) would do exactly what you want it to do without
>> causing an ABI change.
>>
>> Should we ever implement a better alternative for data_offset, then that
>> field can be renamed to 'reserved2' or whatever at some point.
>>
>> Frankly, I don't think data_offset is all that bad. What is missing is info
>> about the format (so add a 'data_format' field) and possible similar info
>> about a footer (footer_size, footer_format). Yes, the name could have been
>> better (header_size), but nobody is perfect...
> 
> I totally agree that the functionality is relevant, and we certainly need an 
> API for that.
> 
> My point, however, was twofold : I believe we need a better (as in more 
> powerful) API than data_offset to specify plane content, and the current usage 
> of data_offset in out-of-tree drivers, and it seems in gstreamer too, is 
> different than what we had intended the field to be used for.
> 
> For those two reasons, I believe it would make sense to repurpose the field 
> and introduce a new API to specify information about the plane content. Let's 
> kickstart the discussion :-)
> 
> The following information comes to my mind as being useful to specify:
> 
> - format
> - header size
> - footer size
> 
> There is, however, another point I'd like to raise. I'm working on an H.264 
> encoder that produces slices without headers. Userspace is thus responsible 
> for filling the headers, based on information produced by the encoder.
> 
> When a capture buffer at the output of the encoder contains a single slice, 
> that's pretty easy to handle. Userspace can use data_offset (in its new 
> purpose, or buf_offset if we decide to introduce a new field instead) to 
> reserve space for a header if the header size is known in advance by the 
> application, or the driver (or possibly the device) can reserve space for the 
> header and report the header size.
> 
> However, a capture buffer can contain multiple slices, with gaps between the 
> slices for the headers. The position and size of the gaps need to be known by 
> the application. I'm not sure yet if userspace can compute them, or if they're 
> dynamic and need to be passed from the driver to the application on a per-
> frame basis. In the latter case I would need more than a header size and 
> footer size per plane.

I wonder if the current V4L2_PIX_FMT_H264* fourcc formats support multiple slices
in one buffer. Kamil might know. But I suspect you'll have to make a new fourcc
for that. Just for reference you might want to look at VIDIOC_G_ENC_INDEX (used
by ivtv) for a somewhat similar purpose. It's an old API, and I would probably not
recommend reusing this, but it may be interesting.

Is the size of the gaps programmable in the H.264 encoder hardware?

In any case, I believe your particular use-case has absolutely nothing to do with
headers/footers in a plane (the original topic). Your headers are intrinsic to the
format, i.e. without them applications cannot handle the stream. Filling those in
is the responsibility of the whole stack (driver + any libv4l plugin) leading to a
valid data buffer.

The headers/footers in the original use-case are just due to metadata that hardware
decides to throw in for whoever is interested (or in some cases it's just garbage)
and that are not part of the actual image data.

Regards,

	Hans
