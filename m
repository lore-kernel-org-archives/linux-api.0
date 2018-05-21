From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [RFC PATCH ghak32 V2 13/13] debug audit: read container ID of a process
Date: Mon, 21 May 2018 15:16:01 -0400
Message-ID: <3001737.MkQ41rgtZF@x2>
References: <cover.1521179281.git.rgb@redhat.com> <1081821010c124fe4e35984ec3dac1654453bb7c.1521179281.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1081821010c124fe4e35984ec3dac1654453bb7c.1521179281.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-audit@redhat.com
Cc: Richard Guy Briggs <rgb@redhat.com>, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Friday, March 16, 2018 5:00:40 AM EDT Richard Guy Briggs wrote:
> Add support for reading the container ID from the proc filesystem.

I think this could be useful in general. Please consider this to be part of 
the full patch set and not something merely used to debug the patches.

-Steve

> This is a read from the proc entry of the form /proc/PID/containerid
> where PID is the process ID of the task whose container ID is sought.
> 
> The read expects up to a u64 value (unset: 18446744073709551615).
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  fs/proc/base.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 6ce4fbe..f66d1e2 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1300,6 +1300,21 @@ static ssize_t proc_sessionid_read(struct file *
> file, char __user * buf, .llseek		= generic_file_llseek,
>  };
> 
> +static ssize_t proc_containerid_read(struct file *file, char __user *buf,
> +				  size_t count, loff_t *ppos)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct task_struct *task = get_proc_task(inode);
> +	ssize_t length;
> +	char tmpbuf[TMPBUFLEN*2];
> +
> +	if (!task)
> +		return -ESRCH;
> +	length = scnprintf(tmpbuf, TMPBUFLEN*2, "%llu",
> audit_get_containerid(task)); +	put_task_struct(task);
> +	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> +}
> +
>  static ssize_t proc_containerid_write(struct file *file, const char __user
> *buf, size_t count, loff_t *ppos)
>  {
> @@ -1330,6 +1345,7 @@ static ssize_t proc_containerid_write(struct file
> *file, const char __user *buf, }
> 
>  static const struct file_operations proc_containerid_operations = {
> +	.read		= proc_containerid_read,
>  	.write		= proc_containerid_write,
>  	.llseek		= generic_file_llseek,
>  };
> @@ -2996,7 +3012,7 @@ static int proc_pid_patch_state(struct seq_file *m,
> struct pid_namespace *ns, #ifdef CONFIG_AUDITSYSCALL
>  	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> -	REG("containerid", S_IWUSR, proc_containerid_operations),
> +	REG("containerid", S_IWUSR|S_IRUSR, proc_containerid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> @@ -3391,7 +3407,7 @@ static int proc_tid_comm_permission(struct inode
> *inode, int mask) #ifdef CONFIG_AUDITSYSCALL
>  	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> -	REG("containerid", S_IWUSR, proc_containerid_operations),
> +	REG("containerid", S_IWUSR|S_IRUSR, proc_containerid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
