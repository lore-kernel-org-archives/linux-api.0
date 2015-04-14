From: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] virtio_balloon: drop virtio_balloon_stat_modern
Date: Tue, 14 Apr 2015 12:13:27 +0200
Message-ID: <20150414121327.4caacfba.cornelia.huck@de.ibm.com>
References: <1429005625-23181-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429005625-23181-1-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 14 Apr 2015 12:01:13 +0200
"Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Looks like we are better off sticking with the misaligned stat struct,
> to reduce the amount of virtio 1 specific code in balloon.  So let's do
> it.
> 
> Add a detailed comment to reduce the chance people copy this bad example.
> 
> This also fixes a bug on BE architectures: tag should use
> cpu_to_le16, not cpu_to_le32.
> 
> Acked-by: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
> Just reposting so it's easier to apply.
> Feel free to squash into previous patch if you think it's
> neater.

+1 for squashing from me. My A-b would also apply to the squashed patch.
> 
>  include/uapi/linux/virtio_balloon.h | 33 +++++++++++++++++++++++++--------
>  drivers/virtio/virtio_balloon.c     | 19 ++++---------------
>  2 files changed, 29 insertions(+), 23 deletions(-)
