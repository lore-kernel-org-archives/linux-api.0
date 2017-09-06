From: Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] audit: Record fanotify access control decisions
Date: Wed, 06 Sep 2017 10:35:32 -0400
Message-ID: <5434938.YfYYiuuLFk@x2>
References: <1970763.eSnnJ2BxMO@x2> <20170906091822.GB27916@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170906091822.GB27916-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Audit <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wednesday, September 6, 2017 5:18:22 AM EDT Jan Kara wrote:
> On Tue 05-09-17 14:32:07, Steve Grubb wrote:
> > The fanotify interface allows user space daemons to make access
> > 
> >  control decisions. Under common criteria requirements, we need to
> >  optionally record decisions based on policy. This patch adds a bit mask,
> >  FAN_AUDIT, that a user space daemon can 'or' into the response decision
> >  which will tell the kernel that it made a decision and record it.
> 
> [Since this is API change, added linux-api to CC, also added Amir since he
> works with fanotify]
> 
> Hum, probably I'm missing something here but why an application responding
> to fanotify event should need to know about audit?

Common Criteria rules are that if anything can prevent a flow of information, 
then you must be able to selectively audit. Selectively audit means under 
admin direction only when they want it. Meaning they may want some denials or 
approvals but not other ones.


> Or is it that for CCrequirements you have to implement some deamon which
> will arbitrate access using fanotify and you need to have decisions logged
> using kernel audit interface?

Yes. And even virus scanners would probably want to allow admins to pick when 
they record something being blocked.


> And another design question: If you need all responses by some daemon
> logged, wouldn't it be more logical to make FAN_AUDIT a property of
> fanotify instance (i.e., a flag to fanotify_init(2))? Or maybe a property
> of fanotify mark (i.e., a flag to fanotify_mark(2))?

It needs to be selectively audited. Meaning that most of the time it stays out 
of the way, but when an admin wants the information they have the ability make 
it happen. The example code below is overly simplistic. You would normally 
calculate the access decision and then check if auditing is requested and then 
'or' in the audit bit if needed.


> > It would be used something like this in user space code:
> >   response.response = FAN_DENY | FAN_AUDIT;
> >   write(fd, &response, sizeof(struct fanotify_response));
> > 
> > When the syscall ends, the audit system will record the decision as a
> > AUDIT_FANOTIFY auxiliary record to denote that the reason this event
> > occurred is the result of an access control decision from fanotify
> > rather than DAC or MAC policy.
> > 
> > A sample event looks like this:
> > 
> > type=PATH msg=audit(1504310584.332:290): item=0 name="./evil-ls"
> > inode=1319561 dev=fc:03 mode=0100755 ouid=1000 ogid=1000 rdev=00:00
> > obj=unconfined_u:object_r:user_home_t:s0 nametype=NORMAL
> > type=CWD msg=audit(1504310584.332:290): cwd="/home/sgrubb"
> > type=SYSCALL msg=audit(1504310584.332:290): arch=c000003e syscall=2
> > success=no exit=-1 a0=32cb3fca90 a1=0 a2=43 a3=8 items=1 ppid=901
> > pid=959 auid=1000 uid=1000 gid=1000 euid=1000 suid=1000
> > fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=pts1 ses=3 comm="bash"
> > exe="/usr/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:
> > s0-s0:c0.c1023 key=(null)
> > type=FANOTIFY msg=audit(1504310584.332:290): resp=2
> > 
> > Signed-off-by: sgrubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> <snip>
> 
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 3260ba2..1725f73 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2390,6 +2390,12 @@ void __audit_log_kern_module(char *name)
> > 
> >  	context->type = AUDIT_KERN_MODULE;
> >  
> >  }
> > 
> > +void __audit_fanotify(unsigned int response)
> > +{
> > +	audit_log(current->audit_context, GFP_ATOMIC,
> > +		AUDIT_FANOTIFY,	"resp=%u", response);
> > +}
> 
> Heh, GFP_ATOMIC looks pretty crude and it can fail more often than you'd
> think. In fact fanotify uses GFP_KERNEL for allocation of new event and I
> don't see a reason why __audit_fanotify() couldn't use the same.

Sure, that's easy enough to change. Is that the only change needed? Is the 
choice of 0x80 for the FAN_AUDIT bit OK? I wanted to leave some room for other 
numbers if there ever was a new use. The number is arbitrary and could be 
anything.

-Steve
