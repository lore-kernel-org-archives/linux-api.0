From: Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/1] audit: Record fanotify access control decisions
Date: Mon, 25 Sep 2017 16:37:47 -0400
Message-ID: <2007095.3atlGr9L8Y@x2>
References: <3856419.lGSJdPn8Ye@x2> <CAOQ4uxizzR=1wMCVMtwSWJzMpopHBK=9GtKnsz-5LP_bsELMgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOQ4uxizzR=1wMCVMtwSWJzMpopHBK=9GtKnsz-5LP_bsELMgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Audit <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Monday, September 25, 2017 2:49:19 PM EDT Amir Goldstein wrote:
> On Mon, Sep 25, 2017 at 6:19 PM, Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Hello,
> > 
> > The fanotify interface allows user space daemons to make access
> > control decisions. Under common criteria requirements, we need to
> > optionally record decisions based on policy. This patch adds a bit mask,
> > FAN_AUDIT, that a user space daemon can 'or' into the response decision
> > which will tell the kernel that it made a decision and record it.
> > 
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
> > Prior to using the audit flag, the developer needs to call
> > fanotify_init or'ing in FAN_AUDIT_ENABLE to ensure that the kernel
> > supports auditing. The calling process must also have the CAP_AUDIT_WRITE
> > capability.
> > 
> > Signed-off-by: sgrubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Sorry, found more nits...
> 
> > @@ -805,6 +808,13 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags,
> > unsigned int, event_f_flags)> 
> >                 group->fanotify_data.max_marks =
> >                 FANOTIFY_DEFAULT_MAX_MARKS;
> >         
> >         }
> > 
> > +       if (flags & FAN_ENABLE_AUDIT) {
> > +               fd = -EPERM;
> > +               if (!capable(CAP_AUDIT_WRITE))
> > +                       goto out_destroy_group;
> > +               group->audit_enabled = 1;
> > +       }
> > +
> 
> App should not be able to enable audit if audit is not configured in kernel.
> So there should be code that returns EINVAL for flag FAN_ENABLE_AUDIT if
> CONFIG_AUDITSYSCALL is not defined.
> Same deal as flag FAN_ALL_PERM_EVENTS and kernel config
> CONFIG_FANOTIFY_ACCESS_PERMISSIONS in fanotify_mark().
> Perhaps it is better not to extend FAN_ALL_INIT_FLAGS and explicitly
> test (flags & ~(FAN_ALL_INIT_FLAGS | FAN_ENABLE_AUDIT)) in fanotify_init()
> under ifdef, as done in fanotify_mark()?

OK. How about this, I do the (flags & ~(FAN_ALL_INIT_FLAGS | 
FAN_ENABLE_AUDIT)) with an ifdef. This will cause -EINVAL if FAN_ENABLE_AUDIT 
is attempted and CONFIG_AUDITSYSCALL is not defined. So, the code initially 
discussed above for audit_enabled would not need to have an #else. I can 
surround the "if" block with a CONFIG_AUDITSYSCALL so that it compiles out if 
audit is not being used. This will cause audit_enabled to always be false when 
audit is not compiled in.

> > diff --git a/include/linux/fsnotify_backend.h
> > b/include/linux/fsnotify_backend.h index c6c6931..8f7ea68 100644
> > --- a/include/linux/fsnotify_backend.h
> > +++ b/include/linux/fsnotify_backend.h
> > @@ -193,6 +193,7 @@ struct fsnotify_group {
> > 
> >                 } fanotify_data;
> >  
> >  #endif /* CONFIG_FANOTIFY */
> >  
> >         };
> > 
> > +       unsigned int audit_enabled;
> 
> This one should be bool and it belongs inside fanotify_data union member.
> Also, you need to translate it back to FAN_ENABLE_AUDIT in
> fanotify_show_fdinfo().

OK. Will fix this.

-Steve
