From: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 0/8] vhost: support for cross endian guests
Date: Tue, 12 May 2015 12:44:26 +0200
Message-ID: <20150512124426.4e487cb6@bahia.local>
References: <20150424122211.19156.97626.stgit@bahia.local>
	<20150424153137-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150424153137-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 24 Apr 2015 15:31:54 +0200
"Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Fri, Apr 24, 2015 at 02:24:15PM +0200, Greg Kurz wrote:
> > Only cosmetic and documentation changes since v5.
> > 
> > ---
> 
> Looks sane to me. I plan to review and apply next week.
> 

Hi Michael,

I realize you just got back and have tons of things to do... Do
you still plan to apply shortly ? Would you also have time to
comment the QEMU part ?

Thanks.

--
Greg

> > Greg Kurz (8):
> >       virtio: introduce virtio_is_little_endian() helper
> >       tun: add tun_is_little_endian() helper
> >       macvtap: introduce macvtap_is_little_endian() helper
> >       vringh: introduce vringh_is_little_endian() helper
> >       vhost: introduce vhost_is_little_endian() helper
> >       virtio: add explicit big-endian support to memory accessors
> >       vhost: cross-endian support for legacy devices
> >       macvtap/tun: cross-endian support for little-endian hosts
> > 
> > 
> >  drivers/net/Kconfig              |   14 ++++++
> >  drivers/net/macvtap.c            |   66 +++++++++++++++++++++++++++++-
> >  drivers/net/tun.c                |   68 ++++++++++++++++++++++++++++++
> >  drivers/vhost/Kconfig            |   15 +++++++
> >  drivers/vhost/vhost.c            |   85 ++++++++++++++++++++++++++++++++++++++
> >  drivers/vhost/vhost.h            |   25 ++++++++---
> >  include/linux/virtio_byteorder.h |   24 ++++++-----
> >  include/linux/virtio_config.h    |   18 +++++---
> >  include/linux/vringh.h           |   18 +++++---
> >  include/uapi/linux/if_tun.h      |    6 +++
> >  include/uapi/linux/vhost.h       |   14 ++++++
> >  11 files changed, 320 insertions(+), 33 deletions(-)
> > 
> > --
> > Greg
> 
