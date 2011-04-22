From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3,23/23] netoops: Add OOM event to dump.
Date: Fri, 22 Apr 2011 12:13:47 -0700
Message-ID: <BANLkTimyBqe=SdQ_hyj1uv3VP6QeqtJS5w@mail.gmail.com>
References: <1303471321-11863-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303471321-11863-1-git-send-email-hao.bigrat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robin Dong <hao.bigrat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robin Dong <sanbai-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 22, 2011 at 4:22 AM, Robin Dong <hao.bigrat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> From: Robin Dong <sanbai-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>
> Our team is evaluating the netoops patchs since it is very useful in
> complicated data center environment.
> But we also need to catch the OOM message from remote machine.
> So I add this patch.

Hmm.  I'm wondering if it may make more sense to push this sort of
configuration down into the configfs directories themselves so
different types of events can be configured for each endpoint
independently.  It'd need a bit of support from the netpoll_targets
code to allow that to happen, but I can take a stab at adding it (I'm
going to rebase this work this afternoon).

>
>
> Signed-off-by: Robin Dong <sanbai-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> ---
> =A0drivers/net/netoops.c =A0 =A0 | =A0 23 ++++++++++++++++++++++-
> =A0include/linux/kmsg_dump.h | =A0 =A01 +
> =A0mm/oom_kill.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A03 +++
> =A03 files changed, 26 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
> index 036e4d8..921775d 100644
> --- a/drivers/net/netoops.c
> +++ b/drivers/net/netoops.c
> @@ -113,6 +113,7 @@ static struct netoops_msg msg;
> =A0static size_t netoops_user_blob_length;
> =A0static char netoops_user_blob[NETOOPS_BLOB_BYTES];
> =A0static u32 netoops_boot_id;
> +static u32 netoops_record_oom;
>
> =A0static void setup_packet_header(int packet_count, struct pt_regs *=
regs,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int so=
ft_dump)
> @@ -201,10 +202,15 @@ static void netoops(struct kmsg_dumper *dumper,=
 enum kmsg_dump_reason reason,
> =A0 =A0 =A0 =A0int soft_dump =3D 0;
> =A0 =A0 =A0 =A0int i;
>
> + =A0 =A0 =A0 /* Record oom event only when netoops_record_oom is 1 *=
/
> + =A0 =A0 =A0 if (reason =3D=3D KMSG_DUMP_OOM && netoops_record_oom =3D=
=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> =A0 =A0 =A0 =A0/* Only handle fatal problems */
> =A0 =A0 =A0 =A0if (reason !=3D KMSG_DUMP_OOPS
> =A0 =A0 =A0 =A0 && reason !=3D KMSG_DUMP_PANIC
> - =A0 =A0 =A0 =A0&& reason !=3D KMSG_DUMP_SOFT)
> + =A0 =A0 =A0 =A0&& reason !=3D KMSG_DUMP_SOFT
> + =A0 =A0 =A0 =A0&& reason !=3D KMSG_DUMP_OOM)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
> =A0 =A0 =A0 =A0if (reason =3D=3D KMSG_DUMP_SOFT)
> @@ -241,6 +247,10 @@ static ssize_t netoops_show(struct kobject *kobj=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0snprintf(buf, PAGE_SIZE, "%d\n", netoo=
ps_boot_id);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return strnlen(buf, PAGE_SIZE);
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 if (!strcmp(attr->attr.name, "netoops_record_oom")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 snprintf(buf, PAGE_SIZE, "%d\n", netoop=
s_record_oom);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return strnlen(buf, PAGE_SIZE);
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0return -EINVAL;
> =A0}
>
> @@ -261,6 +271,14 @@ static ssize_t netoops_store(struct kobject *kob=
j,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (tmp > UINT_MAX)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk("Warning: trunc=
ating boot_id to 32bits.");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0netoops_boot_id =3D tmp;
> + =A0 =A0 =A0 } else if (!strcmp(attr->attr.name, "netoops_record_oom=
")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long tmp;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strict_strtoul(buf, 0, &tmp))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tmp)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 netoops_record_oom =3D =
1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 netoops_record_oom =3D =
0;
> =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> @@ -271,10 +289,13 @@ static struct kobj_attribute netoops_user_blob_=
attribute =3D
> =A0 =A0 =A0 =A0__ATTR(netoops_user_blob, 0644, netoops_show, netoops_=
store);
> =A0static struct kobj_attribute netoops_boot_number_attribute =3D
> =A0 =A0 =A0 =A0__ATTR(netoops_boot_id, 0666, netoops_show, netoops_st=
ore);
> +static struct kobj_attribute netoops_record_oom_attribute =3D
> + =A0 =A0 =A0 __ATTR(netoops_record_oom, 0666, netoops_show, netoops_=
store);
>
> =A0static struct attribute *attrs[] =3D {
> =A0 =A0 =A0 =A0&netoops_user_blob_attribute.attr,
> =A0 =A0 =A0 =A0&netoops_boot_number_attribute.attr,
> + =A0 =A0 =A0 &netoops_record_oom_attribute.attr,
> =A0 =A0 =A0 =A0NULL,
> =A0};
>
> diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
> index 0abc2d7..cefbf5f 100644
> --- a/include/linux/kmsg_dump.h
> +++ b/include/linux/kmsg_dump.h
> @@ -21,6 +21,7 @@ enum kmsg_dump_reason {
> =A0 =A0 =A0 =A0KMSG_DUMP_PANIC,
> =A0 =A0 =A0 =A0KMSG_DUMP_KEXEC,
> =A0 =A0 =A0 =A0KMSG_DUMP_SOFT,
> + =A0 =A0 =A0 KMSG_DUMP_OOM,
> =A0};
>
> =A0/**
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 7dcca55..40f3862 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -31,6 +31,7 @@
> =A0#include <linux/memcontrol.h>
> =A0#include <linux/mempolicy.h>
> =A0#include <linux/security.h>
> +#include <linux/kmsg_dump.h>
>
> =A0int sysctl_panic_on_oom;
> =A0int sysctl_oom_kill_allocating_task;
> @@ -742,6 +743,8 @@ out:
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (killed && !test_thread_flag(TIF_MEMDIE))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0schedule_timeout_uninterruptible(1);
> +
> + =A0 =A0 =A0 kmsg_dump(KMSG_DUMP_OOM, NULL);
> =A0}
>
> =A0/*
> --
> 1.7.1
>
>
