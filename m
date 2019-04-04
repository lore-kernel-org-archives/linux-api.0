From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V32 27/27] tracefs: Restrict tracefs when the kernel is
 locked down
Date: Thu, 4 Apr 2019 09:39:07 -0400
Message-ID: <20190404093907.153f52a8@gandalf.local.home>
References: <20190404003249.14356-1-matthewgarrett@google.com>
        <20190404003249.14356-28-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190404003249.14356-28-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-api@vger.kernel.org, luto@kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On Wed,  3 Apr 2019 17:32:49 -0700
Matthew Garrett <matthewgarrett@google.com> wrote:


> +static void tracefs_destroy_inode(struct inode *inode)
> +{
> +	if S_ISREG(inode->i_mode)

Can we please put parenthesis around the condition. I know that the
macro has them, but no other place in the kernel plays such a trick.

	if (S_ISREG(inode->i_mode))

Other than that, the rest looks good.

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

> +		kfree(inode->i_fop);
> +}
> +
>  static int tracefs_remount(struct super_block *sb, int *flags, char *data)
>  {
>  	int err;
> @@ -260,6 +288,7 @@ static int tracefs_show_options(struct seq_file *m, struct dentry *root)
>  
>  static const struct super_operations tracefs_super_operations = {
>  	.statfs		= simple_statfs,
> +	.destroy_inode  = tracefs_destroy_inode,
>  	.remount_fs	= tracefs_remount,
>  	.show_options	= tracefs_show_options,
>  };
> @@ -393,6 +422,7 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
>  {
>  	struct dentry *dentry;
>  	struct inode *inode;
> +	struct file_operations *proxy_fops;
>  
>  	if (!(mode & S_IFMT))
>  		mode |= S_IFREG;
> @@ -406,8 +436,16 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
>  	if (unlikely(!inode))
>  		return failed_creating(dentry);
>  
> +	proxy_fops = kzalloc(sizeof(struct file_operations), GFP_KERNEL);
> +	if (!proxy_fops)
> +		return failed_creating(dentry);
> +
> +	dentry->d_fsdata = fops ? (void *)fops :
> +		(void *)&tracefs_file_operations;
> +	memcpy(proxy_fops, dentry->d_fsdata, sizeof(struct file_operations));
> +	proxy_fops->open = default_open_file;
>  	inode->i_mode = mode;
> -	inode->i_fop = fops ? fops : &tracefs_file_operations;
> +	inode->i_fop = proxy_fops;
>  	inode->i_private = data;
>  	d_instantiate(dentry, inode);
>  	fsnotify_create(dentry->d_parent->d_inode, dentry);
