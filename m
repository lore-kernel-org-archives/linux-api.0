From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH ghak90 V5 02/10] audit: add container id
Date: Wed, 27 Mar 2019 21:38:24 +0100
Message-ID: <CAFqZXNtyzb8LVghoKEwYDC2vkZVbytcEahwpP49_QDR+tM=PNQ@mail.gmail.com>
References: <cover.1552665316.git.rgb@redhat.com>
	<19917968bb133ff644258b95dcbff522a83a2af1.1552665316.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <19917968bb133ff644258b95dcbff522a83a2af1.1552665316.git.rgb@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Richard Guy Briggs <rgb@redhat.com>
Cc: nhorman@tuxdriver.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux-Audit Mailing List <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org, "Eric W . Biederman" <ebiederm@xmission.com>, Simo Sorce <simo@redhat.com>, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 15, 2019 at 7:33 PM Richard Guy Briggs <rgb@redhat.com> wrote:
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
>   type=CONTAINER_OP msg=audit(2018-06-06 12:39:29.636:26949) : op=set opid=2209 old-contid=18446744073709551615 contid=123456 pid=628 auid=root uid=root tty=ttyS0 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 comm=bash exe=/usr/bin/bash res=yes
>
> The "op" field indicates an initial set.  The "pid" to "ses" fields are
> the orchestrator while the "opid" field is the object's PID, the process
> being "contained".  Old and new audit container identifier values are
> given in the "contid" fields, while res indicates its success.
>
> It is not permitted to unset the audit container identifier.
> A child inherits its parent's audit container identifier.
>
> See: https://github.com/linux-audit/audit-kernel/issues/90
> See: https://github.com/linux-audit/audit-userspace/issues/51
> See: https://github.com/linux-audit/audit-testsuite/issues/64
> See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Acked-by: Steve Grubb <sgrubb@redhat.com>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

Note that you have duplicate Signed-off here ^^

Took me a while to understand the flow in audit_set_contid(), but once
understood it all made perfect sense, so:

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>


> ---
>  fs/proc/base.c             | 36 ++++++++++++++++++++++++
>  include/linux/audit.h      | 25 +++++++++++++++++
>  include/uapi/linux/audit.h |  2 ++
>  kernel/audit.c             | 68 ++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 131 insertions(+)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index a23651ce6960..2505c46c8701 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1294,6 +1294,40 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
>         .read           = proc_sessionid_read,
>         .llseek         = generic_file_llseek,
>  };
> +
> +static ssize_t proc_contid_write(struct file *file, const char __user *buf,
> +                                  size_t count, loff_t *ppos)
> +{
> +       struct inode *inode = file_inode(file);
> +       u64 contid;
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
> +       rv = kstrtou64_from_user(buf, count, 10, &contid);
> +       if (rv < 0) {
> +               put_task_struct(task);
> +               return rv;
> +       }
> +
> +       rv = audit_set_contid(task, contid);
> +       put_task_struct(task);
> +       if (rv < 0)
> +               return rv;
> +       return count;
> +}
> +
> +static const struct file_operations proc_contid_operations = {
> +       .write          = proc_contid_write,
> +       .llseek         = generic_file_llseek,
> +};
>  #endif
>
>  #ifdef CONFIG_FAULT_INJECTION
> @@ -3005,6 +3039,7 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
>  #ifdef CONFIG_AUDIT
>         REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
>         REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> +       REG("audit_containerid", S_IWUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>         REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> @@ -3393,6 +3428,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
>  #ifdef CONFIG_AUDIT
>         REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
>         REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> +       REG("audit_containerid", S_IWUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>         REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index bde346e73f0c..301337776193 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -89,6 +89,7 @@ struct audit_field {
>  struct audit_task_info {
>         kuid_t                  loginuid;
>         unsigned int            sessionid;
> +       u64                     contid;
>  #ifdef CONFIG_AUDITSYSCALL
>         struct audit_context    *ctx;
>  #endif
> @@ -189,6 +190,15 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
>         return tsk->audit->sessionid;
>  }
>
> +extern int audit_set_contid(struct task_struct *tsk, u64 contid);
> +
> +static inline u64 audit_get_contid(struct task_struct *tsk)
> +{
> +       if (!tsk->audit)
> +               return AUDIT_CID_UNSET;
> +       return tsk->audit->contid;
> +}
> +
>  extern u32 audit_enabled;
>  #else /* CONFIG_AUDIT */
>  static inline int audit_alloc(struct task_struct *task)
> @@ -250,6 +260,11 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
>         return AUDIT_SID_UNSET;
>  }
>
> +static inline u64 audit_get_contid(struct task_struct *tsk)
> +{
> +       return AUDIT_CID_UNSET;
> +}
> +
>  #define audit_enabled AUDIT_OFF
>  #endif /* CONFIG_AUDIT */
>
> @@ -606,6 +621,16 @@ static inline bool audit_loginuid_set(struct task_struct *tsk)
>         return uid_valid(audit_get_loginuid(tsk));
>  }
>
> +static inline bool audit_contid_valid(u64 contid)
> +{
> +       return contid != AUDIT_CID_UNSET;
> +}
> +
> +static inline bool audit_contid_set(struct task_struct *tsk)
> +{
> +       return audit_contid_valid(audit_get_contid(tsk));
> +}
> +
>  static inline void audit_log_string(struct audit_buffer *ab, const char *buf)
>  {
>         audit_log_n_string(ab, buf, strlen(buf));
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 36a7e3f18e69..d475cf3b4d7f 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -71,6 +71,7 @@
>  #define AUDIT_TTY_SET          1017    /* Set TTY auditing status */
>  #define AUDIT_SET_FEATURE      1018    /* Turn an audit feature on or off */
>  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabled */
> +#define AUDIT_CONTAINER_OP     1020    /* Define the container id and information */
>
>  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly uninteresting to kernel */
>  #define AUDIT_USER_AVC         1107    /* We filter this differently */
> @@ -471,6 +472,7 @@ struct audit_tty_status {
>
>  #define AUDIT_UID_UNSET (unsigned int)-1
>  #define AUDIT_SID_UNSET ((unsigned int)-1)
> +#define AUDIT_CID_UNSET ((u64)-1)
>
>  /* audit_rule_data supports filter rules with both integer and string
>   * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 67498c5690bb..b5c702abeb42 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -244,6 +244,7 @@ int audit_alloc(struct task_struct *tsk)
>         }
>         info->loginuid = audit_get_loginuid(current);
>         info->sessionid = audit_get_sessionid(current);
> +       info->contid = audit_get_contid(current);
>         tsk->audit = info;
>
>         ret = audit_alloc_syscall(tsk);
> @@ -258,6 +259,7 @@ int audit_alloc(struct task_struct *tsk)
>  struct audit_task_info init_struct_audit = {
>         .loginuid = INVALID_UID,
>         .sessionid = AUDIT_SID_UNSET,
> +       .contid = AUDIT_CID_UNSET,
>  #ifdef CONFIG_AUDITSYSCALL
>         .ctx = NULL,
>  #endif
> @@ -2341,6 +2343,72 @@ int audit_set_loginuid(kuid_t loginuid)
>  }
>
>  /**
> + * audit_set_contid - set current task's audit contid
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
> +       uid_t uid;
> +       struct tty_struct *tty;
> +       char comm[sizeof(current->comm)];
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
> +       uid = from_kuid(&init_user_ns, task_uid(current));
> +       tty = audit_get_tty();
> +       audit_log_format(ab, "op=set opid=%d old-contid=%llu contid=%llu pid=%d uid=%u auid=%u tty=%s ses=%u",
> +                        task_tgid_nr(task), oldcontid, contid,
> +                        task_tgid_nr(current), uid,
> +                        from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +                        tty ? tty_name(tty) : "(none)",
> +                        audit_get_sessionid(current));
> +       audit_put_tty(tty);
> +       audit_log_task_context(ab);
> +       audit_log_format(ab, " comm=");
> +       audit_log_untrustedstring(ab, get_task_comm(comm, current));
> +       audit_log_d_path_exe(ab, current->mm);
> +       audit_log_format(ab, " res=%d", !rc);
> +       audit_log_end(ab);
> +       return rc;
> +}
> +
> +/**
>   * audit_log_end - end one audit record
>   * @ab: the audit_buffer
>   *
> --
> 1.8.3.1
>

--
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
