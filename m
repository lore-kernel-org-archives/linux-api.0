From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 01/10] audit: add container id
Date: Tue, 24 Jul 2018 15:06:13 -0400
Message-ID: <20180724190613.ww6yhsqpa7n4s62k@madcap2.tricolour.ca>
References: <cover.1528304203.git.rgb@redhat.com>
	<0377c3ced6bdbc44fe17f9a5679cb6eda4304024.1528304203.git.rgb@redhat.com>
	<CAHC9VhRk+qLAyizM9i8D+cjKxyhruuj_Z9N0QRmjM-fjm4hgRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHC9VhRk+qLAyizM9i8D+cjKxyhruuj_Z9N0QRmjM-fjm4hgRw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Paul Moore <paul@paul-moore.com>
Cc: simo@redhat.com, jlayton@redhat.com, carlos@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, dhowells@redhat.com, linux-audit@redhat.com, ebiederm@xmission.com, luto@kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, serge@hallyn.com, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2018-07-20 18:13, Paul Moore wrote:
> On Wed, Jun 6, 2018 at 1:00 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Implement the proc fs write to set the audit container identifier of a
> > process, emitting an AUDIT_CONTAINER_ID record to document the event.
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
> >
> > The "op" field indicates an initial set.  The "pid" to "ses" fields are
> > the orchestrator while the "opid" field is the object's PID, the process
> > being "contained".  Old and new audit container identifier values are
> > given in the "contid" fields, while res indicates its success.
> >
> > It is not permitted to unset or re-set the audit container identifier.
> > A child inherits its parent's audit container identifier, but then can
> > be set only once after.
> >
> > See: https://github.com/linux-audit/audit-kernel/issues/90
> > See: https://github.com/linux-audit/audit-userspace/issues/51
> > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  fs/proc/base.c             | 37 ++++++++++++++++++++++++
> >  include/linux/audit.h      | 25 ++++++++++++++++
> >  include/uapi/linux/audit.h |  2 ++
> >  kernel/auditsc.c           | 71 ++++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 135 insertions(+)
> 
> ...
> 
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -606,6 +621,16 @@ static inline bool audit_loginuid_set(struct task_struct *tsk)
> >        return uid_valid(audit_get_loginuid(tsk));
> > }
> >
> > +static inline bool cid_valid(u64 contid)
> > +{
> > +       return contid != AUDIT_CID_UNSET;
> > +}
> > +
> > +static inline bool audit_contid_set(struct task_struct *tsk)
> > +{
> > +       return cid_valid(audit_get_contid(tsk));
> > +}
> 
> For the sake of consistency I think we should rename cid_valid() to
> audit_contid_valid().

Ok.

> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 59ef7a81..611e926 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -956,6 +956,8 @@ int audit_alloc(struct task_struct *tsk)
> >                 return -ENOMEM;
> >         info->loginuid = audit_get_loginuid(current);
> >         info->sessionid = audit_get_sessionid(current);
> > +       info->contid = audit_get_contid(current);
> > +       info->inherited = true;
> 
> First see my others comments in this patch about inheritence, but if
> we decide that flagging inherited values is important we should
> probably rename the "inherited" field to indicate that it applies to
> just the "contid" field.

Ok.

> >         tsk->audit = info;
> >
> >         if (likely(!audit_ever_enabled))
> > @@ -985,6 +987,8 @@ int audit_alloc(struct task_struct *tsk)
> >  struct audit_task_info init_struct_audit = {
> >         .loginuid = INVALID_UID,
> >         .sessionid = AUDIT_SID_UNSET,
> > +       .contid = AUDIT_CID_UNSET,
> > +       .inherited = true,
> >         .ctx = NULL,
> >  };
> >
> > @@ -2112,6 +2116,73 @@ int audit_set_loginuid(kuid_t loginuid)
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
> > +       /* Can't set if audit disabled */
> > +       if (!task->audit)
> > +               return -ENOPROTOOPT;
> > +       oldcontid = audit_get_contid(task);
> > +       /* Don't allow the audit containerid to be unset */
> > +       if (!cid_valid(contid))
> > +               rc = -EINVAL;
> > +       /* if we don't have caps, reject */
> > +       else if (!capable(CAP_AUDIT_CONTROL))
> > +               rc = -EPERM;
> > +       /* if task has children or is not single-threaded, deny */
> > +       else if (!list_empty(&task->children))
> > +               rc = -EBUSY;
> 
> Is this safe without holding tasklist_lock?  I worry we might be
> vulnerable to a race with fork().
> 
> > +       else if (!(thread_group_leader(task) && thread_group_empty(task)))
> > +               rc = -EALREADY;
> 
> Similar concern here as well, although related to threads.

I think you are correct here and tasklist_lock should cover both.  Do we
also want rcu_read_lock() immediately preceeding it?

> > +       /* it is already set, and not inherited from the parent, reject */
> > +       else if (cid_valid(oldcontid) && !task->audit->inherited)
> > +               rc = -EEXIST;
> 
> Maybe I'm missing something, but why do we care about preventing
> reassigning the audit container ID in this case?  The task is single
> threaded and has no descendants at this point so it should be safe,
> yes?  So long as the task changing the audit container ID has
> capable(CAP_AUDIT_CONTOL) it shouldn't matter, right?

Because we hammered out this idea 6 months ago in the design phase and I
thought we all firmly agreed that the audit container identifier could
only be set once.  Has any significant discussion happenned since then
to change that wisdom?  I just wonder why this is coming up now.

> Related, I'm questioning if we would ever care if the audit container
> ID was inherited or not?

We do since that is the only way we can tell if the value has been set
once already or inherited unless we check if the parent's audit
container identifier is identical (which tells us it was inherited).

> > +       if (!rc) {
> > +               task_lock(task);
> > +               task->audit->contid = contid;
> > +               task->audit->inherited = false;
> > +               task_unlock(task);
> 
> I suspect the task_lock() may not be what we want here, but if we are
> using task_lock() to protect the audit fields two things come to mind:
> 
> 1. We should update the header comments for task_lock() in task.h to
> indicate that it also protects ->audit.

Fair enough.

> 2. Where else do we need to worry about taking this lock?  At the very
> least we should take this lock near the top of this function before we
> check task->audit and not drop it until after we have set it, or
> failed the operation for one of the reasons above.

Agreed, since another process on another CPU could race attempting this
same operation.  However, the task_lock() comment precludes using it
with write_lock_irq(&task_lock) that might be required above.

> > +       }
> > +
> > +       if (!audit_enabled)
> > +               return rc;
> > +
> > +       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_ID);
> > +       if (!ab)
> > +               return rc;
> > +
> > +       uid = from_kuid(&init_user_ns, task_uid(current));
> > +       tty = audit_get_tty(current);
> > +       audit_log_format(ab, "op=set opid=%d old-contid=%llu contid=%llu pid=%d uid=%u auid=%u tty=%s ses=%u",
> > +                        task_tgid_nr(task), oldcontid, contid,
> > +                        task_tgid_nr(current), uid
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
> > +
> > +/**
> >   * __audit_mq_open - record audit data for a POSIX MQ open
> >   * @oflag: open flag
> >   * @mode: mode bits
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
