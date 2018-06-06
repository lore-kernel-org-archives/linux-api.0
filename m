From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 01/10] audit: add container id
Date: Wed, 06 Jun 2018 13:56:25 -0400
Message-ID: <1828967.ZGm5HJUlmN@x2>
References: <cover.1528304203.git.rgb@redhat.com> <0377c3ced6bdbc44fe17f9a5679cb6eda4304024.1528304203.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0377c3ced6bdbc44fe17f9a5679cb6eda4304024.1528304203.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-audit@redhat.com
Cc: Richard Guy Briggs <rgb@redhat.com>, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Wednesday, June 6, 2018 12:58:28 PM EDT Richard Guy Briggs wrote:
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
>   type=CONTAINER_ID msg=audit(2018-06-06 12:39:29.636:26949) : op=set
> opid=2209 old-contid=18446744073709551615 contid=123456 pid=628 auid=root
> uid=root tty=ttyS0 ses=1
> subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 comm=bash
> exe=/usr/bin/bash res=yes
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
> See:
> https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  fs/proc/base.c             | 37 ++++++++++++++++++++++++
>  include/linux/audit.h      | 25 ++++++++++++++++
>  include/uapi/linux/audit.h |  2 ++
>  kernel/auditsc.c           | 71
> ++++++++++++++++++++++++++++++++++++++++++++++ 4 files changed, 135
> insertions(+)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index eafa39a..318dff4 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1302,6 +1302,41 @@ static ssize_t proc_sessionid_read(struct file *
> file, char __user * buf, .read		= proc_sessionid_read,
>  	.llseek		= generic_file_llseek,
>  };
> +
> +static ssize_t proc_contid_write(struct file *file, const char __user
> *buf, +				   size_t count, loff_t *ppos)
> +{
> +	struct inode *inode = file_inode(file);
> +	u64 contid;
> +	int rv;
> +	struct task_struct *task = get_proc_task(inode);
> +
> +	if (!task)
> +		return -ESRCH;
> +	if (*ppos != 0) {
> +		/* No partial writes. */
> +		put_task_struct(task);
> +		return -EINVAL;
> +	}
> +
> +	rv = kstrtou64_from_user(buf, count, 10, &contid);
> +	if (rv < 0) {
> +		put_task_struct(task);
> +		return rv;
> +	}
> +
> +	rv = audit_set_contid(task, contid);
> +	put_task_struct(task);
> +	if (rv < 0)
> +		return rv;
> +	return count;
> +}
> +
> +static const struct file_operations proc_contid_operations = {
> +	.write		= proc_contid_write,
> +	.llseek		= generic_file_llseek,
> +};
> +
>  #endif
> 
>  #ifdef CONFIG_FAULT_INJECTION
> @@ -2995,6 +3030,7 @@ static int proc_pid_patch_state(struct seq_file *m,
> struct pid_namespace *ns, #ifdef CONFIG_AUDITSYSCALL
>  	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> +	REG("audit_containerid", S_IWUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> @@ -3386,6 +3422,7 @@ static int proc_tid_comm_permission(struct inode
> *inode, int mask) #ifdef CONFIG_AUDITSYSCALL
>  	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> +	REG("audit_containerid", S_IWUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 4f824c4..497cd81 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -219,6 +219,8 @@ static inline void audit_log_task_info(struct
> audit_buffer *ab, struct audit_task_info {
>  	kuid_t			loginuid;
>  	unsigned int		sessionid;
> +	u64			contid;
> +	bool			inherited; /* containerid inheritance */
>  	struct audit_context	*ctx;
>  };
>  extern struct audit_task_info init_struct_audit;
> @@ -331,6 +333,7 @@ static inline void audit_ptrace(struct task_struct *t)
>  extern int auditsc_get_stamp(struct audit_context *ctx,
>  			      struct timespec64 *t, unsigned int *serial);
>  extern int audit_set_loginuid(kuid_t loginuid);
> +extern int audit_set_contid(struct task_struct *tsk, u64 contid);
> 
>  static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
>  {
> @@ -348,6 +351,14 @@ static inline unsigned int audit_get_sessionid(struct
> task_struct *tsk) return AUDIT_SID_UNSET;
>  }
> 
> +static inline u64 audit_get_contid(struct task_struct *tsk)
> +{
> +	if (!tsk->audit)
> +		return AUDIT_CID_UNSET;
> +	else
> +		return tsk->audit->contid;
> +}
> +
>  extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
>  extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t
> gid, umode_t mode); extern void __audit_bprm(struct linux_binprm *bprm);
> @@ -542,6 +553,10 @@ static inline unsigned int audit_get_sessionid(struct
> task_struct *tsk) {
>  	return AUDIT_SID_UNSET;
>  }
> +static inline kuid_t audit_get_contid(struct task_struct *tsk)
> +{
> +	return AUDIT_CID_UNSET;
> +}
>  static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
>  { }
>  static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid,
> @@ -606,6 +621,16 @@ static inline bool audit_loginuid_set(struct
> task_struct *tsk) return uid_valid(audit_get_loginuid(tsk));
>  }
> 
> +static inline bool cid_valid(u64 contid)
> +{
> +	return contid != AUDIT_CID_UNSET;
> +}
> +
> +static inline bool audit_contid_set(struct task_struct *tsk)
> +{
> +	return cid_valid(audit_get_contid(tsk));
> +}
> +
>  static inline void audit_log_string(struct audit_buffer *ab, const char
> *buf) {
>  	audit_log_n_string(ab, buf, strlen(buf));
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 04f9bd2..c3b1aca 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -71,6 +71,7 @@
>  #define AUDIT_TTY_SET		1017	/* Set TTY auditing status */
>  #define AUDIT_SET_FEATURE	1018	/* Turn an audit feature on or off */
>  #define AUDIT_GET_FEATURE	1019	/* Get which features are enabled */
> +#define AUDIT_CONTAINER_ID	1020	/* Define the container id and 
information
> */
> 
>  #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly
> uninteresting to kernel */ #define AUDIT_USER_AVC		1107	/* We filter this
> differently */
> @@ -466,6 +467,7 @@ struct audit_tty_status {
> 
>  #define AUDIT_UID_UNSET (unsigned int)-1
>  #define AUDIT_SID_UNSET ((unsigned int)-1)
> +#define AUDIT_CID_UNSET ((u64)-1)
> 
>  /* audit_rule_data supports filter rules with both integer and string
>   * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 59ef7a81..611e926 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -956,6 +956,8 @@ int audit_alloc(struct task_struct *tsk)
>  		return -ENOMEM;
>  	info->loginuid = audit_get_loginuid(current);
>  	info->sessionid = audit_get_sessionid(current);
> +	info->contid = audit_get_contid(current);
> +	info->inherited = true;
>  	tsk->audit = info;
> 
>  	if (likely(!audit_ever_enabled))
> @@ -985,6 +987,8 @@ int audit_alloc(struct task_struct *tsk)
>  struct audit_task_info init_struct_audit = {
>  	.loginuid = INVALID_UID,
>  	.sessionid = AUDIT_SID_UNSET,
> +	.contid = AUDIT_CID_UNSET,
> +	.inherited = true,
>  	.ctx = NULL,
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
> +	u64 oldcontid;
> +	int rc = 0;
> +	struct audit_buffer *ab;
> +	uid_t uid;
> +	struct tty_struct *tty;
> +	char comm[sizeof(current->comm)];
> +
> +	/* Can't set if audit disabled */
> +	if (!task->audit)
> +		return -ENOPROTOOPT;
> +	oldcontid = audit_get_contid(task);
> +	/* Don't allow the audit containerid to be unset */
> +	if (!cid_valid(contid))
> +		rc = -EINVAL;
> +	/* if we don't have caps, reject */
> +	else if (!capable(CAP_AUDIT_CONTROL))
> +		rc = -EPERM;
> +	/* if task has children or is not single-threaded, deny */
> +	else if (!list_empty(&task->children))
> +		rc = -EBUSY;
> +	else if (!(thread_group_leader(task) && thread_group_empty(task)))
> +		rc = -EALREADY;
> +	/* it is already set, and not inherited from the parent, reject */
> +	else if (cid_valid(oldcontid) && !task->audit->inherited)
> +		rc = -EEXIST;
> +	if (!rc) {
> +		task_lock(task);
> +		task->audit->contid = contid;
> +		task->audit->inherited = false;
> +		task_unlock(task);
> +	}
> +
> +	if (!audit_enabled)
> +		return rc;
> +
> +	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_ID);
> +	if (!ab)
> +		return rc;
> +
> +	uid = from_kuid(&init_user_ns, task_uid(current));
> +	tty = audit_get_tty(current);
> +	audit_log_format(ab, "op=set opid=%d old-contid=%llu contid=%llu pid=%d
> uid=%u auid=%u tty=%s ses=%u", +			 task_tgid_nr(task), oldcontid, 
contid,
> +			 task_tgid_nr(current), uid
> +			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +			 tty ? tty_name(tty) : "(none)",
> +			 audit_get_sessionid(current));

The event code doesn't match the example event at the top. (uid and auid are 
transposed.) But the code looks right. 

Ack for the event format.

-Steve

> +	audit_put_tty(tty);
> +	audit_log_task_context(ab);
> +	audit_log_format(ab, " comm=");
> +	audit_log_untrustedstring(ab, get_task_comm(comm, current));
> +	audit_log_d_path_exe(ab, current->mm);
> +	audit_log_format(ab, " res=%d", !rc);
> +	audit_log_end(ab);
> +	return rc;
> +}
> +
> +/**
>   * __audit_mq_open - record audit data for a POSIX MQ open
>   * @oflag: open flag
>   * @mode: mode bits
