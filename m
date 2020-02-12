From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 08/11] proc: instantiate only pids that we can ptrace
 on 'hidepid=4' mount option
Date: Wed, 12 Feb 2020 15:34:01 +0100
Message-ID: <20200212143401.vjiqsdmf55e7wsdc@comp-core-i7-2640m-0182e6>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
 <20200210150519.538333-9-gladkov.alexey@gmail.com>
 <aBJUaM4BeffJa3vj1p1rUZRN60LVv39CTN9ETLC-swk2b6CvAW8BbP6QbxK5zBGwSYOEiRgjE-auqdRo-pYXxhwuJ_h5rbZ9uyeFqLcLSJQ=@protonmail.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <aBJUaM4BeffJa3vj1p1rUZRN60LVv39CTN9ETLC-swk2b6CvAW8BbP6QbxK5zBGwSYOEiRgjE-auqdRo-pYXxhwuJ_h5rbZ9uyeFqLcLSJQ=@protonmail.ch>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jordan Glover <Golden_Miller83-g/b1ySJe57IkP3XJZ0H8fw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Security Module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Dmitry V . Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J . Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 10, 2020 at 04:29:31PM +0000, Jordan Glover wrote:
> On Monday, February 10, 2020 3:05 PM, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > If "hidepid=4" mount option is set then do not instantiate pids that
> > we can not ptrace. "hidepid=4" means that procfs should only contain
> > pids that the caller can ptrace.
> >
> > Cc: Kees Cook keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
> > Cc: Andy Lutomirski luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> > Signed-off-by: Djalal Harouni tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> > Signed-off-by: Alexey Gladkov gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> >
> > fs/proc/base.c | 15 +++++++++++++++
> > fs/proc/root.c | 14 +++++++++++---
> > include/linux/proc_fs.h | 1 +
> > 3 files changed, 27 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index 24b7c620ded3..49937d54e745 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -699,6 +699,14 @@ static bool has_pid_permissions(struct proc_fs_info *fs_info,
> > struct task_struct *task,
> > int hide_pid_min)
> > {
> >
> > -   /*
> > -   -   If 'hidpid' mount option is set force a ptrace check,
> > -   -   we indicate that we are using a filesystem syscall
> > -   -   by passing PTRACE_MODE_READ_FSCREDS
> > -   */
> > -   if (proc_fs_hide_pid(fs_info) == HIDEPID_NOT_PTRACABLE)
> > -         return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
> >
> >
> > -   if (proc_fs_hide_pid(fs_info) < hide_pid_min)
> >     return true;
> >     if (in_group_p(proc_fs_pid_gid(fs_info)))
> >     @@ -3271,7 +3279,14 @@ struct dentry *proc_pid_lookup(struct dentry *dentry, unsigned int flags)
> >     if (!task)
> >     goto out;
> >
> > -   /* Limit procfs to only ptracable tasks */
> > -   if (proc_fs_hide_pid(fs_info) == HIDEPID_NOT_PTRACABLE) {
> > -         if (!has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS))
> >
> >
> > -         	goto out_put_task;
> >
> >
> > -   }
> > -   result = proc_pid_instantiate(dentry, task, NULL);
> >     +out_put_task:
> >     put_task_struct(task);
> >     out:
> >     return result;
> >     diff --git a/fs/proc/root.c b/fs/proc/root.c
> >     index e2bb015da1a8..5e27bb31f125 100644
> >     --- a/fs/proc/root.c
> >     +++ b/fs/proc/root.c
> >     @@ -52,6 +52,15 @@ static const struct fs_parameter_description proc_fs_parameters = {
> >     .specs = proc_param_specs,
> >     };
> >
> >     +static inline int
> >     +valid_hidepid(unsigned int value)
> >     +{
> >
> > -   return (value == HIDEPID_OFF ||
> > -         value == HIDEPID_NO_ACCESS ||
> >
> >
> > -         value == HIDEPID_INVISIBLE ||
> >
> >
> > -         value == HIDEPID_NOT_PTRACABLE);
> >
> >
> >
> > +}
> > +
> > static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
> > {
> > struct proc_fs_context *ctx = fc->fs_private;
> > @@ -68,10 +77,9 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
> > break;
> >
> > case Opt_hidepid:
> >
> > -         if (!valid_hidepid(result.uint_32))
> >
> >
> > -         	return invalf(fc, "proc: unknown value of hidepid.\\n");
> >           ctx->hidepid = result.uint_32;
> >
> >
> >
> > -         if (ctx->hidepid < HIDEPID_OFF ||
> >
> >
> > -             ctx->hidepid > HIDEPID_INVISIBLE)
> >
> >
> > -         	return invalf(fc, "proc: hidepid value must be between 0 and 2.\\n");
> >           break;
> >
> >
> >
> > default:
> > diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> > index f307940f8311..6822548405a7 100644
> > --- a/include/linux/proc_fs.h
> > +++ b/include/linux/proc_fs.h
> > @@ -17,6 +17,7 @@ enum {
> > HIDEPID_OFF = 0,
> > HIDEPID_NO_ACCESS = 1,
> > HIDEPID_INVISIBLE = 2,
> >
> > -   HIDEPID_NOT_PTRACABLE = 4, /* Limit pids to only ptracable pids */
> 
> Is there a reason new option is "4" instead of "3"? The order 1..2..4 may be
> confusing for people.

This is just mask. For now hidepid values are mutually exclusive, but
since it moved to uapi, I thought it would be good if there was an
opportunity to combine values.

-- 
Rgrds, legion
