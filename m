From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak32 V2 01/13] audit: add container id
Date: Wed, 18 Apr 2018 19:47:44 -0400
Message-ID: <CAHC9VhTyvxxj2e2Gn+iyW6iLLeYB7hp8a+JvfeMmJ2nUPqtEaw@mail.gmail.com>
References: <cover.1521179281.git.rgb@redhat.com> <e284617ad667ad8f17958dd8babb87fe1b4d7205.1521179281.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e284617ad667ad8f17958dd8babb87fe1b4d7205.1521179281.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Implement the proc fs write to set the audit container ID of a process,
> emitting an AUDIT_CONTAINER record to document the event.
>
> This is a write from the container orchestrator task to a proc entry of
> the form /proc/PID/containerid where PID is the process ID of the newly
> created task that is to become the first task in a container, or an
> additional task added to a container.
>
> The write expects up to a u64 value (unset: 18446744073709551615).
>
> This will produce a record such as this:
> type=CONTAINER msg=audit(1519903238.968:261): op=set pid=596 uid=0 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 auid=0 tty=pts0 ses=1 opid=596 old-contid=18446744073709551615 contid=123455 res=0
>
> The "op" field indicates an initial set.  The "pid" to "ses" fields are
> the orchestrator while the "opid" field is the object's PID, the process
> being "contained".  Old and new container ID values are given in the
> "contid" fields, while res indicates its success.
>
> It is not permitted to self-set, unset or re-set the container ID.  A
> child inherits its parent's container ID, but then can be set only once
> after.
>
> See: https://github.com/linux-audit/audit-kernel/issues/32
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  fs/proc/base.c             | 37 ++++++++++++++++++++
>  include/linux/audit.h      | 16 +++++++++
>  include/linux/init_task.h  |  4 ++-
>  include/linux/sched.h      |  1 +
>  include/uapi/linux/audit.h |  2 ++
>  kernel/auditsc.c           | 84 ++++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 143 insertions(+), 1 deletion(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 60316b5..6ce4fbe 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1299,6 +1299,41 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
>         .read           = proc_sessionid_read,
>         .llseek         = generic_file_llseek,
>  };
> +
> +static ssize_t proc_containerid_write(struct file *file, const char __user *buf,
> +                                  size_t count, loff_t *ppos)
> +{
> +       struct inode *inode = file_inode(file);
> +       u64 containerid;
> +       int rv;
> +       struct task_struct *task = get_proc_task(inode);
> +
> +       if (!task)
> +               return -ESRCH;
> +       if (*ppos != 0) {
> +               /* No partial writes. */
> +               put_task_struct(task);
> +               return -EINVAL;
> +       }
> +
> +       rv = kstrtou64_from_user(buf, count, 10, &containerid);
> +       if (rv < 0) {
> +               put_task_struct(task);
> +               return rv;
> +       }
> +
> +       rv = audit_set_containerid(task, containerid);
> +       put_task_struct(task);
> +       if (rv < 0)
> +               return rv;
> +       return count;
> +}
> +
> +static const struct file_operations proc_containerid_operations = {
> +       .write          = proc_containerid_write,
> +       .llseek         = generic_file_llseek,
> +};
> +
>  #endif
>
>  #ifdef CONFIG_FAULT_INJECTION
> @@ -2961,6 +2996,7 @@ static int proc_pid_patch_state(struct seq_file *m, struct pid_namespace *ns,
>  #ifdef CONFIG_AUDITSYSCALL
>         REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
>         REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> +       REG("containerid", S_IWUSR, proc_containerid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>         REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> @@ -3355,6 +3391,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
>  #ifdef CONFIG_AUDITSYSCALL
>         REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
>         REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> +       REG("containerid", S_IWUSR, proc_containerid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>         REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index af410d9..fe4ba3f 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -29,6 +29,7 @@
>
>  #define AUDIT_INO_UNSET ((unsigned long)-1)
>  #define AUDIT_DEV_UNSET ((dev_t)-1)
> +#define INVALID_CID AUDIT_CID_UNSET

Why can't we just use AUDIT_CID_UNSET?  Is there an important
distinction?  If so, they shouldn't they have different values?

If we do need to keep INVALID_CID, let's rename it to
AUDIT_CID_INVALID so we have some consistency to the naming patterns
and we stress that it is an *audit* container ID.

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d258826..1b82191 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -796,6 +796,7 @@ struct task_struct {
>  #ifdef CONFIG_AUDITSYSCALL
>         kuid_t                          loginuid;
>         unsigned int                    sessionid;
> +       u64                             containerid;

This one line addition to the task_struct scares me the most of
anything in this patchset.  Why?  It's a field named "containerid" in
a perhaps one of the most widely used core kernel structures; the
possibilities for abuse are endless, and it's foolish to think we
would ever be able to adequately police this.

Unfortunately, we can't add the field to audit_context as things
currently stand because we don't always allocate an audit_context,
it's dependent on the system's configuration, and we need to track the
audit container ID for a given process, regardless of the audit
configuration.  Pretty much the same reason why loginuid and sessionid
are located directly in task_struct now.  As I stressed during the
design phase, I really want to keep this as an *audit* container ID
and not a general purpose kernel wide container ID.  If the kernel
ever grows a general purpose container ID token, I'll be the first in
line to convert the audit code, but I don't want audit to be that
general purpose mechanism ... audit is hated enough as-is ;)

I think the right solution to this is to create another new struct,
audit_task_info (or similar, the name really isn't that important),
which would be stored as a pointer in task_struct and would replace
the audit_context pointer, loginuid, sessionid, and the newly proposed
containerid.  The new audit_task_info would always be allocated in the
audit_alloc() function (please use kmem_cache), and the audit_context
pointer included inside would continue to be allocated based on the
existing conditions.  By keeping audit_task_info as a pointer inside
task_struct we could hide the structure definition inside
kernel/audit*.c and make it much more difficult for other subsystems
to abuse it.[1]

  struct audit_task_info {
    kuid_t loginuid;
    unsigned int sessionid;
    u64 containerid;
    struct audit_context *ctx;
  }

Actually, we might even want to consider storing audit_context in
audit_task_info (no pointer), or making it a zero length array
(ctx[0]) and going with a variable sized allocation of audit_task_info
... but all that could be done as a follow up optimization once we get
the basic idea sorted.

[1] If for some reason allocating audit_task_info becomes too much
overhead to bear (somewhat doubtful since we would only do it at task
creation), we could do some ugly tricks to directly include an
audit_task_struct chunk in task_struct but I'd like to avoid that if
possible (and I think we can).

>  #endif
>         struct seccomp                  seccomp;

...

> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 4e61a9e..921a71f 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -71,6 +71,7 @@
>  #define AUDIT_TTY_SET          1017    /* Set TTY auditing status */
>  #define AUDIT_SET_FEATURE      1018    /* Turn an audit feature on or off */
>  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabled */
> +#define AUDIT_CONTAINER                1020    /* Define the container id and information */
>
>  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly uninteresting to kernel */
>  #define AUDIT_USER_AVC         1107    /* We filter this differently */
> @@ -465,6 +466,7 @@ struct audit_tty_status {
>  };
>
>  #define AUDIT_UID_UNSET (unsigned int)-1
> +#define AUDIT_CID_UNSET ((u64)-1)

I think we need to decide if we want to distinguish between the "host"
(e.g. init ns) and "unset".  Looking at this patch (I've only quickly
skimmed the others so far) it would appear that you don't think we
need to worry about this distinction; that's fine, but let's make it
explicit with a comment in the code that AUDIT_CID_UNSET means "unset"
as well as "host".

If we do need to make a distinction, let's add a constant/macro for "host".

>  /* audit_rule_data supports filter rules with both integer and string
>   * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 4e0a4ac..29c8482 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2073,6 +2073,90 @@ int audit_set_loginuid(kuid_t loginuid)
>         return rc;
>  }
>
> +static int audit_set_containerid_perm(struct task_struct *task, u64 containerid)
> +{
> +       struct task_struct *parent;
> +       u64 pcontainerid, ccontainerid;
> +
> +       /* Don't allow to set our own containerid */
> +       if (current == task)
> +               return -EPERM;

Why not?  Is there some obvious security concern that I missing?

I ask because I suppose it might be possible for some container
runtime to do a fork, setup some of the environment and them exec the
container (before you answer the obvious "namespaces!" please remember
we're not trying to define containers).

> +       /* Don't allow the containerid to be unset */
> +       if (!cid_valid(containerid))
> +               return -EINVAL;
> +       /* if we don't have caps, reject */
> +       if (!capable(CAP_AUDIT_CONTROL))
> +               return -EPERM;
> +       /* if containerid is unset, allow */
> +       if (!audit_containerid_set(task))
> +               return 0;
> +       /* it is already set, and not inherited from the parent, reject */
> +       ccontainerid = audit_get_containerid(task);
> +       rcu_read_lock();
> +       parent = rcu_dereference(task->real_parent);
> +       rcu_read_unlock();
> +       task_lock(parent);
> +       pcontainerid = audit_get_containerid(parent);
> +       task_unlock(parent);
> +       if (ccontainerid != pcontainerid)
> +               return -EPERM;
> +       return 0;
> +}
> +
> +static void audit_log_set_containerid(struct task_struct *task, u64 oldcontainerid,
> +                                     u64 containerid, int rc)
> +{
> +       struct audit_buffer *ab;
> +       uid_t uid;
> +       struct tty_struct *tty;
> +
> +       if (!audit_enabled)
> +               return;
> +
> +       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONTAINER);
> +       if (!ab)
> +               return;
> +
> +       uid = from_kuid(&init_user_ns, task_uid(current));
> +       tty = audit_get_tty(current);
> +
> +       audit_log_format(ab, "op=set pid=%d uid=%u", task_tgid_nr(current), uid);
> +       audit_log_task_context(ab);
> +       audit_log_format(ab, " auid=%u tty=%s ses=%u opid=%d old-contid=%llu contid=%llu res=%d",
> +                        from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +                        tty ? tty_name(tty) : "(none)", audit_get_sessionid(current),
> +                        task_tgid_nr(task), oldcontainerid, containerid, !rc);
> +
> +       audit_put_tty(tty);
> +       audit_log_end(ab);
> +}
> +
> +/**
> + * audit_set_containerid - set current task's audit_context containerid
> + * @containerid: containerid value
> + *
> + * Returns 0 on success, -EPERM on permission failure.
> + *
> + * Called (set) from fs/proc/base.c::proc_containerid_write().
> + */
> +int audit_set_containerid(struct task_struct *task, u64 containerid)
> +{
> +       u64 oldcontainerid;
> +       int rc;
> +
> +       oldcontainerid = audit_get_containerid(task);
> +
> +       rc = audit_set_containerid_perm(task, containerid);
> +       if (!rc) {
> +               task_lock(task);
> +               task->containerid = containerid;
> +               task_unlock(task);
> +       }
> +
> +       audit_log_set_containerid(task, oldcontainerid, containerid, rc);
> +       return rc;

Why are audit_set_containerid_perm() and audit_log_containerid()
separate functions?

-- 
paul moore
www.paul-moore.com
