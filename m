From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [CFT][PATCH 08/10] sysfs: Add support for permanently empty
 directories.
Date: Thu, 14 May 2015 13:31:31 -0700
Message-ID: <20150514203131.GB16416@kroah.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
 <87fv6zhxkp.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87fv6zhxkp.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 14, 2015 at 12:35:02PM -0500, Eric W. Biederman wrote:
> 
> Add two functions sysfs_create_empty_dir and sysfs_remove_empty_dir
> that hang a permanently empty directory off of a kobject or remove
> a permanently emptpy directory hanging from a kobject.  Export
> these new functions so modular filesystems can use them.
> 
> As all permanently empty directories are, are names and used
> for mouting other filesystems this seems like the right abstraction.

That sentence doesn't make much sense, cut and paste?

> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> ---
>  fs/sysfs/dir.c        | 34 ++++++++++++++++++++++++++++++++++
>  include/linux/sysfs.h | 16 ++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 0b45ff42f374..8244741474d7 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -121,3 +121,37 @@ int sysfs_move_dir_ns(struct kobject *kobj, struct kobject *new_parent_kobj,
>  
>  	return kernfs_rename_ns(kn, new_parent, kn->name, new_ns);
>  }
> +
> +/**
> + * sysfs_create_empty_dir - create an always empty directory
> + * @parent_kobj:  kobject that will contain this always empty directory
> + * @name: The name of the always empty directory to add
> + */
> +int sysfs_create_empty_dir(struct kobject *parent_kobj, const char *name)

As this really is just a mount point, how about we be explicit with
this and call the function:
	sysfs_create_mount_point()
	sysfs_remove_mount_point()
That makes more sense in the long run, otherwise if you just want to
create an empty directory in sysfs, you can do so without making an
"empty" kobject and some people might do that accidentally in the
future.  This makes it more obvious as to what is going on.

thanks,

greg k-h
