From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 03/10] audit: log container info
 of syscalls
Date: Thu, 25 Oct 2018 08:06:38 +0200
Message-ID: <20181025080638.771621a3@ivy-bridge>
References: <cover.1533065887.git.rgb@redhat.com>
        <34017c395d03a213d6b0d49b9964429bd32b283d.1533065887.git.rgb@redhat.com>
        <CAHC9VhSv4hWGHiaaOfuBrRQKdp2YG5RtqXQbFXg7j7LNEhO2XQ@mail.gmail.com>
        <20181024151439.lavhanabsyxdrdvo@madcap2.tricolour.ca>
        <CAHC9VhRF1vsxM-k0Lw-9NqS9b9rgXRRBu0tq4ajdFpMqUxiH4A@mail.gmail.com>
        <20181025004255.zl7p7j6gztouh2hh@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181025004255.zl7p7j6gztouh2hh@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, simo@redhat.com, carlos@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-audit@redhat.com, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On Wed, 24 Oct 2018 20:42:55 -0400
Richard Guy Briggs <rgb@redhat.com> wrote:

> On 2018-10-24 16:55, Paul Moore wrote:
> > On Wed, Oct 24, 2018 at 11:15 AM Richard Guy Briggs
> > <rgb@redhat.com> wrote:  
> > > On 2018-10-19 19:16, Paul Moore wrote:  
> > > > On Sun, Aug 5, 2018 at 4:32 AM Richard Guy Briggs
> > > > <rgb@redhat.com> wrote:  
> > > > > Create a new audit record AUDIT_CONTAINER to document the
> > > > > audit container identifier of a process if it is present.
> > > > >
> > > > > Called from audit_log_exit(), syscalls are covered.
> > > > >
> > > > > A sample raw event:
> > > > > type=SYSCALL msg=audit(1519924845.499:257): arch=c000003e
> > > > > syscall=257 success=yes exit=3 a0=ffffff9c a1=56374e1cef30
> > > > > a2=241 a3=1b6 items=2 ppid=606 pid=635 auid=0 uid=0 gid=0
> > > > > euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=3
> > > > > comm="bash" exe="/usr/bin/bash"
> > > > > subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> > > > > key="tmpcontainerid" type=CWD msg=audit(1519924845.499:257):
> > > > > cwd="/root" type=PATH msg=audit(1519924845.499:257): item=0
> > > > > name="/tmp/" inode=13863 dev=00:27 mode=041777 ouid=0 ogid=0
> > > > > rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype= PARENT
> > > > > cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0
> > > > > cap_fver=0 type=PATH msg=audit(1519924845.499:257): item=1
> > > > > name="/tmp/tmpcontainerid" inode=17729 dev=00:27 mode=0100644
> > > > > ouid=0 ogid=0 rdev=00:00
> > > > > obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE
> > > > > cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0
> > > > > cap_fver=0 type=PROCTITLE msg=audit(1519924845.499:257):
> > > > > proctitle=62617368002D6300736C65657020313B206563686F2074657374203E202F746D702F746D70636F6E7461696E65726964
> > > > > type=CONTAINER msg=audit(1519924845.499:257): op=task
> > > > > contid=123458
> > > > >
> > > > > See: https://github.com/linux-audit/audit-kernel/issues/90
> > > > > See: https://github.com/linux-audit/audit-userspace/issues/51
> > > > > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > > > > See:
> > > > > https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com> Acked-by:
> > > > > Serge Hallyn <serge@hallyn.com> Acked-by: Steve Grubb
> > > > > <sgrubb@redhat.com> ---
> > > > >  include/linux/audit.h      |  7 +++++++
> > > > >  include/uapi/linux/audit.h |  1 +
> > > > >  kernel/audit.c             | 24 ++++++++++++++++++++++++
> > > > >  kernel/auditsc.c           |  3 +++
> > > > >  4 files changed, 35 insertions(+)  
> > > >
> > > > ...
> > > >  
> > > > > @@ -2045,6 +2045,30 @@ void audit_log_session_info(struct
> > > > > audit_buffer *ab) audit_log_format(ab, " auid=%u ses=%u",
> > > > > auid, sessionid); }
> > > > >
> > > > > +/*
> > > > > + * audit_log_contid - report container info
> > > > > + * @tsk: task to be recorded
> > > > > + * @context: task or local context for record
> > > > > + * @op: contid string description
> > > > > + */
> > > > > +int audit_log_contid(struct task_struct *tsk,
> > > > > +                            struct audit_context *context,
> > > > > char *op) +{
> > > > > +       struct audit_buffer *ab;
> > > > > +
> > > > > +       if (!audit_contid_set(tsk))
> > > > > +               return 0;
> > > > > +       /* Generate AUDIT_CONTAINER record with container ID
> > > > > */
> > > > > +       ab = audit_log_start(context, GFP_KERNEL,
> > > > > AUDIT_CONTAINER);
> > > > > +       if (!ab)
> > > > > +               return -ENOMEM;
> > > > > +       audit_log_format(ab, "op=%s contid=%llu",
> > > > > +                        op, audit_get_contid(tsk));
> > > > > +       audit_log_end(ab);
> > > > > +       return 0;
> > > > > +}
> > > > > +EXPORT_SYMBOL(audit_log_contid);  
> > > >
> > > > As discussed in the previous iteration of the patch, I prefer
> > > > AUDIT_CONTAINER_ID here over AUDIT_CONTAINER.  If you feel
> > > > strongly about keeping it as-is with AUDIT_CONTAINER I suppose
> > > > I could live with that, but it is isn't my first choice.  
> > >
> > > I don't have a strong opinion on this one, mildly preferring the
> > > shorter one only because it is shorter.  
> > 
> > We already have multiple AUDIT_CONTAINER* record types, so it seems
> > as though we should use "AUDIT_CONTAINER" as a prefix of sorts,
> > rather than a type itself.  
> 
> I'm fine with that.  I'd still like to hear Steve's input.  He had
> stronger opinions than me.

The creation event should be separate and distinct from the continuing
use when its used as a supplemental record. IOW, binding the ID to a
container is part of the lifecycle and needs to be kept distinct.

-Steve

> > > > However, I do care about the "op" field in this record.  It just
> > > > doesn't make any sense; the way you are using it it is more of a
> > > > context field than an operations field, and even then why is the
> > > > context important from a logging and/or security perspective?
> > > > Drop it please.  
> > >
> > > I'll rename it to whatever you like.  I'd suggest "ref=".  The
> > > reason I think it is important is there are multiple sources that
> > > aren't always obvious from the other records to which it is
> > > associated.  In the case of ptrace and signals, there can be many
> > > target tasks listed (OBJ_PID) with no other way to distinguish
> > > the matching audit container identifier records all for one
> > > event.  This is in addition to the default syscall container
> > > identifier record.  I'm not currently happy with the text content
> > > to link the two, but that should be solvable (most obvious is
> > > taret PID).  Throwing away this information seems shortsighted.  
> > 
> > It would be helpful if you could generate real audit events
> > demonstrating the problems you are describing, as well as a more
> > standard syscall event, so we can discuss some possible solutions.  
> 
> If the auditted process is in a container and it ptraces or signals
> another process in a container, there will be two AUDIT_CONTAINER
> records for the same event that won't be identified as to which record
> belongs to which process or other record (SYSCALL vs 1+ OBJ_PID
> records).  There could be many signals recorded, each with their own
> OBJ_PID record.  The first is stored in the audit context and
> additional ones are stored in a chained struct that can accommodate
> 16 entries each.
> 
> (See audit_signal_info(), __audit_ptrace().)
> 
> (As a side note, on code inspection it appears that a signal target
> would get overwritten by a ptrace action if they were to happen in
> that order.)
> 
> > paul moore  
> 
> - RGB
> 
> --
> Richard Guy Briggs <rgb@redhat.com>
> Sr. S/W Engineer, Kernel Security, Base Operating Systems
> Remote, Ottawa, Red Hat Canada
> IRC: rgb, SunRaycer
> Voice: +1.647.777.2635, Internal: (81) 32635
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit
