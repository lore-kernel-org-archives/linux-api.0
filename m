From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 02/10] audit: log container info of syscalls
Date: Wed, 06 Jun 2018 13:58:23 -0400
Message-ID: <2362206.kre0QU9EL8@x2>
References: <cover.1528304203.git.rgb@redhat.com> <b839dc7fb29aae226b2a4602e7ef3c2a406ee90a.1528304203.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b839dc7fb29aae226b2a4602e7ef3c2a406ee90a.1528304203.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-audit@redhat.com
Cc: Richard Guy Briggs <rgb@redhat.com>, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Wednesday, June 6, 2018 12:58:29 PM EDT Richard Guy Briggs wrote:
> Create a new audit record AUDIT_CONTAINER to document the audit
> container identifier of a process if it is present.
> 
> Called from audit_log_exit(), syscalls are covered.
> 
> A sample raw event:
> type=SYSCALL msg=audit(1519924845.499:257): arch=c000003e syscall=257
> success=yes exit=3 a0=ffffff9c a1=56374e1cef30 a2=241 a3=1b6 items=2
> ppid=606 pid=635 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
> fsgid=0 tty=pts0 ses=3 comm="bash" exe="/usr/bin/bash"
> subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> key="tmpcontainerid" type=CWD msg=audit(1519924845.499:257): cwd="/root"
> type=PATH msg=audit(1519924845.499:257): item=0 name="/tmp/" inode=13863
> dev=00:27 mode=041777 ouid=0 ogid=0 rdev=00:00
> obj=system_u:object_r:tmp_t:s0 nametype= PARENT cap_fp=0000000000000000
> cap_fi=0000000000000000 cap_fe=0 cap_fver=0 type=PATH
> msg=audit(1519924845.499:257): item=1 name="/tmp/tmpcontainerid"
> inode=17729 dev=00:27 mode=0100644 ouid=0 ogid=0 rdev=00:00
> obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE
> cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
> type=PROCTITLE msg=audit(1519924845.499:257):
> proctitle=62617368002D6300736C65657020313B206563686F2074657374203E202F746D
> 702F746D70636F6E7461696E65726964 type=CONTAINER
> msg=audit(1519924845.499:257): op=task contid=123458

Ack for the audit record names.

-Steve

> See: https://github.com/linux-audit/audit-kernel/issues/90
> See: https://github.com/linux-audit/audit-userspace/issues/51
> See: https://github.com/linux-audit/audit-testsuite/issues/64
> See:
> https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h      |  7 +++++++
>  include/uapi/linux/audit.h |  1 +
>  kernel/audit.c             | 23 +++++++++++++++++++++++
>  kernel/auditsc.c           |  3 +++
>  4 files changed, 34 insertions(+)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 497cd81..4e1e34e 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -152,6 +152,9 @@ extern void		    audit_log_key(struct audit_buffer 
*ab,
> extern int audit_log_task_context(struct audit_buffer *ab);
>  extern void audit_log_task_info(struct audit_buffer *ab,
>  				struct task_struct *tsk);
> +extern int audit_log_contid(struct task_struct *tsk,
> +				    struct audit_context *context,
> +				    char *op);
> 
>  extern int		    audit_update_lsm_rules(void);
> 
> @@ -202,6 +205,10 @@ static inline int audit_log_task_context(struct
> audit_buffer *ab) static inline void audit_log_task_info(struct
> audit_buffer *ab,
>  				       struct task_struct *tsk)
>  { }
> +static inline int audit_log_contid(struct task_struct *tsk,
> +					   struct audit_context *context,
> +					   char *op)
> +{ }
>  #define audit_enabled 0
>  #endif /* CONFIG_AUDIT */
> 
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index c3b1aca..469ab25 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -115,6 +115,7 @@
>  #define AUDIT_REPLACE		1329	/* Replace auditd if this packet unanswerd 
*/
>  #define AUDIT_KERN_MODULE	1330	/* Kernel Module events */
>  #define AUDIT_FANOTIFY		1331	/* Fanotify access decision */
> +#define AUDIT_CONTAINER		1332	/* Container ID */
> 
>  #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
>  #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index e7478cb..5e150c6 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -2048,6 +2048,29 @@ void audit_log_session_info(struct audit_buffer *ab)
> audit_log_format(ab, " auid=%u ses=%u", auid, sessionid);
>  }
> 
> +/*
> + * audit_log_contid - report container info
> + * @tsk: task to be recorded
> + * @context: task or local context for record
> + * @op: contid string description
> + */
> +int audit_log_contid(struct task_struct *tsk,
> +			     struct audit_context *context, char *op)
> +{
> +	struct audit_buffer *ab;
> +
> +	if (!audit_contid_set(tsk))
> +		return 0;
> +	/* Generate AUDIT_CONTAINER record with container ID */
> +	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER);
> +	if (!ab)
> +		return -ENOMEM;
> +	audit_log_format(ab, "op=%s contid=%llu",
> +			 op, audit_get_contid(tsk));
> +	audit_log_end(ab);
> +	return 0;
> +}
> +
>  void audit_log_key(struct audit_buffer *ab, char *key)
>  {
>  	audit_log_format(ab, " key=");
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 611e926..a3c946c 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1490,10 +1490,13 @@ static void audit_log_exit(struct audit_context
> *context, struct task_struct *ts
> 
>  	audit_log_proctitle(tsk, context);
> 
> +	audit_log_contid(tsk, context, "task");
> +
>  	/* Send end of event record to help user space know we are finished */
>  	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
>  	if (ab)
>  		audit_log_end(ab);
> +
>  	if (call_panic)
>  		audit_panic("error converting sid to string");
>  }
