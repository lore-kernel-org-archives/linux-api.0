From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH ghak90 V5 03/10] audit: read container ID of a process
Date: Mon, 18 Mar 2019 07:10:03 -0400
Message-ID: <20190318111003.GA7364@hmswarspite.think-freely.org>
References: <cover.1552665316.git.rgb@redhat.com>
 <25543e3db4d8f3853119f92c09a60664555249a2.1552665316.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <25543e3db4d8f3853119f92c09a60664555249a2.1552665316.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On Fri, Mar 15, 2019 at 02:29:51PM -0400, Richard Guy Briggs wrote:
> Add support for reading the audit container identifier from the proc
> filesystem.
> 
> This is a read from the proc entry of the form
> /proc/PID/audit_containerid where PID is the process ID of the task
> whose audit container identifier is sought.
> 
> The read expects up to a u64 value (unset: 18446744073709551615).
> 
> This read requires CAP_AUDIT_CONTROL.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> ---
>  fs/proc/base.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 2505c46c8701..0b833cbdf5b6 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1295,6 +1295,24 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
>  	.llseek		= generic_file_llseek,
>  };
>  
> +static ssize_t proc_contid_read(struct file *file, char __user *buf,
> +				  size_t count, loff_t *ppos)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct task_struct *task = get_proc_task(inode);
> +	ssize_t length;
> +	char tmpbuf[TMPBUFLEN*2];
> +
Sorry, didn't notice this previously, but..
Why *2 here?  Its not wrong per-se, but would it be better to just change
TMPBUFLEN to be 22 bytes unilaterally?  Its only ever used on stack calls that
arent that deep, and then you won't have to think about adjusting this call site
if you ever change the value of TMPBUFLEN in the future.

I'm fine with doing this in another patch later, but it seems like a worthwhile
cleanup

functionality looks good beyond that nit.

> +	if (!task)
> +		return -ESRCH;
> +	/* if we don't have caps, reject */
> +	if (!capable(CAP_AUDIT_CONTROL))
> +		return -EPERM;
> +	length = scnprintf(tmpbuf, TMPBUFLEN*2, "%llu", audit_get_contid(task));
> +	put_task_struct(task);
> +	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> +}
> +
>  static ssize_t proc_contid_write(struct file *file, const char __user *buf,
>  				   size_t count, loff_t *ppos)
>  {
> @@ -1325,6 +1343,7 @@ static ssize_t proc_contid_write(struct file *file, const char __user *buf,
>  }
>  
>  static const struct file_operations proc_contid_operations = {
> +	.read		= proc_contid_read,
>  	.write		= proc_contid_write,
>  	.llseek		= generic_file_llseek,
>  };
> @@ -3039,7 +3058,7 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
>  #ifdef CONFIG_AUDIT
>  	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> -	REG("audit_containerid", S_IWUSR, proc_contid_operations),
> +	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> @@ -3428,7 +3447,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
>  #ifdef CONFIG_AUDIT
>  	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> -	REG("audit_containerid", S_IWUSR, proc_contid_operations),
> +	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> -- 
> 1.8.3.1
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
