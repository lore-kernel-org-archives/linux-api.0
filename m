From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 0/8] vhost: support for cross endian guests
Date: Fri, 24 Apr 2015 15:31:54 +0200
Message-ID: <20150424153137-mutt-send-email-mst@redhat.com>
References: <20150424122211.19156.97626.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150424122211.19156.97626.stgit-GiB8zCg7hOfDOqzlkpFKJg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 24, 2015 at 02:24:15PM +0200, Greg Kurz wrote:
> Only cosmetic and documentation changes since v5.
> 
> ---

Looks sane to me. I plan to review and apply next week.

> Greg Kurz (8):
>       virtio: introduce virtio_is_little_endian() helper
>       tun: add tun_is_little_endian() helper
>       macvtap: introduce macvtap_is_little_endian() helper
>       vringh: introduce vringh_is_little_endian() helper
>       vhost: introduce vhost_is_little_endian() helper
>       virtio: add explicit big-endian support to memory accessors
>       vhost: cross-endian support for legacy devices
>       macvtap/tun: cross-endian support for little-endian hosts
> 
> 
>  drivers/net/Kconfig              |   14 ++++++
>  drivers/net/macvtap.c            |   66 +++++++++++++++++++++++++++++-
>  drivers/net/tun.c                |   68 ++++++++++++++++++++++++++++++
>  drivers/vhost/Kconfig            |   15 +++++++
>  drivers/vhost/vhost.c            |   85 ++++++++++++++++++++++++++++++++++++++
>  drivers/vhost/vhost.h            |   25 ++++++++---
>  include/linux/virtio_byteorder.h |   24 ++++++-----
>  include/linux/virtio_config.h    |   18 +++++---
>  include/linux/vringh.h           |   18 +++++---
>  include/uapi/linux/if_tun.h      |    6 +++
>  include/uapi/linux/vhost.h       |   14 ++++++
>  11 files changed, 320 insertions(+), 33 deletions(-)
> 
> --
> Greg
