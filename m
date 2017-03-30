From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH RFC 1/4] proc: add proc_fs_info struct to store proc options
Date: Thu, 30 Mar 2017 12:10:44 -0700
Message-ID: <CALCETrUG2Smb-+SWKphnB_oMFakZn9AuJDa7WeahnN9hBoENTQ@mail.gmail.com>
References: <1490887379-25880-1-git-send-email-tixxdz@gmail.com> <1490887379-25880-2-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490887379-25880-2-git-send-email-tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 8:22 AM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> This is a preparation patch that adds a proc_fs_info to be able to store
> different procfs options. Right now some mount options are stored inside
> the pid namespace which make multiple proc share the same mount options.
> This patch will help also to fix this.
>
> Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

>  static struct dentry *proc_mount(struct file_system_type *fs_type,
>         int flags, const char *dev_name, void *data)
>  {
> +       int error;
> +       struct super_block *sb;
>         struct pid_namespace *ns;
> +       struct proc_fs_info *fs_info;
> +
> +       if (!(flags & MS_KERNMOUNT) && !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
> +               return ERR_PTR(-EPERM);

Why is this check needed?

> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 2d2bf59..e1cb9c3 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -6,11 +6,27 @@
>
>  #include <linux/types.h>
>  #include <linux/fs.h>
> +#include <linux/refcount.h>
> +
> +enum {
> +       PROC_FS_V1      = 1,
> +       PROC_FS_V2      = 2,
> +};
> +
> +struct proc_fs_info {
> +       refcount_t users;
> +       struct pid_namespace *pid_ns;
> +       kgid_t pid_gid;
> +       int hide_pid;
> +       int version;
> +};

What is version?

Should this patch have just users and pid_ns and move the other stuff
to patch 2?
