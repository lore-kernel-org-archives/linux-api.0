From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [CFT][PATCH] userns: Avoid problems with negative groups
Date: Thu, 27 Nov 2014 12:52:16 -0800
Message-ID: <CALCETrUuWDq2akKfb50AiPHeDDWzPW7ijz1QwnuNiskyZbBEfA@mail.gmail.com>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <546A3942.5040906@schaufler-ca.com> <CALCETrWy-3C1on3+2wE9aqcChBUCUY0i_4AL_Om8CSZ5QB18sQ@mail.gmail.com>
 <CALCETrVn4gVXp7F=5h-bkN5VWuRMG9BoxgeQfKhX4+ZXxGE=wQ@mail.gmail.com>
 <546A43CE.2030706@schaufler-ca.com> <87lhmwwpey.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87lhmwwpey.fsf_-_-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 27, 2014 at 8:59 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>
> Classic unix permission checks have an interesting feature.  The group
> permissions for a file can be set to less than the other permissions
> on a file.  Occassionally this is used deliberately to give a certain
> group of users fewer permissions than the default.
>
> Overlooking negative groups has resulted in the permission checks for
> setting up a group mapping in a user namespace to be too lax.  Tighten
> the permission checks in new_idmap_permitted to ensure that mapping
> uids and gids into user namespaces without privilege will not result
> in new combinations of credentials being available to the users.
>
> When setting mappings without privilege only the creator of the user
> namespace is interesting as all other users that have CAP_SETUID over
> the user namespace will also have CAP_SETUID over the user namespaces
> parent.  So the scope of the unprivileged check is reduced to just
> the case where cred->euid is the namespace creator.
>
> For setting a uid mapping without privilege only euid is considered as
> setresuid can set uid, suid and fsuid from euid without privielege
> making any combination of uids possible with user namespaces already
> possible without them.
>
> For setting a gid mapping without privilege only egid on a credential
> without supplementary groups is condsidered, as setresgid can set gid,
> sgid and fsgid from egid without privilege.  The requirement for no
> supplementary groups is because CAP_SETUID in a user namespace allows
> supplementary groups to be cleared, which unfortunately means allowing
> a credential with supplementary groups would allow new combinations
> of credentials to exist, and thus would allow defeating negative
> groups without permission.
>
> This change should break userspace by the minimal amount needed
> to fix this issue.
>
> This should fix CVE-2014-8989.

I think this is both unnecessarily restrictive and that it doesn't fix
the bug.  For example, I can exploit CVE-2014-8989 without ever
writing a uid map or a gid map.

IIUC, the only real issue is that user namespaces allow groups to be
dropped using setgroups that wouldn't otherwise be dropped.  Can we
get away with adding a per-user-ns flag that determines whether
setgroups can be used?

setgroups would be unusable until the gid_map has been written and
then it would become usable if and only if the parent userns could use
setgroups and the opener of gid_map was privileged.

If we wanted to allow finer-grained control, we could allow writing
control lines like:

options +setgroups

or

options -setgroups

in gid_map, or we could add user_ns_flags that can only be written
once and only before either uid_map or gid_map is written.

--Andy

>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> ---
>
> If people can test and review this change and verify  this and verify it
> doesn't break anything I can't help breaking I will appreciate it.
>
>  kernel/user_namespace.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index aa312b0dc3ec..b338c42d04fd 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -812,16 +812,24 @@ static bool new_idmap_permitted(const struct file *file,
>                                 struct user_namespace *ns, int cap_setid,
>                                 struct uid_gid_map *new_map)
>  {
> -       /* Allow mapping to your own filesystem ids */
> -       if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
> +       const struct cred *cred = file->f_cred;
> +
> +       /* Allow mapping an id without CAP_SETUID and CAP_SETGID when
> +        * allowing the root of the user namespace CAP_SETUID or
> +        * CAP_SETGID restricted to just that id will not change the
> +        * set of credentials available that user.
> +        */
> +       if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1) &&
> +           uid_eq(ns->owner, cred->euid)) {
>                 u32 id = new_map->extent[0].lower_first;
>                 if (cap_setid == CAP_SETUID) {
>                         kuid_t uid = make_kuid(ns->parent, id);
> -                       if (uid_eq(uid, file->f_cred->fsuid))
> +                       if (uid_eq(uid, cred->euid))
>                                 return true;
>                 } else if (cap_setid == CAP_SETGID) {
>                         kgid_t gid = make_kgid(ns->parent, id);
> -                       if (gid_eq(gid, file->f_cred->fsgid))
> +                       if (gid_eq(gid, cred->egid) &&
> +                           (cred->group_info->ngroups == 0))
>                                 return true;
>                 }
>         }
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
