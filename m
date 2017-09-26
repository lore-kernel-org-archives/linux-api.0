From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 1/1] audit: Record fanotify access control decisions
Date: Tue, 26 Sep 2017 16:19:44 +0300
Message-ID: <CAOQ4uxijBHN7CXBJwEZjQqGP-Y40FLkHX8YUgcLEovba7m09kQ@mail.gmail.com>
References: <2364937.SQ5dJnrJFp@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2364937.SQ5dJnrJFp@x2>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Audit <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 26, 2017 at 3:44 PM, Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
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
Reviewed-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
