From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 3/3] namei: aggressively check for nd->root escape on
 ".." resolution
Date: Tue, 9 Oct 2018 17:19:06 +0200
Message-ID: <CAG48ez3Ae5b20g2UquekfBNaUw1tLt4nWy2pYm-LNRMbDVpHfA@mail.gmail.com>
References: <20181009070230.12884-1-cyphar@cyphar.com> <20181009070230.12884-4-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009070230.12884-4-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cyphar@cyphar.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 9, 2018 at 9:03 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
> This patch allows for AT_BENEATH and AT_THIS_ROOT to safely permit ".."
> resolution (in the case of AT_BENEATH the resolution will still fail if
> ".." resolution would resolve a path outside of the root -- while
> AT_THIS_ROOT will chroot(2)-style scope it). "proclink" jumps are still
> disallowed entirely because now they could result in inconsistent
> behaviour if resolution encounters a subsequent "..".
>
> The need for this patch is explained by observing there is a fairly
> easy-to-exploit race condition with chroot(2) (and thus by extension
> AT_THIS_ROOT and AT_BENEATH) where a rename(2) of a path can be used to
> "skip over" nd->root and thus escape to the filesystem above nd->root.
>
>   thread1 [attacker]:
>     for (;;)
>       renameat2(AT_FDCWD, "/a/b/c", AT_FDCWD, "/a/d", RENAME_EXCHANGE);
>   thread2 [victim]:
>     for (;;)
>       openat(dirb, "b/c/../../etc/shadow", O_THISROOT);
>
> With fairly significant regularity, thread2 will resolve to
> "/etc/shadow" rather than "/a/b/etc/shadow". There is also a similar
> (though somewhat more privileged) attack using MS_MOVE.
>
> With this patch, such cases will be detected *during* ".." resolution
> (which is the weak point of chroot(2) -- since walking *into* a
> subdirectory tautologically cannot result in you walking *outside*
> nd->root -- except through a bind-mount or "proclink"). By detecting
> this at ".." resolution (rather than checking only at the end of the
> entire resolution) we can both correct escapes by jumping back to the
> root (in the case of AT_THIS_ROOT), as well as avoid revealing to
> attackers the structure of the filesystem outside of the root (through
> timing attacks for instance).
>
> In order to avoid a quadratic lookup with each ".." entry, we only
> activate the slow path if a write through &rename_lock or &mount_lock
> have occurred during path resolution (&rename_lock and &mount_lock are
> re-taken to further optimise the lookup). Since the primary attack being
> protected against is MS_MOVE or rename(2), not doing additional checks
> unless a mount or rename have occurred avoids making the common case
> slow.
>
> The use of __d_path here might seem suspect, but on further inspection
> of the most important race (a path was *inside* the root but is now
> *outside*), there appears to be no attack potential. If __d_path occurs
> before the rename, then the path will be resolved but since the path was
> originally inside the root there is no escape. Subsequent ".." jumps are
> guaranteed to check __d_path reachable (by construction, &rename_lock or
> &mount_lock must have been taken after __d_path returned),

"after"? Don't you mean "before"? Otherwise I don't understand what
you're saying here.

> and thus will
> not be able to escape from the previously-inside-root path. Walking down
> is still safe since the entire subtree was moved (either by rename(2) or
> MS_MOVE) and because (as discussed above) walking down is safe.
>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Jann Horn <jannh@google.com>
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> ---
>  fs/namei.c | 79 +++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 61 insertions(+), 18 deletions(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index b31aef27df22..12cd8d8987ea 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
[...]
> +static inline int nd_alloc_dpathbuf(struct nameidata *nd)
> +{
> +       if (unlikely(!nd->dpathbuf)) {
> +               if (nd->flags & LOOKUP_RCU) {
> +                       nd->dpathbuf = kmalloc(PATH_MAX, GFP_ATOMIC);
> +                       if (unlikely(!nd->dpathbuf))
> +                               return -ECHILD;
> +               } else {
> +                       nd->dpathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
> +                       if (unlikely(!nd->dpathbuf))
> +                               return -ENOMEM;
> +               }
> +       }
> +       return 0;
> +}

Note that a fixed-size path buffer means that if the path is very
long, e.g. because you followed long symlinks on the way down, this
can cause lookup failures.

>  static void drop_links(struct nameidata *nd)
>  {
>         int i = nd->depth;
> @@ -1738,18 +1756,40 @@ static inline int may_lookup(struct nameidata *nd)
>  static inline int handle_dots(struct nameidata *nd, int type)
>  {
>         if (type == LAST_DOTDOT) {
> -               /*
> -                * AT_BENEATH resolving ".." is not currently safe -- races can cause
> -                * our parent to have moved outside of the root and us to skip over it.
> -                */
> -               if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT)))
> -                       return -EXDEV;
> +               int error = 0;
> +
>                 if (!nd->root.mnt)
>                         set_root(nd);
> -               if (nd->flags & LOOKUP_RCU) {
> -                       return follow_dotdot_rcu(nd);
> -               } else
> -                       return follow_dotdot(nd);
> +               if (nd->flags & LOOKUP_RCU)
> +                       error = follow_dotdot_rcu(nd);
> +               else
> +                       error = follow_dotdot(nd);
> +               if (error)
> +                       return error;
> +
> +               if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT))) {
> +                       char *pathptr;
> +                       bool m_retry = read_seqretry(&mount_lock, nd->m_seq);
> +                       bool r_retry = read_seqretry(&rename_lock, nd->r_seq);
> +
> +                       /* Racing rename(2) or MS_MOVE? */
> +                       if (likely(!m_retry && !r_retry))
> +                               return 0;
> +                       if (m_retry && !(nd->flags & LOOKUP_RCU))
> +                               nd->m_seq = read_seqbegin(&mount_lock);
> +                       if (r_retry)
> +                               nd->r_seq = read_seqbegin(&rename_lock);
> +
> +                       error = nd_alloc_dpathbuf(nd);
> +                       if (error)
> +                               return error;
> +                       pathptr = __d_path(&nd->path, &nd->root, nd->dpathbuf, PATH_MAX);
> +                       if (unlikely(!pathptr))
> +                               /* Breakout -- go back to root! */
> +                               return nd_jump_root(nd);

I find the semantics of this check odd - especially in the
LOOKUP_BENEATH case, but also in the LOOKUP_CHROOT case. Wouldn't it
make more sense to just throw an error here? Making /.. go back to the
root is one thing, but making ".." from anything that has escaped from
the root go back to the root seems less logical to me.

Imagine, for example:

Thread A (a webserver or whatever) looks up
"example.org/images/foo/../bar.png" under "/var/www" with
LOOKUP_BENEATH.
Thread B concurrently moves "/var/www/example.org/images" to
"/var/backup/example.org/images".
Now thread A can accidentally resolve its path to "/var/www/bar.png"
if the race happens the wrong way?

> +                       if (unlikely(IS_ERR(pathptr)))
> +                               return PTR_ERR(pathptr);
> +               }
>         }
>         return 0;
>  }
