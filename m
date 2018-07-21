From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 02/10] audit: log container
	info of syscalls
Date: Sat, 21 Jul 2018 16:29:30 -0400
Message-ID: <20180721202930.a7rypxc5rxi3hyiv@madcap2.tricolour.ca>
References: <cover.1528304203.git.rgb@redhat.com>
	<b839dc7fb29aae226b2a4602e7ef3c2a406ee90a.1528304203.git.rgb@redhat.com>
	<CAHC9VhS0-4XSEFFPLrOvAiSYv-XDLG-yGyB4ULRGz=AnwE6diQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHC9VhS0-4XSEFFPLrOvAiSYv-XDLG-yGyB4ULRGz=AnwE6diQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Paul Moore <paul@paul-moore.com>, Steve Grubb <sgrubb@redhat.com>
Cc: simo@redhat.com, carlos@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, dhowells@redhat.com, linux-audit@redhat.com, ebiederm@xmission.com, luto@kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, serge@hallyn.com, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2018-07-20 18:13, Paul Moore wrote:
> On Wed, Jun 6, 2018 at 1:00 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Create a new audit record AUDIT_CONTAINER to document the audit
> > container identifier of a process if it is present.
> >
> > Called from audit_log_exit(), syscalls are covered.
> >
> > A sample raw event:
> > type=SYSCALL msg=audit(1519924845.499:257): arch=c000003e syscall=257 success=yes exit=3 a0=ffffff9c a1=56374e1cef30 a2=241 a3=1b6 items=2 ppid=606 pid=635 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=3 comm="bash" exe="/usr/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="tmpcontainerid"
> > type=CWD msg=audit(1519924845.499:257): cwd="/root"
> > type=PATH msg=audit(1519924845.499:257): item=0 name="/tmp/" inode=13863 dev=00:27 mode=041777 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype= PARENT cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
> > type=PATH msg=audit(1519924845.499:257): item=1 name="/tmp/tmpcontainerid" inode=17729 dev=00:27 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
> > type=PROCTITLE msg=audit(1519924845.499:257): proctitle=62617368002D6300736C65657020313B206563686F2074657374203E202F746D702F746D70636F6E7461696E65726964
> > type=CONTAINER msg=audit(1519924845.499:257): op=task contid=123458
> >
> > See: https://github.com/linux-audit/audit-kernel/issues/90
> > See: https://github.com/linux-audit/audit-userspace/issues/51
> > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h      |  7 +++++++
> >  include/uapi/linux/audit.h |  1 +
> >  kernel/audit.c             | 23 +++++++++++++++++++++++
> >  kernel/auditsc.c           |  3 +++
> >  4 files changed, 34 insertions(+)
> 
> ...
> 
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -115,6 +115,7 @@
> >  #define AUDIT_REPLACE          1329    /* Replace auditd if this packet unanswerd */
> >  #define AUDIT_KERN_MODULE      1330    /* Kernel Module events */
> >  #define AUDIT_FANOTIFY         1331    /* Fanotify access decision */
> > +#define AUDIT_CONTAINER                1332    /* Container ID */
> 
> I'm not sure I'm completely sold on the AUDIT_CONTAINER_ID and
> AUDIT_CONTAINER record type names.  From what I can tell
> AUDIT_CONTAINER_ID seems to be used for audit container ID management
> operations, e.g. setting the ID, whereas the AUDIT_CONTAINER is used
> to tag events with the corresponding audit container ID.  Assuming
> that is correct, it seems like AUDIT_CONTAINER might be better served
> if it was named AUDIT_CONTAINER_ID and if we could change
> AUDIT_CONTAINER_ID to AUDIT_CONTAINER_OP/MGMT/etc.  Thoughts?

Please see discussion at:
	https://www.redhat.com/archives/linux-audit/2018-May/msg00101.html

I'm fine with changing AUDIT_CONTAINER_ID to AUDIT_CONTAINER_OP/MGMT/etc.

> >  #define AUDIT_AVC              1400    /* SE Linux avc denial or grant */
> >  #define AUDIT_SELINUX_ERR      1401    /* Internal SE Linux Errors */
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index e7478cb..5e150c6 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2048,6 +2048,29 @@ void audit_log_session_info(struct audit_buffer *ab)
> >         audit_log_format(ab, " auid=%u ses=%u", auid, sessionid);
> >  }
> >
> > +/*
> > + * audit_log_contid - report container info
> > + * @tsk: task to be recorded
> > + * @context: task or local context for record
> > + * @op: contid string description
> > + */
> > +int audit_log_contid(struct task_struct *tsk,
> > +                            struct audit_context *context, char *op)
> > +{
> > +       struct audit_buffer *ab;
> > +
> > +       if (!audit_contid_set(tsk))
> > +               return 0;
> > +       /* Generate AUDIT_CONTAINER record with container ID */
> > +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER);
> > +       if (!ab)
> > +               return -ENOMEM;
> > +       audit_log_format(ab, "op=%s contid=%llu",
> > +                        op, audit_get_contid(tsk));
> 
> Can you explain your reason for including an "op" field in this record
> type?  I've been looking at the rest of the patches in this patchset
> and it seems to be used more as an indicator of the record's
> generating context rather than any sort of audit container ID
> operation.

"action" might work, but that's netfilter and numeric... "kind"?
Nothing else really seems to fit from a field name, type or lack of
searchability perspective.

Steve, do you have an opinion?

> > +       audit_log_end(ab);
> > +       return 0;
> > +}
> 
> --
> paul moore
> www.paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
