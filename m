From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V8 16/16] audit: add capcontid to set contid
 outside init_user_ns
Date: Wed, 22 Jan 2020 16:29:39 -0500
Message-ID: <CAHC9VhQYXQp+C0EHwLuW50yUenfH4KF1xKQdS=bn_OzHfnFmmg@mail.gmail.com>
References: <cover.1577736799.git.rgb@redhat.com> <5941671b6b6b5de28ab2cc80e72f288cf83291d5.1577736799.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <5941671b6b6b5de28ab2cc80e72f288cf83291d5.1577736799.git.rgb@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
> process in a non-init user namespace the capability to set audit
> container identifiers.
>
> Provide /proc/$PID/audit_capcontid interface to capcontid.
> Valid values are: 1==enabled, 0==disabled

It would be good to be more explicit about "enabled" and "disabled" in
the commit description.  For example, which setting allows the target
task to set audit container IDs of it's children processes?

> Report this action in message type AUDIT_SET_CAPCONTID 1022 with fields
> opid= capcontid= old-capcontid=
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  fs/proc/base.c             | 55 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/audit.h      | 14 ++++++++++++
>  include/uapi/linux/audit.h |  1 +
>  kernel/audit.c             | 35 +++++++++++++++++++++++++++++
>  4 files changed, 105 insertions(+)

...

> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 26091800180c..283ef8e006e7 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1360,6 +1360,59 @@ static ssize_t proc_contid_write(struct file *file, const char __user *buf,
>         .write          = proc_contid_write,
>         .llseek         = generic_file_llseek,
>  };
> +
> +static ssize_t proc_capcontid_read(struct file *file, char __user *buf,
> +                                 size_t count, loff_t *ppos)
> +{
> +       struct inode *inode = file_inode(file);
> +       struct task_struct *task = get_proc_task(inode);
> +       ssize_t length;
> +       char tmpbuf[TMPBUFLEN];
> +
> +       if (!task)
> +               return -ESRCH;
> +       /* if we don't have caps, reject */
> +       if (!capable(CAP_AUDIT_CONTROL) && !audit_get_capcontid(current))
> +               return -EPERM;
> +       length = scnprintf(tmpbuf, TMPBUFLEN, "%u", audit_get_capcontid(task));
> +       put_task_struct(task);
> +       return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> +}
> +
> +static ssize_t proc_capcontid_write(struct file *file, const char __user *buf,
> +                                  size_t count, loff_t *ppos)
> +{
> +       struct inode *inode = file_inode(file);
> +       u32 capcontid;
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
> +       rv = kstrtou32_from_user(buf, count, 10, &capcontid);
> +       if (rv < 0) {
> +               put_task_struct(task);
> +               return rv;
> +       }
> +
> +       rv = audit_set_capcontid(task, capcontid);
> +       put_task_struct(task);
> +       if (rv < 0)
> +               return rv;
> +       return count;
> +}
> +
> +static const struct file_operations proc_capcontid_operations = {
> +       .read           = proc_capcontid_read,
> +       .write          = proc_capcontid_write,
> +       .llseek         = generic_file_llseek,
> +};
>  #endif
>
>  #ifdef CONFIG_FAULT_INJECTION
> @@ -3121,6 +3174,7 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
>         REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
>         REG("sessionid",  S_IRUGO, proc_sessionid_operations),
>         REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
> +       REG("audit_capcontainerid", S_IWUSR|S_IRUSR|S_IRUSR, proc_capcontid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>         REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> @@ -3522,6 +3576,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
>         REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
>         REG("sessionid",  S_IRUGO, proc_sessionid_operations),
>         REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
> +       REG("audit_capcontainerid", S_IWUSR|S_IRUSR|S_IRUSR, proc_capcontid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>         REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 28b9c7cd86a6..62c453306c2a 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -116,6 +116,7 @@ struct audit_task_info {
>         kuid_t                  loginuid;
>         unsigned int            sessionid;
>         struct audit_contobj    *cont;
> +       u32                     capcontid;

Where is the code change that actually uses this to enforce the
described policy on setting an audit container ID?

> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 2844d78cd7af..01251e6dcec0 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -73,6 +73,7 @@
>  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabled */
>  #define AUDIT_CONTAINER_OP     1020    /* Define the container id and info */
>  #define AUDIT_SIGNAL_INFO2     1021    /* Get info auditd signal sender */
> +#define AUDIT_SET_CAPCONTID    1022    /* Set cap_contid of a task */
>
>  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly uninteresting to kernel */
>  #define AUDIT_USER_AVC         1107    /* We filter this differently */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 1287f0b63757..1c22dd084ae8 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -2698,6 +2698,41 @@ static bool audit_contid_isowner(struct task_struct *tsk)
>         return false;
>  }
>
> +int audit_set_capcontid(struct task_struct *task, u32 enable)
> +{
> +       u32 oldcapcontid;
> +       int rc = 0;
> +       struct audit_buffer *ab;
> +
> +       if (!task->audit)
> +               return -ENOPROTOOPT;
> +       oldcapcontid = audit_get_capcontid(task);
> +       /* if task is not descendant, block */
> +       if (task == current)
> +               rc = -EBADSLT;
> +       else if (!task_is_descendant(current, task))
> +               rc = -EXDEV;

See my previous comments about error code sanity.

> +       else if (current_user_ns() == &init_user_ns) {
> +               if (!capable(CAP_AUDIT_CONTROL) && !audit_get_capcontid(current))
> +                       rc = -EPERM;

I think we just want to use ns_capable() in the context of the current
userns to check CAP_AUDIT_CONTROL, yes?  Something like this ...

  if (current_user_ns() != &init_user_ns) {
    if (!ns_capable(CAP_AUDIT_CONTROL) || !audit_get_capcontid())
      rc = -EPERM;
  } else if (!capable(CAP_AUDIT_CONTROL))
    rc = -EPERM;

> +       }
> +       if (!rc)
> +               task->audit->capcontid = enable;
> +
> +       if (!audit_enabled)
> +               return rc;
> +
> +       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_SET_CAPCONTID);
> +       if (!ab)
> +               return rc;
> +
> +       audit_log_format(ab,
> +                        "opid=%d capcontid=%u old-capcontid=%u",
> +                        task_tgid_nr(task), enable, oldcapcontid);
> +       audit_log_end(ab);

My prior comments about recording the success/failure, or not emitting
the record on failure, seem relevant here too.

> +       return rc;
> +}
