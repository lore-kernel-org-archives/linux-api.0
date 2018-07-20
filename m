From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 01/10] audit: add container id
Date: Fri, 20 Jul 2018 18:13:24 -0400
Message-ID: <CAHC9VhRk+qLAyizM9i8D+cjKxyhruuj_Z9N0QRmjM-fjm4hgRw@mail.gmail.com>
References: <cover.1528304203.git.rgb@redhat.com> <0377c3ced6bdbc44fe17f9a5679cb6eda4304024.1528304203.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0377c3ced6bdbc44fe17f9a5679cb6eda4304024.1528304203.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rgb@redhat.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Wed, Jun 6, 2018 at 1:00 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Implement the proc fs write to set the audit container identifier of a
> process, emitting an AUDIT_CONTAINER_ID record to document the event.
>
> This is a write from the container orchestrator task to a proc entry of
> the form /proc/PID/audit_containerid where PID is the process ID of the
> newly created task that is to become the first task in a container, or
> an additional task added to a container.
>
> The write expects up to a u64 value (unset: 18446744073709551615).
>
> The writer must have capability CAP_AUDIT_CONTROL.
>
> This will produce a record such as this:
>   type=3DCONTAINER_ID msg=3Daudit(2018-06-06 12:39:29.636:26949) : op=3Ds=
et opid=3D2209 old-contid=3D18446744073709551615 contid=3D123456 pid=3D628 =
auid=3Droot uid=3Droot tty=3DttyS0 ses=3D1 subj=3Dunconfined_u:unconfined_r=
:unconfined_t:s0-s0:c0.c1023 comm=3Dbash exe=3D/usr/bin/bash res=3Dyes
>
> The "op" field indicates an initial set.  The "pid" to "ses" fields are
> the orchestrator while the "opid" field is the object's PID, the process
> being "contained".  Old and new audit container identifier values are
> given in the "contid" fields, while res indicates its success.
>
> It is not permitted to unset or re-set the audit container identifier.
> A child inherits its parent's audit container identifier, but then can
> be set only once after.
>
> See: https://github.com/linux-audit/audit-kernel/issues/90
> See: https://github.com/linux-audit/audit-userspace/issues/51
> See: https://github.com/linux-audit/audit-testsuite/issues/64
> See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container=
-ID
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  fs/proc/base.c             | 37 ++++++++++++++++++++++++
>  include/linux/audit.h      | 25 ++++++++++++++++
>  include/uapi/linux/audit.h |  2 ++
>  kernel/auditsc.c           | 71 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  4 files changed, 135 insertions(+)

...

> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -606,6 +621,16 @@ static inline bool audit_loginuid_set(struct task_st=
ruct *tsk)
>        return uid_valid(audit_get_loginuid(tsk));
> }
>
> +static inline bool cid_valid(u64 contid)
> +{
> +       return contid !=3D AUDIT_CID_UNSET;
> +}
> +
> +static inline bool audit_contid_set(struct task_struct *tsk)
> +{
> +       return cid_valid(audit_get_contid(tsk));
> +}

For the sake of consistency I think we should rename cid_valid() to
audit_contid_valid().

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 59ef7a81..611e926 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -956,6 +956,8 @@ int audit_alloc(struct task_struct *tsk)
>                 return -ENOMEM;
>         info->loginuid =3D audit_get_loginuid(current);
>         info->sessionid =3D audit_get_sessionid(current);
> +       info->contid =3D audit_get_contid(current);
> +       info->inherited =3D true;

First see my others comments in this patch about inheritence, but if
we decide that flagging inherited values is important we should
probably rename the "inherited" field to indicate that it applies to
just the "contid" field.

>         tsk->audit =3D info;
>
>         if (likely(!audit_ever_enabled))
> @@ -985,6 +987,8 @@ int audit_alloc(struct task_struct *tsk)
>  struct audit_task_info init_struct_audit =3D {
>         .loginuid =3D INVALID_UID,
>         .sessionid =3D AUDIT_SID_UNSET,
> +       .contid =3D AUDIT_CID_UNSET,
> +       .inherited =3D true,
>         .ctx =3D NULL,
>  };
>
> @@ -2112,6 +2116,73 @@ int audit_set_loginuid(kuid_t loginuid)
>  }
>
>  /**
> + * audit_set_contid - set current task's audit_context contid
> + * @contid: contid value
> + *
> + * Returns 0 on success, -EPERM on permission failure.
> + *
> + * Called (set) from fs/proc/base.c::proc_contid_write().
> + */
> +int audit_set_contid(struct task_struct *task, u64 contid)
> +{
> +       u64 oldcontid;
> +       int rc =3D 0;
> +       struct audit_buffer *ab;
> +       uid_t uid;
> +       struct tty_struct *tty;
> +       char comm[sizeof(current->comm)];
> +
> +       /* Can't set if audit disabled */
> +       if (!task->audit)
> +               return -ENOPROTOOPT;
> +       oldcontid =3D audit_get_contid(task);
> +       /* Don't allow the audit containerid to be unset */
> +       if (!cid_valid(contid))
> +               rc =3D -EINVAL;
> +       /* if we don't have caps, reject */
> +       else if (!capable(CAP_AUDIT_CONTROL))
> +               rc =3D -EPERM;
> +       /* if task has children or is not single-threaded, deny */
> +       else if (!list_empty(&task->children))
> +               rc =3D -EBUSY;

Is this safe without holding tasklist_lock?  I worry we might be
vulnerable to a race with fork().

> +       else if (!(thread_group_leader(task) && thread_group_empty(task))=
)
> +               rc =3D -EALREADY;

Similar concern here as well, although related to threads.

> +       /* it is already set, and not inherited from the parent, reject *=
/
> +       else if (cid_valid(oldcontid) && !task->audit->inherited)
> +               rc =3D -EEXIST;

Maybe I'm missing something, but why do we care about preventing
reassigning the audit container ID in this case?  The task is single
threaded and has no descendants at this point so it should be safe,
yes?  So long as the task changing the audit container ID has
capable(CAP_AUDIT_CONTOL) it shouldn't matter, right?

Related, I'm questioning if we would ever care if the audit container
ID was inherited or not?

> +       if (!rc) {
> +               task_lock(task);
> +               task->audit->contid =3D contid;
> +               task->audit->inherited =3D false;
> +               task_unlock(task);

I suspect the task_lock() may not be what we want here, but if we are
using task_lock() to protect the audit fields two things come to mind:

1. We should update the header comments for task_lock() in task.h to
indicate that it also protects ->audit.
2. Where else do we need to worry about taking this lock?  At the very
least we should take this lock near the top of this function before we
check task->audit and not drop it until after we have set it, or
failed the operation for one of the reasons above.

> +       }
> +
> +       if (!audit_enabled)
> +               return rc;
> +
> +       ab =3D audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAIN=
ER_ID);
> +       if (!ab)
> +               return rc;
> +
> +       uid =3D from_kuid(&init_user_ns, task_uid(current));
> +       tty =3D audit_get_tty(current);
> +       audit_log_format(ab, "op=3Dset opid=3D%d old-contid=3D%llu contid=
=3D%llu pid=3D%d uid=3D%u auid=3D%u tty=3D%s ses=3D%u",
> +                        task_tgid_nr(task), oldcontid, contid,
> +                        task_tgid_nr(current), uid
> +                        from_kuid(&init_user_ns, audit_get_loginuid(curr=
ent)),
> +                        tty ? tty_name(tty) : "(none)",
> +                        audit_get_sessionid(current));
> +       audit_put_tty(tty);
> +       audit_log_task_context(ab);
> +       audit_log_format(ab, " comm=3D");
> +       audit_log_untrustedstring(ab, get_task_comm(comm, current));
> +       audit_log_d_path_exe(ab, current->mm);
> +       audit_log_format(ab, " res=3D%d", !rc);
> +       audit_log_end(ab);
> +       return rc;
> +}
> +
> +/**
>   * __audit_mq_open - record audit data for a POSIX MQ open
>   * @oflag: open flag
>   * @mode: mode bits

--
paul moore
www.paul-moore.com
