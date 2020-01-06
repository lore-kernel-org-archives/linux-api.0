From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v6 00/10] proc: modernize proc to support multiple
 private instances
Date: Mon, 6 Jan 2020 18:15:14 +0300
Message-ID: <20200106151514.GA382@avx2>
References: <20191225125151.1950142-1-gladkov.alexey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191225125151.1950142-1-gladkov.alexey@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Security Module <linux-security-module@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

>  	hidepid=	Set /proc/<pid>/ access mode.
>  	gid=		Set the group authorized to learn processes information.
> +	pidonly=	Show only task related subset of procfs.

I'd rather have

	mount -t proc -o set=pid

so that is can be naturally extended to 

	mount -t proc -o set=pid,sysctl,misc

> +static int proc_dir_open(struct inode *inode, struct file *file)
> +{
> +	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
> +
> +	if (proc_fs_pidonly(fs_info) == PROC_PIDONLY_ON)
> +		return -ENOENT;
> +
> +	return 0;
> +}
> +
>  /*
>   * These are the generic /proc directory operations. They
>   * use the in-memory "struct proc_dir_entry" tree to parse
> @@ -338,6 +357,7 @@ static const struct file_operations proc_dir_operations = {
>  	.llseek			= generic_file_llseek,
>  	.read			= generic_read_dir,
>  	.iterate_shared		= proc_readdir,
> +	.open			= proc_dir_open,

This should not be necessary: if lookup and readdir filters work
then ->open can't happen.

>  static int proc_reg_open(struct inode *inode, struct file *file)
>  {
> +	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
>  	struct proc_dir_entry *pde = PDE(inode);
>  	int rv = 0;
>  	typeof_member(struct file_operations, open) open;
>  	typeof_member(struct file_operations, release) release;
>  	struct pde_opener *pdeo;
>  
> +	if (proc_fs_pidonly(fs_info) == PROC_PIDONLY_ON)
> +		return -ENOENT;

Ditto. Can't open what can't be looked up.

> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> +/* definitions for hide_pid field */
> +enum {
> +	HIDEPID_OFF	  = 0,
> +	HIDEPID_NO_ACCESS = 1,
> +	HIDEPID_INVISIBLE = 2,
> +	HIDEPID_NOT_PTRACABLE = 3, /* Limit pids to only ptracable pids */
> +};

These should live in uapi/ as they _are_ user interface to mount().
