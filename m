From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] audit: Record fanotify access control decisions
Date: Wed, 6 Sep 2017 11:18:22 +0200
Message-ID: <20170906091822.GB27916@quack2.suse.cz>
References: <1970763.eSnnJ2BxMO@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1970763.eSnnJ2BxMO@x2>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, Jan Kara <jack@suse.cz>, Paul Moore <pmoore@redhat.com>, Amir Goldstein <amir73il@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue 05-09-17 14:32:07, Steve Grubb wrote:
> The fanotify interface allows user space daemons to make access
>  control decisions. Under common criteria requirements, we need to
>  optionally record decisions based on policy. This patch adds a bit mask,
>  FAN_AUDIT, that a user space daemon can 'or' into the response decision
>  which will tell the kernel that it made a decision and record it.

[Since this is API change, added linux-api to CC, also added Amir since he
works with fanotify]

Hum, probably I'm missing something here but why an application responding
to fanotify event should need to know about audit? Or is it that for CC
requirements you have to implement some deamon which will arbitrate access
using fanotify and you need to have decisions logged using kernel audit
interface?

And another design question: If you need all responses by some daemon
logged, wouldn't it be more logical to make FAN_AUDIT a property of
fanotify instance (i.e., a flag to fanotify_init(2))? Or maybe a property
of fanotify mark (i.e., a flag to fanotify_mark(2))?

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
> Signed-off-by: sgrubb <sgrubb@redhat.com>

<snip>

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 3260ba2..1725f73 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2390,6 +2390,12 @@ void __audit_log_kern_module(char *name)
>  	context->type = AUDIT_KERN_MODULE;
>  }
>  
> +void __audit_fanotify(unsigned int response)
> +{
> +	audit_log(current->audit_context, GFP_ATOMIC,
> +		AUDIT_FANOTIFY,	"resp=%u", response);
> +}

Heh, GFP_ATOMIC looks pretty crude and it can fail more often than you'd
think. In fact fanotify uses GFP_KERNEL for allocation of new event and I
don't see a reason why __audit_fanotify() couldn't use the same.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
