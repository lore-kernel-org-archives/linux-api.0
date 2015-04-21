From: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 0/8] vhost: support for cross endian guests
Date: Tue, 21 Apr 2015 09:50:29 +0200
Message-ID: <20150421095029.6d53ff35@bahia.local>
References: <20150410101500.31843.61248.stgit@bahia.local>
	<20150417111813.2b795b2c@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150417111813.2b795b2c-GiB8zCg7hOfDOqzlkpFKJg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 17 Apr 2015 11:18:13 +0200
Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> On Fri, 10 Apr 2015 12:15:00 +0200
> Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> 
> > Hi,
> > 
> > This patchset allows vhost to be used with legacy virtio when guest and host
> > have a different endianness.
> > 
> > Patch 7 got rewritten according to Cornelia's and Michael's comments. I have
> > also introduced patch 8 that brings BE vnet headers support to tun/macvtap.
> > 
> > This series is enough to have vhost_net working flawlessly. I could
> > succesfully reboot guests from ppc64 to ppc64le and vice-versa on ppc64
> > and ppc64le hosts.
> > 
> 
> Michael,
> 
> I am ready to post v5 with the changes suggested by Cornelia... Do you have any
> extra comments on this v4 ? 
> 

Ping ?

> --
> Greg
> 
> > ---
> > 
> > Greg Kurz (8):
> >       virtio: introduce virtio_is_little_endian() helper
> >       tun: add tun_is_little_endian() helper
> >       macvtap: introduce macvtap_is_little_endian() helper
> >       vringh: introduce vringh_is_little_endian() helper
> >       vhost: introduce vhost_is_little_endian() helper
> >       virtio: add explicit big-endian support to memory accessors
> >       vhost: feature to set the vring endianness
> >       macvtap/tun: add VNET_BE flag
> > 
> > 
> >  drivers/net/Kconfig              |   12 ++++++
> >  drivers/net/macvtap.c            |   69 ++++++++++++++++++++++++++++++++++-
> >  drivers/net/tun.c                |   71 +++++++++++++++++++++++++++++++++++-
> >  drivers/vhost/Kconfig            |   10 +++++
> >  drivers/vhost/vhost.c            |   76 ++++++++++++++++++++++++++++++++++++++
> >  drivers/vhost/vhost.h            |   25 ++++++++++---
> >  include/linux/virtio_byteorder.h |   24 +++++++-----
> >  include/linux/virtio_config.h    |   19 +++++++---
> >  include/linux/vringh.h           |   19 +++++++---
> >  include/uapi/linux/if_tun.h      |    2 +
> >  include/uapi/linux/vhost.h       |    9 +++++
> >  11 files changed, 303 insertions(+), 33 deletions(-)
> > 
> > --
> > Greg
> > 
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> > 
> 
