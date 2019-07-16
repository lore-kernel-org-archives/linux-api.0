From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V35 27/29] tracefs: Restrict tracefs when the kernel is
 locked down
Date: Tue, 16 Jul 2019 19:14:39 -0400
Message-ID: <20190716191439.59a1ac32@gandalf.local.home>
References: <20190715195946.223443-1-matthewgarrett@google.com>
        <20190715195946.223443-28-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190715195946.223443-28-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, 15 Jul 2019 12:59:44 -0700
Matthew Garrett <matthewgarrett@google.com> wrote:

> Tracefs may release more information about the kernel than desirable, so
> restrict it when the kernel is locked down in confidentiality mode by
> preventing open().
> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
> 

> @@ -389,6 +414,7 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
>  {
>  	struct dentry *dentry;
>  	struct inode *inode;
> +	struct file_operations *proxy_fops;

Small nit, but please add this as the first declaration, to keep the
"upside-down x-mas tree" look. I know some of the other functions in
this file don't follow that (which should be cleaned up some day), but
I'd like to avoid adding more that breaks the aesthetic of the code.

>  
>  	if (!(mode & S_IFMT))
>  		mode |= S_IFREG;
> @@ -402,8 +428,18 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
>  	if (unlikely(!inode))
>  		return failed_creating(dentry);
>  
> +	proxy_fops = kzalloc(sizeof(struct file_operations), GFP_KERNEL);
> +	if (!proxy_fops)
> +		return failed_creating(dentry);
> +
> +	if (fops)

I think you meant "if (!fops)".

-- Steve

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
