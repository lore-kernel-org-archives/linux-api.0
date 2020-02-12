From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH v2 3/6] Teach SELinux about a new userfaultfd class
Date: Wed, 12 Feb 2020 12:05:38 -0500
Message-ID: <ef13d728-9f1e-5e38-28a1-7ed7134840e4@tycho.nsa.gov>
References: <20200211225547.235083-1-dancol@google.com>
 <20200211225547.235083-4-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211225547.235083-4-dancol@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>, timmurray@google.com, nosh@google.com, nnk@google.com, lokeshgidra@google.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, selinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2/11/20 5:55 PM, Daniel Colascione wrote:
> Use the secure anonymous inode LSM hook we just added to let SELinux
> policy place restrictions on userfaultfd use. The create operation
> applies to processes creating new instances of these file objects;
> transfer between processes is covered by restrictions on read, write,
> and ioctl access already checked inside selinux_file_receive.
> 
> Signed-off-by: Daniel Colascione <dancol@google.com>

(please add linux-fsdevel and viro to the cc for future versions of this 
patch since it changes the VFS)

> ---
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 1659b59fb5d7..e178f6f40e93 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2915,6 +2919,69 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
>   	return 0;
>   }
>   
> +static int selinux_inode_init_security_anon(struct inode *inode,
> +					    const char *name,
> +					    const struct file_operations *fops)
> +{
> +	const struct task_security_struct *tsec = selinux_cred(current_cred());
> +	struct common_audit_data ad;
> +	struct inode_security_struct *isec;
> +
> +	if (unlikely(IS_PRIVATE(inode)))
> +		return 0;

Seems like this is precluded by the caller and would be a bug?  If 
needed at all, take it to the security_inode_init_security_anon() so it 
doesn't have to be repeated in each security module.

> +
> +	/*
> +	 * We shouldn't be creating secure anonymous inodes before LSM
> +	 * initialization completes.
> +	 */
> +	if (unlikely(!selinux_state.initialized))
> +		return -EBUSY;

I don't think this is viable; any arbitrary actions are possible before 
policy is loaded, and a Linux distro can be brought up fully with 
SELinux enabled and no policy loaded.  You'll just need to have a 
default behavior prior to initialization.

> +
> +	isec = selinux_inode(inode);
> +
> +	/*
> +	 * We only get here once per ephemeral inode.  The inode has
> +	 * been initialized via inode_alloc_security but is otherwise
> +	 * untouched, so check that the state is as
> +	 * inode_alloc_security left it.
> +	 */
> +	BUG_ON(isec->initialized != LABEL_INVALID);
> +	BUG_ON(isec->sclass != SECCLASS_FILE);

I think the kernel discourages overuse of BUG_ON/BUG/...

> +
> +#ifdef CONFIG_USERFAULTFD
> +	if (fops == &userfaultfd_fops)
> +		isec->sclass = SECCLASS_UFFD;
> +#endif

Not sure we want or need to introduce a new security class for each user 
of anonymous inodes since the permissions should be the same as for 
file.  Also not sure we want to be testing fops for each such case.  We 
were looking at possibly leveraging the name as a key and using 
security_transition_sid() to generate a distinct SID/context/type for 
the inode via type_transition rules in policy.  We have some WIP along 
those lines.

> +
> +	if (isec->sclass == SECCLASS_FILE) {
> +		printk(KERN_WARNING "refusing to create secure anonymous inode "
> +		       "of unknown type");
> +		return -EOPNOTSUPP;
> +	}
> +	/*
> +	 * Always give secure anonymous inodes the sid of the
> +	 * creating task.
> +	 */
> +
> +	isec->sid = tsec->sid;

This doesn't generalize for other users of anonymous inodes, e.g. the 
/dev/kvm case where we'd rather inherit the SID and class from the 
original /dev/kvm inode itself.
