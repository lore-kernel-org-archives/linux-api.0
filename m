From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Thu, 23 Mar 2017 17:05:07 +0100
Message-ID: <20170323160507.GA23135@redhat.com>
References: <20170312021257.GP29622@ZenIV.linux.org.uk> <20170320125855.GG4554@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170320125855.GG4554@comp-core-i7-2640m-0182e6>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Again, I can't really review this, I know nothing about vfs, but since
nobody else replied...

On 03/20, Alexey Gladkov wrote:
>
> @@ -97,7 +169,23 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
>  		ns = task_active_pid_ns(current);
>  	}
>
> -	return mount_ns(fs_type, flags, data, ns, ns->user_ns, proc_fill_super);
> +	root = mount_ns(fs_type, flags, data, ns, ns->user_ns, proc_fill_super);
> +
> +	if (!IS_ERR(root)) {
> +		if (!proc_fill_options(data, &opts))
> +			return ERR_PTR(-EINVAL);

So we have to call proc_fill_options() twice, not good... Yes, I understand
why, but perhaps we factor it out somehow, we can pack options + pid_ns into
sb->s_fs_info. Nevermind, this is minor.

> +		if (opts.pid_only) {
> +			int ret;
> +
> +			if (!ns->pidfs && (ret = fill_pidfs_root(root->d_sb)))
> +				return ERR_PTR(ret);
> +
> +			root = ns->pidfs;

Afaics this lacks dget(ns->pidfs) which should pair with dput(mnt.mnt_root)
in cleanup_mnt(). IIUC otherwise ns->pidfs can go away after umount, OTOH,
if we return ns->pidfs then dget(sb->s_root) in mount_ns() is not balanced.
But this all is fixeable.

So with this change "mount -opidonly" creates another IS_ROOT() dentry which
is not equal to sb->s_root. I simply do not know if this is technically
correct or not... but, say, the "Only bind mounts can have disconnected paths"
comment in path_connected() makes me worry ;)

And this obviously means that /path-to-pidonly-mnt/ won't share dentries with
the normal /proc mount. Not really good imo even if not really wrong... Lets
look at proc_flush_task(). The exiting task will flush its $pid dentries in
/proc/ but not in /path-to-pidonly-mnt/ iiuc. Again, not really a bug, but
still...

Oleg.
