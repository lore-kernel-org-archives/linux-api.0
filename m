From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH ghak90 V8 02/16] audit: add container id
Date: Wed, 22 Jan 2020 16:28:02 -0500
Message-ID: <CAHC9VhTKE_3bOXs+UcpKDQhatKH92uY3Hy=JA4sXXVGOC0ek8A@mail.gmail.com>
References: <cover.1577736799.git.rgb@redhat.com> <70ad50e69185c50843d5e14462f1c4f03655d503.1577736799.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <70ad50e69185c50843d5e14462f1c4f03655d503.1577736799.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Audit Mailing List <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, omosnace-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Dan Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mpatel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 31, 2019 at 2:49 PM Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Implement the proc fs write to set the audit container identifier of a
> process, emitting an AUDIT_CONTAINER_OP record to document the event.
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
>   type=CONTAINER_OP msg=audit(2018-06-06 12:39:29.636:26949) : op=set opid=2209 contid=123456 old-contid=18446744073709551615
>
> The "op" field indicates an initial set.  The "opid" field is the
> object's PID, the process being "contained".  New and old audit
> container identifier values are given in the "contid" fields.
>
> It is not permitted to unset the audit container identifier.
> A child inherits its parent's audit container identifier.
>
> Please see the github audit kernel issue for the main feature:
>   https://github.com/linux-audit/audit-kernel/issues/90
> Please see the github audit userspace issue for supporting additions:
>   https://github.com/linux-audit/audit-userspace/issues/51
> Please see the github audit testsuiite issue for the test case:
>   https://github.com/linux-audit/audit-testsuite/issues/64
> Please see the github audit wiki for the feature overview:
>   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
>
> Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
> Acked-by: Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
> Reviewed-by: Ondrej Mosnacek <omosnace-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/proc/base.c             | 36 ++++++++++++++++++++++++++++
>  include/linux/audit.h      | 25 ++++++++++++++++++++
>  include/uapi/linux/audit.h |  2 ++
>  kernel/audit.c             | 58 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/audit.h             |  1 +
>  kernel/auditsc.c           |  4 ++++
>  6 files changed, 126 insertions(+)

...

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 397f8fb4836a..2d7707426b7d 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -2356,6 +2358,62 @@ int audit_signal_info(int sig, struct task_struct *t)
>         return audit_signal_info_syscall(t);
>  }
>
> +/*
> + * audit_set_contid - set current task's audit contid
> + * @task: target task
> + * @contid: contid value
> + *
> + * Returns 0 on success, -EPERM on permission failure.
> + *
> + * Called (set) from fs/proc/base.c::proc_contid_write().
> + */
> +int audit_set_contid(struct task_struct *task, u64 contid)
> +{
> +       u64 oldcontid;
> +       int rc = 0;
> +       struct audit_buffer *ab;
> +
> +       task_lock(task);
> +       /* Can't set if audit disabled */
> +       if (!task->audit) {
> +               task_unlock(task);
> +               return -ENOPROTOOPT;
> +       }
> +       oldcontid = audit_get_contid(task);
> +       read_lock(&tasklist_lock);
> +       /* Don't allow the audit containerid to be unset */
> +       if (!audit_contid_valid(contid))
> +               rc = -EINVAL;
> +       /* if we don't have caps, reject */
> +       else if (!capable(CAP_AUDIT_CONTROL))
> +               rc = -EPERM;
> +       /* if task has children or is not single-threaded, deny */
> +       else if (!list_empty(&task->children))
> +               rc = -EBUSY;
> +       else if (!(thread_group_leader(task) && thread_group_empty(task)))
> +               rc = -EALREADY;

[NOTE: there is a bigger issue below which I think is going to require
a respin/fixup of this patch so I'm going to take the opportunity to
do a bit more bikeshedding ;)]

It seems like we could combine both the thread/children checks under a
single -EBUSY return value.  In both cases the caller should be able
to determine if the target process is multi-threaded for has spawned
children, yes?  FWIW, my motivation for this question is that
-EALREADY seems like a poor choice here.

> +       /* if contid is already set, deny */
> +       else if (audit_contid_set(task))
> +               rc = -ECHILD;

Does -EEXIST make more sense here?

> +       read_unlock(&tasklist_lock);
> +       if (!rc)
> +               task->audit->contid = contid;
> +       task_unlock(task);
> +
> +       if (!audit_enabled)
> +               return rc;
> +
> +       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
> +       if (!ab)
> +               return rc;
> +
> +       audit_log_format(ab,
> +                        "op=set opid=%d contid=%llu old-contid=%llu",
> +                        task_tgid_nr(task), contid, oldcontid);
> +       audit_log_end(ab);

Assuming audit is enabled we always emit the record above, even if we
were not actually able to set the Audit Container ID (ACID); this
seems wrong to me.  I think the proper behavior would be to either add
a "res=" field to indicate success/failure or only emit the record
when we actually change a task's ACID.  Considering the impact that
the ACID value will potentially have on the audit stream, it seems
like always logging the record and including a "res=" field may be the
safer choice.


> +       return rc;
> +}
> +
>  /**
>   * audit_log_end - end one audit record
>   * @ab: the audit_buffer
