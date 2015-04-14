From: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: [PATCH/RFC 0/2] Repurpose the v4l2_plane data_offset field
Date: Tue, 14 Apr 2015 22:44:47 +0300
Message-ID: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Pawel Osciak <pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

The v4l2_plane data_offset field has been introduced at the same time as the
the multiplane API to convey header size information between kernelspace and
userspace.

The API then became slightly controversial, both because different developers
understood the purpose of the field differently (resulting for instance in an
out-of-tree driver abusing the field for a different purpose), and because of
competing proposals (see for instance "[RFC] Multi format stream support" at
http://www.spinics.net/lists/linux-media/msg69130.html).

Furthermore, the data_offset field isn't used by any mainline driver except
vivid (for testing purpose).

I need a different data offset in planes to allow data capture to or data
output from a userspace-selected offset within a buffer (mainly for the
DMABUF and MMAP memory types). As the data_offset field already has the
right name, is unused, and ill-defined, I propose repurposing it. This is what
this RFC is about.

If the proposal is accepted I'll add another patch to update data_offset usage
in the vivid driver.

Laurent Pinchart (2):
  v4l: Repurpose the v4l2_plane data_offset field
  videobuf2: Repurpose the v4l2_plane data_offset field

 Documentation/DocBook/media/v4l/io.xml   | 19 +++++++------
 drivers/media/v4l2-core/videobuf2-core.c | 46 +++++++++++++++++++++++---------
 include/media/videobuf2-core.h           |  4 +++
 include/media/videobuf2-dma-contig.h     |  2 +-
 include/uapi/linux/videodev2.h           |  6 +++--
 5 files changed, 54 insertions(+), 23 deletions(-)

-- 
Regards,

Laurent Pinchart
