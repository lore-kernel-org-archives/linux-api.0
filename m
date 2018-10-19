From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 02/10] audit: add container id
Date: Fri, 19 Oct 2018 17:50:50 -0400
Message-ID: <20181019215050.kuonluie6h3aokkt@madcap2.tricolour.ca>
References: <cover.1533065887.git.rgb@redhat.com>
 <12396e378a78ee8dd38c75f7730d67d8fbb08e02.1533065887.git.rgb@redhat.com>
 <CAHC9VhTT7n4wDoaDGFXAK+wtcsMDDMRkQVCQ2jNYLKSFqFc+bA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhTT7n4wDoaDGFXAK+wtcsMDDMRkQVCQ2jNYLKSFqFc+bA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On 2018-10-19 15:38, Paul Moore wrote:
> On Tue, Jul 31, 2018 at 4:11 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Implement the proc fs write to set the audit container identifier of a
> > process, emitting an AUDIT_CONTAINER_OP record to document the event.
> >
> > This is a write from the container orchestrator task to a proc entry of
> > the form /proc/PID/audit_containerid where PID is the process ID of the
> > newly created task that is to become the first task in a container, or
> > an additional task added to a container.
> >
> > The write expects up to a u64 value (unset: 18446744073709551615).
> >
> > The writer must have capability CAP_AUDIT_CONTROL.
> >
> > This will produce a record such as this:
> >   type=CONTAINER_ID msg=audit(2018-06-06 12:39:29.636:26949) : op=set opid=2209 old-contid=18446744073709551615 contid=123456 pid=628 auid=root uid=root tty=ttyS0 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 comm=bash exe=/usr/bin/bash res=yes
> 
> You need to update the record type in the example above.

Yup, thanks.

> > The "op" field indicates an initial set.  The "pid" to "ses" fields are
> > the orchestrator while the "opid" field is the object's PID, the process
> > being "contained".  Old and new audit container identifier values are
> > given in the "contid" fields, while res indicates its success.
> 
> I understand Steve's concern around the "op" field, but I think it
> might be a bit premature to think we might not need to do some sort of
> audit container ID management in the future that would want to make
> use of the CONTAINER_OP message type.  I would like to see the "op"
> field preserved.

I strongly agree.

> > It is not permitted to unset the audit container identifier.
> > A child inherits its parent's audit container identifier.
> >
> > See: https://github.com/linux-audit/audit-kernel/issues/90
> > See: https://github.com/linux-audit/audit-userspace/issues/51
> > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Acked-by: Serge Hallyn <serge@hallyn.com>
> > Acked-by: Steve Grubb <sgrubb@redhat.com>
> > ---
> >  fs/proc/base.c             | 37 +++++++++++++++++++++++++
> >  include/linux/audit.h      | 24 ++++++++++++++++
> >  include/uapi/linux/audit.h |  2 ++
> >  kernel/auditsc.c           | 68 ++++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 131 insertions(+)
> 
> ...
> 
> > @@ -2112,6 +2114,72 @@ int audit_set_loginuid(kuid_t loginuid)
> >  }
> >
> >  /**
> > + * audit_set_contid - set current task's audit_context contid
> > + * @contid: contid value
> > + *
> > + * Returns 0 on success, -EPERM on permission failure.
> > + *
> > + * Called (set) from fs/proc/base.c::proc_contid_write().
> > + */
> > +int audit_set_contid(struct task_struct *task, u64 contid)
> > +{
> > +       u64 oldcontid;
> > +       int rc = 0;
> > +       struct audit_buffer *ab;
> > +       uid_t uid;
> > +       struct tty_struct *tty;
> > +       char comm[sizeof(current->comm)];
> > +
> > +       task_lock(task);
> > +       /* Can't set if audit disabled */
> > +       if (!task->audit) {
> > +               task_unlock(task);
> > +               return -ENOPROTOOPT;
> > +       }
> > +       oldcontid = audit_get_contid(task);
> > +       read_lock(&tasklist_lock);
> 
> I assume lockdep was happy with nesting the tasklist_lock inside the task lock?

Yup, I had gone through the logic and at first I had doubts, but the
function comments and other usage reassured me (as well as in-kernel
lock checks on boot) that this was the right order and approach.

> > +       /* Don't allow the audit containerid to be unset */
> > +       if (!audit_contid_valid(contid))
> > +               rc = -EINVAL;
> > +       /* if we don't have caps, reject */
> > +       else if (!capable(CAP_AUDIT_CONTROL))
> > +               rc = -EPERM;
> > +       /* if task has children or is not single-threaded, deny */
> > +       else if (!list_empty(&task->children))
> > +               rc = -EBUSY;
> > +       else if (!(thread_group_leader(task) && thread_group_empty(task)))
> > +               rc = -EALREADY;
> > +       read_unlock(&tasklist_lock);
> > +       if (!rc)
> > +               task->audit->contid = contid;
> > +       task_unlock(task);
> > +
> > +       if (!audit_enabled)
> > +               return rc;
> > +
> > +       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
> > +       if (!ab)
> > +               return rc;
> > +
> > +       uid = from_kuid(&init_user_ns, task_uid(current));
> > +       tty = audit_get_tty(current);
> > +       audit_log_format(ab, "op=set opid=%d old-contid=%llu contid=%llu pid=%d uid=%u auid=%u tty=%s ses=%u",
> > +                        task_tgid_nr(task), oldcontid, contid,
> > +                        task_tgid_nr(current), uid,
> > +                        from_kuid(&init_user_ns, audit_get_loginuid(current)),
> > +                        tty ? tty_name(tty) : "(none)",
> > +                        audit_get_sessionid(current));
> > +       audit_put_tty(tty);
> > +       audit_log_task_context(ab);
> > +       audit_log_format(ab, " comm=");
> > +       audit_log_untrustedstring(ab, get_task_comm(comm, current));
> > +       audit_log_d_path_exe(ab, current->mm);
> > +       audit_log_format(ab, " res=%d", !rc);
> > +       audit_log_end(ab);
> > +       return rc;
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
