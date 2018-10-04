From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path resolution
Date: Thu, 4 Oct 2018 20:26:20 +0200
Message-ID: <CAG48ez2u--Wac7d9n3idC92Pd-M40QzYtR6FKR8PAYr=VQHUBQ@mail.gmail.com>
References: <20180929103453.12025-1-cyphar@cyphar.com> <20180929131534.24472-1-cyphar@cyphar.com>
 <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com> <20181004162611.vdlujbdguvagalpt@ryuk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181004162611.vdlujbdguvagalpt@ryuk>
Sender: linux-kernel-owner@vger.kernel.org
To: cyphar@cyphar.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 4, 2018 at 6:26 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2018-09-29, Jann Horn <jannh@google.com> wrote:
> > You attempt to open "C/../../etc/passwd" under the root "/A/B".
> > Something else concurrently moves /A/B/C to /A/C. This can result in
> > the following:
> >
> > 1. You start the path walk and reach /A/B/C.
> > 2. The other process moves /A/B/C to /A/C. Your path walk is now at /A/C.
> > 3. Your path walk follows the first ".." up into /A. This is outside
> > the process root, but you never actually encountered the process root,
> > so you don't notice.
> > 4. Your path walk follows the second ".." up to /. Again, this is
> > outside the process root, but you don't notice.
> > 5. Your path walk walks down to /etc/passwd, and the open completes
> > successfully. You now have an fd pointing outside your chroot.
>
> I've been playing with this and I have the following patch, which
> according to my testing protects against attacks where ".." skips over
> nd->root. It abuses __d_path to figure out if nd->path can be resolved
> from nd->root (obviously a proper version of this patch would refactor
> __d_path so it could be used like this -- and would not return
> -EMULTIHOP).
>
> I've also attached my reproducer. With it, I was seeing fairly constant
> breakouts before this patch and after it I didn't see a single breakout
> after running it overnight. Obviously this is not conclusive, but I'm
> hoping that it can show what my idea for protecting against ".." was.
>
> Does this patch make sense? Or is there something wrong with it that I'm
> not seeing?
>
> --8<-------------------------------------------------------------------
>
> There is a fairly easy-to-exploit race condition with chroot(2) (and
> thus by extension AT_THIS_ROOT and AT_BENEATH) where a rename(2) of a
> path can be used to "skip over" nd->root and thus escape to the
> filesystem above nd->root.
>
>   thread1 [attacker]:
>     for (;;)
>       renameat2(AT_FDCWD, "/a/b/c", AT_FDCWD, "/a/d", RENAME_EXCHANGE);
>   thread2 [victim]:
>     for (;;)
>       openat(dirb, "b/c/../../etc/shadow", O_THISROOT);
>
> With fairly significant regularity, thread2 will resolve to
> "/etc/shadow" rather than "/a/b/etc/shadow". With this patch, such cases
> will be detected during ".." resolution (which is the weak point of
> chroot(2) -- since walking *into* a subdirectory tautologically cannot
> result in you walking *outside* nd->root).
>
> The use of __d_path here might seem suspect, however we don't mind if a
> path is moved from within the chroot to outside the chroot and we
> incorrectly decide it is safe (because at that point we are still within
> the set of files which were accessible at the beginning of resolution).
> However, we can fail resolution on the next path component if it remains
> outside of the root. A path which has always been outside nd->root
> during resolution will never be resolveable from nd->root and thus will
> always be blocked.
>
> DO NOT MERGE: Currently this code returns -EMULTIHOP in this case,
>               purely as a debugging measure (so that you can see that
>               the protection actually does something). Obviously in the
>               proper patch this will return -EXDEV.
>
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> ---
>  fs/namei.c | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 6f995e6de6b1..c8349693d47b 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -53,8 +53,8 @@
>   * The new code replaces the old recursive symlink resolution with
>   * an iterative one (in case of non-nested symlink chains).  It does
>   * this with calls to <fs>_follow_link().
> - * As a side effect, dir_namei(), _namei() and follow_link() are now
> - * replaced with a single function lookup_dentry() that can handle all
> + * As a side effect, dir_namei(), _namei() and follow_link() are now
> + * replaced with a single function lookup_dentry() that can handle all
>   * the special cases of the former code.
>   *
>   * With the new dcache, the pathname is stored at each inode, at least as
> @@ -1375,6 +1375,20 @@ static int follow_dotdot_rcu(struct nameidata *nd)
>                                 return -EXDEV;
>                         break;
>                 }
> +               if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT))) {
> +                       char *pathbuf, *pathptr;
> +
> +                       pathbuf = kmalloc(PATH_MAX, GFP_ATOMIC);
> +                       if (!pathbuf)
> +                               return -ECHILD;
> +                       pathptr = __d_path(&nd->path, &nd->root, pathbuf, PATH_MAX);
> +                       kfree(pathbuf);
> +                       if (IS_ERR_OR_NULL(pathptr)) {
> +                               if (!pathptr)
> +                                       pathptr = ERR_PTR(-EMULTIHOP);
> +                               return PTR_ERR(pathptr);
> +                       }
> +               }

One somewhat problematic thing about this approach is that if someone
tries to lookup
"a/a/a/a/a/a/a/a/a/a/[...]/../../../../../../../../../.." for some
reason, you'll have quadratic runtime: For each "..", you'll have to
walk up to the root.
