From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 1/1] audit: Record fanotify access control decisions
Date: Tue, 26 Sep 2017 07:16:35 +0300
Message-ID: <CAOQ4uxhLmpS7hd6Wf=9XXVaShS4+3M0X9oZ8=sr=EP9zm_85GA@mail.gmail.com>
References: <4884335.ELZ6VLfT65@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4884335.ELZ6VLfT65@x2>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Audit <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 26, 2017 at 3:26 AM, Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hello,
>
> The fanotify interface allows user space daemons to make access
> control decisions. Under common criteria requirements, we need to
> optionally record decisions based on policy. This patch adds a bit mask,
> FAN_AUDIT, that a user space daemon can 'or' into the response decision
> which will tell the kernel that it made a decision and record it.
>
> It would be used something like this in user space code:
>
>   response.response = FAN_DENY | FAN_AUDIT;
>   write(fd, &response, sizeof(struct fanotify_response));
>
> When the syscall ends, the audit system will record the decision as a
> AUDIT_FANOTIFY auxiliary record to denote that the reason this event
> occurred is the result of an access control decision from fanotify
> rather than DAC or MAC policy.
>
> A sample event looks like this:
>
> type=PATH msg=audit(1504310584.332:290): item=0 name="./evil-ls"
> inode=1319561 dev=fc:03 mode=0100755 ouid=1000 ogid=1000 rdev=00:00
> obj=unconfined_u:object_r:user_home_t:s0 nametype=NORMAL
> type=CWD msg=audit(1504310584.332:290): cwd="/home/sgrubb"
> type=SYSCALL msg=audit(1504310584.332:290): arch=c000003e syscall=2
> success=no exit=-1 a0=32cb3fca90 a1=0 a2=43 a3=8 items=1 ppid=901
> pid=959 auid=1000 uid=1000 gid=1000 euid=1000 suid=1000
> fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=pts1 ses=3 comm="bash"
> exe="/usr/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:
> s0-s0:c0.c1023 key=(null)
> type=FANOTIFY msg=audit(1504310584.332:290): resp=2
>
> Prior to using the audit flag, the developer needs to call
> fanotify_init or'ing in FAN_ENABLE_AUDIT to ensure that the kernel
> supports auditing. The calling process must also have the CAP_AUDIT_WRITE
> capability.
>
> Signed-off-by: sgrubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

conditional on fixing the 2 nits below:
Reviewed-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

...
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 907a481..3f6b509 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -179,7 +179,7 @@ static int process_access_response(struct fsnotify_group *group,
>          * userspace can send a valid response or we will clean it up after the
>          * timeout
>          */
> -       switch (response) {
> +       switch (response & ~FAN_AUDIT) {
>         case FAN_ALLOW:
>         case FAN_DENY:
>                 break;
> @@ -190,6 +190,9 @@ static int process_access_response(struct fsnotify_group *group,
>         if (fd < 0)
>                 return -EINVAL;
>
> +       if ((response & FAN_AUDIT) && (group->fanotify_data.audit_enabled == 0))
> +               return -EINVAL;
> +

&& !group->fanotify_data.audit_enabled)

== 0 was not need when audit_enabled was int. now its pure evil.

>         event = dequeue_event(group, fd);
>         if (!event)
>                 return -ENOENT;
> @@ -721,7 +724,11 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
>
> +#ifdef CONFIG_AUDITSYSCALL
> +       if (flags & ~(FAN_ALL_INIT_FLAGS | FAN_ENABLE_AUDIT))
> +#else
>         if (flags & ~FAN_ALL_INIT_FLAGS)
> +#endif
>                 return -EINVAL;
>
>         if (event_f_flags & ~FANOTIFY_INIT_ALL_EVENT_F_BITS)
> @@ -805,6 +812,15 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
>                 group->fanotify_data.max_marks = FANOTIFY_DEFAULT_MAX_MARKS;
>         }
>
> +#ifdef CONFIG_AUDITSYSCALL
> +       if (flags & FAN_ENABLE_AUDIT) {
> +               fd = -EPERM;
> +               if (!capable(CAP_AUDIT_WRITE))
> +                       goto out_destroy_group;
> +               group->fanotify_data.audit_enabled = true;
> +       }
> +#endif
> +

ifdef is not needed here as FAN_ENABLE_AUDIT flag won't survive the EINVAL
test above.

Thanks,
Amir.
