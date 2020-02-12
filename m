From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH v2 1/6] Add a new flags-accepting interface for anonymous
 inodes
Date: Wed, 12 Feb 2020 11:37:29 -0500
Message-ID: <88ea16bd-38be-b4f9-dfb3-e0626f5b6aaf@tycho.nsa.gov>
References: <20200211225547.235083-1-dancol@google.com>
 <20200211225547.235083-2-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211225547.235083-2-dancol@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>, timmurray@google.com, nosh@google.com, nnk@google.com, lokeshgidra@google.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, selinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2/11/20 5:55 PM, Daniel Colascione wrote:
> Add functions forwarding from the old names to the new ones so we
> don't need to change any callers.
> 
> Signed-off-by: Daniel Colascione <dancol@google.com>

(please add linux-fsdevel, viro to cc on future versions of this patch 
since this is a VFS change)

> ---
>   fs/anon_inodes.c            | 62 ++++++++++++++++++++++---------------
>   include/linux/anon_inodes.h | 27 +++++++++++++---
>   2 files changed, 59 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> index 89714308c25b..caa36019afca 100644
> --- a/fs/anon_inodes.c
> +++ b/fs/anon_inodes.c
> @@ -56,60 +56,71 @@ static struct file_system_type anon_inode_fs_type = {
>   };
>   
>   /**
> - * anon_inode_getfile - creates a new file instance by hooking it up to an
> - *                      anonymous inode, and a dentry that describe the "class"
> - *                      of the file
> + * anon_inode_getfile2 - creates a new file instance by hooking it up to
> + *                       an anonymous inode, and a dentry that describe
> + *                       the "class" of the file

Not going to bikeshed on names but anon_inode_getfile_flags or _secure 
or something would be more descriptive.

>    *
>    * @name:    [in]    name of the "class" of the new file
>    * @fops:    [in]    file operations for the new file
>    * @priv:    [in]    private data for the new file (will be file's private_data)
> - * @flags:   [in]    flags
> + * @flags:   [in]    flags for the file
> + * @anon_inode_flags: [in] flags for anon_inode*

Do we really envision ever needing more than one new flag here?  If not, 
then making it a bool secure parameter or encoding it as an 
unused/ignored flag bit in the existing flags argument would seem 
preferable.

In some cases, we actually want the "anon inode" to inherit the security 
context of a related inode (e.g. ioctls on /dev/kvm can create anon 
inodes representing VMs, vCPUs, etc and further ioctls are performed on 
those inodes), in which case we may need the caller to pass in the 
related inode as well.

>    *
> - * Creates a new file by hooking it on a single inode. This is useful for files
> + * Creates a new file by hooking it on an unspecified inode. This is useful for files
>    * that do not need to have a full-fledged inode in order to operate correctly.
>    * All the files created with anon_inode_getfile() will share a single inode,
>    * hence saving memory and avoiding code duplication for the file/inode/dentry
>    * setup.  Returns the newly created file* or an error pointer.
> + *
> + * anon_inode_flags must be zero.
>    */
> -struct file *anon_inode_getfile(const char *name,
> -				const struct file_operations *fops,
> -				void *priv, int flags)
> +struct file *anon_inode_getfile2(const char *name,
> +				 const struct file_operations *fops,
> +				 void *priv, int flags, int anon_inode_flags)
>   {
> +	struct inode *inode;
>   	struct file *file;
>   
> -	if (IS_ERR(anon_inode_inode))
> -		return ERR_PTR(-ENODEV);
> -
> -	if (fops->owner && !try_module_get(fops->owner))
> -		return ERR_PTR(-ENOENT);
> +	if (anon_inode_flags)
> +		return ERR_PTR(-EINVAL);

Not sure this is how it is normally done (i.e. one patch to just 
introduce an extended interface but disallow all use of it, then a 
separate patch to introduce the first use).  Would recommend combining; 
otherwise reviewers can't see how it will be used without looking at both.
