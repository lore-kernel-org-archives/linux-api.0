From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: kdbus: add code to gather metadata
Date: Wed, 29 Oct 2014 15:33:17 -0700
Message-ID: <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414620056-6675-7-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
>
> A connection chooses which metadata it wants to have attached to each
> message it receives with kdbus_cmd_hello.attach_flags. The metadata
> will be attached as items to the messages. All metadata refers to
> information about the sending task at sending time, unless otherwise
> stated. Also, the metadata is copied, not referenced, so even if the
> sending task doesn't exist anymore at the time the message is received,
> the information is still preserved.
>
> See kdbus.txt for more details on which metadata can currently be
> attached to messages.
>
> Signed-off-by: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> ---
>  drivers/misc/kdbus/metadata.c | 626 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/misc/kdbus/metadata.h |  51 ++++
>  2 files changed, 677 insertions(+)
>  create mode 100644 drivers/misc/kdbus/metadata.c
>  create mode 100644 drivers/misc/kdbus/metadata.h
>
> diff --git a/drivers/misc/kdbus/metadata.c b/drivers/misc/kdbus/metadata.c
> new file mode 100644
> index 000000000000..8323e6d7a071
> --- /dev/null
> +++ b/drivers/misc/kdbus/metadata.c
> @@ -0,0 +1,626 @@
> +/*
> + * Copyright (C) 2013-2014 Kay Sievers
> + * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> + * Copyright (C) 2013-2014 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
> + * Copyright (C) 2013-2014 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> + * Copyright (C) 2013-2014 Linux Foundation
> + *
> + * kdbus is free software; you can redistribute it and/or modify it under
> + * the terms of the GNU Lesser General Public License as published by the
> + * Free Software Foundation; either version 2.1 of the License, or (at
> + * your option) any later version.
> + */
> +
> +#include <linux/audit.h>
> +#include <linux/capability.h>
> +#include <linux/cgroup.h>
> +#include <linux/cred.h>
> +#include <linux/file.h>
> +#include <linux/init.h>
> +#include <linux/mutex.h>
> +#include <linux/pid_namespace.h>
> +#include <linux/sched.h>
> +#include <linux/security.h>
> +#include <linux/sizes.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/user_namespace.h>
> +#include <linux/version.h>
> +
> +#include "connection.h"
> +#include "item.h"
> +#include "message.h"
> +#include "metadata.h"
> +#include "names.h"
> +
> +/**
> + * kdbus_meta_new() - create new metadata object
> + * @meta:              New metadata object
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int kdbus_meta_new(struct kdbus_meta **meta)
> +{
> +       struct kdbus_meta *m;
> +
> +       BUG_ON(*meta);
> +
> +       m = kzalloc(sizeof(*m), GFP_KERNEL);
> +       if (!m)
> +               return -ENOMEM;
> +
> +       /*
> +        * Remember the PID and user namespaces our credentials belong to;
> +        * we need to prevent leaking authorization and security-relevant
> +        * data across different namespaces.
> +        */
> +       m->pid_namespace = get_pid_ns(task_active_pid_ns(current));
> +       m->user_namespace = get_user_ns(current_user_ns());
> +

This is unusual, and it could be very expensive (it will serialize
essentially everyone on an exclusive cacheline).  What attack is it
protecting against?

> +static int kdbus_meta_append_cred(struct kdbus_meta *meta)
> +{
> +       struct kdbus_creds creds = {
> +               .uid = from_kuid_munged(current_user_ns(), current_uid()),
> +               .gid = from_kgid_munged(current_user_ns(), current_gid()),
> +               .pid = task_pid_vnr(current),
> +               .tid = task_tgid_vnr(current),
> +               .starttime = current->start_time,
> +       };
> +
> +       return kdbus_meta_append_data(meta, KDBUS_ITEM_CREDS,
> +                                     &creds, sizeof(creds));
> +}

This seems wrong to me.  Shouldn't this store kuid_t, etc. directly?
Also, why pid, tid, and starttime?

> +
> +       for (i = 0; i < info->ngroups; i++)
> +               gid[i] = from_kgid_munged(current_user_ns(), GROUP_AT(info, i));

Ditto.

--Andy
