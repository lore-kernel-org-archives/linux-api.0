From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V36 27/29] tracefs: Restrict tracefs when the kernel is
 locked down
Date: Wed, 24 Jul 2019 22:23:54 -0400
Message-ID: <20190724222354.7cbd6c6e@oasis.local.home>
References: <20190718194415.108476-1-matthewgarrett@google.com>
        <20190718194415.108476-28-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190718194415.108476-28-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, 18 Jul 2019 12:44:13 -0700
Matthew Garrett <matthewgarrett@google.com> wrote:

> @@ -387,6 +412,7 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
>  				   struct dentry *parent, void *data,
>  				   const struct file_operations *fops)
>  {
> +	struct file_operations *proxy_fops;
>  	struct dentry *dentry;
>  	struct inode *inode;
>  
> @@ -402,8 +428,18 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
>  	if (unlikely(!inode))
>  		return failed_creating(dentry);
>  
> +	proxy_fops = kzalloc(sizeof(struct file_operations), GFP_KERNEL);
> +	if (!proxy_fops)

I believe we need "iput(inode);" here. Or move the allocation before
the inode allocation and free it on inode failure.

-- Steve

> +		return failed_creating(dentry);
> +
> +	if (!fops)
> +		fops = &tracefs_file_operations;
> +
> +	dentry->d_fsdata = (void *)fops;
> +	memcpy(proxy_fops, fops, sizeof(*proxy_fops));
> +	proxy_fops->open = default_open_file;
>  	inode->i_mode = mode;
> -	inode->i_fop = fops ? fops : &tracefs_file_operations;
> +	inode->i_fop = proxy_fops;
>  	inode->i_private = data;
>  	d_instantiate(dentry, inode);
>  	fsnotify_create(dentry->d_parent->d_inode, dentry);
