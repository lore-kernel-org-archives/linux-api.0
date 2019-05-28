From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 6/7] block: Add block layer notifications
Date: Tue, 28 May 2019 22:37:36 +0200
Message-ID: <CAG48ez0iRCyRdMBRPPkFJP-wuiLN=VcpfHLM9cV_Cvc3z2d=+Q@mail.gmail.com>
References: <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905935953.7587.11815678364029606128.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155905935953.7587.11815678364029606128.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 6:05 PM David Howells <dhowells@redhat.com> wrote:
> Add a block layer notification mechanism whereby notifications about
> block-layer events such as I/O errors, can be reported to a monitoring
> process asynchronously.
[...]
> +#ifdef CONFIG_BLK_NOTIFICATIONS
> +static const enum block_notification_type blk_notifications[] = {
> +       [BLK_STS_TIMEOUT]       = NOTIFY_BLOCK_ERROR_TIMEOUT,
> +       [BLK_STS_NOSPC]         = NOTIFY_BLOCK_ERROR_NO_SPACE,
> +       [BLK_STS_TRANSPORT]     = NOTIFY_BLOCK_ERROR_RECOVERABLE_TRANSPORT,
> +       [BLK_STS_TARGET]        = NOTIFY_BLOCK_ERROR_CRITICAL_TARGET,
> +       [BLK_STS_NEXUS]         = NOTIFY_BLOCK_ERROR_CRITICAL_NEXUS,
> +       [BLK_STS_MEDIUM]        = NOTIFY_BLOCK_ERROR_CRITICAL_MEDIUM,
> +       [BLK_STS_PROTECTION]    = NOTIFY_BLOCK_ERROR_PROTECTION,
> +       [BLK_STS_RESOURCE]      = NOTIFY_BLOCK_ERROR_KERNEL_RESOURCE,
> +       [BLK_STS_DEV_RESOURCE]  = NOTIFY_BLOCK_ERROR_DEVICE_RESOURCE,
> +       [BLK_STS_IOERR]         = NOTIFY_BLOCK_ERROR_IO,
> +};
> +#endif
> +
>  blk_status_t errno_to_blk_status(int errno)
>  {
>         int i;
> @@ -179,6 +194,19 @@ static void print_req_error(struct request *req, blk_status_t status)
>                                 req->rq_disk ?  req->rq_disk->disk_name : "?",
>                                 (unsigned long long)blk_rq_pos(req),
>                                 req->cmd_flags);
> +
> +#ifdef CONFIG_BLK_NOTIFICATIONS
> +       if (blk_notifications[idx]) {

If you have this branch here, that indicates that blk_notifications
might be sparse - but at the same time, blk_notifications is not
defined in a way that explicitly ensures that it has as many elements
as blk_errors. It might make sense to add an explicit length to the
definition of blk_notifications - something like "static const enum
block_notification_type blk_notifications[ARRAY_SIZE(blk_errors)]"
maybe?

> +               struct block_notification n = {
> +                       .watch.type     = WATCH_TYPE_BLOCK_NOTIFY,
> +                       .watch.subtype  = blk_notifications[idx],
> +                       .watch.info     = sizeof(n),
> +                       .dev            = req->rq_disk ? disk_devt(req->rq_disk) : 0,
> +                       .sector         = blk_rq_pos(req),
> +               };
> +               post_block_notification(&n);
> +       }
> +#endif
>  }
