From: Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 44/46] virtio_scsi: export to userspace
Date: Sun, 30 Nov 2014 21:43:23 +0000
Message-ID: <CA+V-a8t6Gp8XyCAM8DVFrhyJzN5wdEMv8nn59mCP1FP6QQLwXg@mail.gmail.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com> <1417359787-10138-45-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417359787-10138-45-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, rusty-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, thuth-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Bjarke Istrup Pedersen <gurligebis-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stephen hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Anup Patel <anup.patel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Michael,

Thanks for the patch.

On Sun, Nov 30, 2014 at 3:12 PM, Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Replace uXX by __uXX and _packed by __attribute((packed))
> as seems to be the norm for userspace headers.
>
> Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
>  include/uapi/linux/virtio_scsi.h | 74 ++++++++++++++++++++--------------------
>  include/uapi/linux/Kbuild        |  1 +

Probably worth making a separate patch for this ? as it doesnt
match with patch description aswel.

Apart from that patch looks good.

Acked-by: Lad, Prabhakar <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Regards,
--Prabhakar Lad
