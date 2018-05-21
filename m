From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [RFC PATCH ghak32 V2 03/13] audit: log container info of syscalls
Date: Mon, 21 May 2018 15:19:10 -0400
Message-ID: <41282003.Hb38ry776C@x2>
References: <cover.1521179281.git.rgb@redhat.com> <20180517170907.3d9f7c1a@ivy-bridge> <20180517214102.qhg4gofwrbsn2eru@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180517214102.qhg4gofwrbsn2eru@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Thursday, May 17, 2018 5:41:02 PM EDT Richard Guy Briggs wrote:
> On 2018-05-17 17:09, Steve Grubb wrote:
> > On Fri, 16 Mar 2018 05:00:30 -0400
> > 
> > Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Create a new audit record AUDIT_CONTAINER_INFO to document the
> > > container ID of a process if it is present.
> > 
> > As mentioned in a previous email, I think AUDIT_CONTAINER is more
> > suitable for the container record. One more comment below...
> > 
> > > Called from audit_log_exit(), syscalls are covered.
> > > 
> > > A sample raw event:
> > > type=SYSCALL msg=audit(1519924845.499:257): arch=c000003e syscall=257
> > > success=yes exit=3 a0=ffffff9c a1=56374e1cef30 a2=241 a3=1b6 items=2
> > > ppid=606 pid=635 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0
> > > sgid=0 fsgid=0 tty=pts0 ses=3 comm="bash" exe="/usr/bin/bash"
> > > subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> > > key="tmpcontainerid" type=CWD msg=audit(1519924845.499:257):
> > > cwd="/root" type=PATH msg=audit(1519924845.499:257): item=0
> > > name="/tmp/" inode=13863 dev=00:27 mode=041777 ouid=0 ogid=0
> > > rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype= PARENT
> > > cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
> > > type=PATH msg=audit(1519924845.499:257): item=1
> > > name="/tmp/tmpcontainerid" inode=17729 dev=00:27 mode=0100644 ouid=0
> > > ogid=0 rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0
> > > nametype=CREATE cap_fp=0000000000000000 cap_fi=0000000000000000
> > > cap_fe=0 cap_fver=0 type=PROCTITLE msg=audit(1519924845.499:257):
> > > proctitle=62617368002D6300736C65657020313B206563686F2074657374203E202F7
> > > 46D702F746D70636F6E7461696E65726964 type=CONTAINER_INFO
> > > msg=audit(1519924845.499:257): op=task
> > > contid=123458
> > > 
> > > See: https://github.com/linux-audit/audit-kernel/issues/32
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > > 
> > >  include/linux/audit.h      |  5 +++++
> > >  include/uapi/linux/audit.h |  1 +
> > >  kernel/audit.c             | 20 ++++++++++++++++++++
> > >  kernel/auditsc.c           |  2 ++
> > >  4 files changed, 28 insertions(+)
> > > 
> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index fe4ba3f..3acbe9d 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -154,6 +154,8 @@ extern void
> > > audit_log_link_denied(const char *operation, extern int
> > > audit_log_task_context(struct audit_buffer *ab); extern void
> > > audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk);
> > > +extern int audit_log_container_info(struct task_struct *tsk,
> > > +				     struct audit_context *context);
> > > 
> > >  extern int		    audit_update_lsm_rules(void);
> > > 
> > > @@ -205,6 +207,9 @@ static inline int audit_log_task_context(struct
> > > audit_buffer *ab) static inline void audit_log_task_info(struct
> > > audit_buffer *ab, struct task_struct *tsk)
> > > 
> > >  { }
> > > 
> > > +static inline int audit_log_container_info(struct task_struct *tsk,
> > > +					    struct audit_context
> > > *context); +{ }
> > > 
> > >  #define audit_enabled 0
> > >  #endif /* CONFIG_AUDIT */
> > > 
> > > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > > index 921a71f..e83ccbd 100644
> > > --- a/include/uapi/linux/audit.h
> > > +++ b/include/uapi/linux/audit.h
> > > @@ -115,6 +115,7 @@
> > > 
> > >  #define AUDIT_REPLACE		1329	/* Replace auditd
> > > 
> > > if this packet unanswerd */ #define AUDIT_KERN_MODULE
> > > 1330	/* Kernel Module events */ #define
> > > AUDIT_FANOTIFY		1331	/* Fanotify access decision
> > > */ +#define AUDIT_CONTAINER_INFO	1332	/* Container ID
> > > information */ #define AUDIT_AVC		1400	/* SE
> > > Linux avc denial or grant */ #define AUDIT_SELINUX_ERR
> > > 1401	/* Internal SE Linux Errors */ diff --git
> > > a/kernel/audit.c b/kernel/audit.c index 3f2f143..a12f21f 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -2049,6 +2049,26 @@ void audit_log_session_info(struct
> > > audit_buffer *ab) audit_log_format(ab, " auid=%u ses=%u", auid,
> > > sessionid); }
> > > 
> > > +/*
> > > + * audit_log_container_info - report container info
> > > + * @tsk: task to be recorded
> > > + * @context: task or local context for record
> > > + */
> > > +int audit_log_container_info(struct task_struct *tsk, struct
> > > audit_context *context) +{
> > > +	struct audit_buffer *ab;
> > > +
> > > +	if (!audit_containerid_set(tsk))
> > > +		return 0;
> > > +	/* Generate AUDIT_CONTAINER_INFO with container ID */
> > > +	ab = audit_log_start(context, GFP_KERNEL,
> > > AUDIT_CONTAINER_INFO);
> > > +	if (!ab)
> > > +		return -ENOMEM;
> > > +	audit_log_format(ab, "contid=%llu",
> > > audit_get_containerid(tsk));
> > > +	audit_log_end(ab);
> > > +	return 0;
> > > +}
> > > +
> > > 
> > >  void audit_log_key(struct audit_buffer *ab, char *key)
> > >  {
> > >  
> > >  	audit_log_format(ab, " key=");
> > > 
> > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > index a6b0a52..65be110 100644
> > > --- a/kernel/auditsc.c
> > > +++ b/kernel/auditsc.c
> > > @@ -1453,6 +1453,8 @@ static void audit_log_exit(struct audit_context
> > > *context, struct task_struct *ts
> > > 
> > >  	audit_log_proctitle(tsk, context);
> > > 
> > > +	audit_log_container_info(tsk, context);
> > 
> > Would there be any problem moving audit_log_container_info before
> > audit_log_proctitle? There are some assumptions that proctitle is the
> > last record in some situations.
> 
> I see no problem doing that.

Actually...just leave it as is. I have to fix things for simple events and 
they do not have a proctitle record. So, leave it as you intended and I'll 
work around this on my end.

Thanks,
-Steve

> > >  	/* Send end of event record to help user space know we are
> > > 
> > > finished */ ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
> > > 
> > >  	if (ab)
> 
> - RGB
> 
> --
> Richard Guy Briggs <rgb@redhat.com>
> Sr. S/W Engineer, Kernel Security, Base Operating Systems
> Remote, Ottawa, Red Hat Canada
> IRC: rgb, SunRaycer
> Voice: +1.647.777.2635, Internal: (81) 32635
