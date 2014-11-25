From: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 13/42] virtio_blk: v1.0 support
Date: Tue, 25 Nov 2014 18:55:16 +0100
Message-ID: <20141125185516.7570c6e7.cornelia.huck@de.ibm.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-14-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416933600-21398-14-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, rusty-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Thomas Huth <thuth-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Hildenbrand <dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 25 Nov 2014 18:42:18 +0200
"Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Based on patch by Cornelia Huck.
> 
> Note: for consistency, and to avoid sparse errors,
>       convert all fields, even those no longer in use
>       for virtio v1.0.
> 
> Reviewed-by: Thomas Huth <thuth-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Reviewed-by: David Hildenbrand <dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Signed-off-by: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/uapi/linux/virtio_blk.h | 15 ++++-----
>  drivers/block/virtio_blk.c      | 70 ++++++++++++++++++++++++-----------------
>  2 files changed, 49 insertions(+), 36 deletions(-)
> 

Is this sufficiently unchanged so that the original r-bs still hold?
