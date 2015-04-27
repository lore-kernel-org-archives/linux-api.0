From: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 6/8] virtio: add explicit big-endian support to
 memory accessors
Date: Mon, 27 Apr 2015 11:14:22 +0200
Message-ID: <20150427111422.10564c9e.cornelia.huck@de.ibm.com>
References: <20150424122211.19156.97626.stgit@bahia.local>
	<20150424122521.19156.65586.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150424122521.19156.65586.stgit-GiB8zCg7hOfDOqzlkpFKJg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 24 Apr 2015 14:26:24 +0200
Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> The current memory accessors logic is:
> - little endian if little_endian
> - native endian (i.e. no byteswap) if !little_endian
> 
> If we want to fully support cross-endian vhost, we also need to be
> able to convert to big endian.
> 
> Instead of changing the little_endian argument to some 3-value enum, this
> patch changes the logic to:
> - little endian if little_endian
> - big endian if !little_endian
> 
> The native endian case is handled by all users with a trivial helper. This
> patch doesn't change any functionality, nor it does add overhead.
> 
> Signed-off-by: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
> 
> Changes since v5:
> - changed endian checking helpers as suggested by Thomas (use || and line
>   breaker)
> 
>  drivers/net/macvtap.c            |    3 ++-
>  drivers/net/tun.c                |    3 ++-
>  drivers/vhost/vhost.h            |    3 ++-
>  include/linux/virtio_byteorder.h |   24 ++++++++++++++----------
>  include/linux/virtio_config.h    |    3 ++-
>  include/linux/vringh.h           |    3 ++-
>  6 files changed, 24 insertions(+), 15 deletions(-)
> 

Reviewed-by: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
