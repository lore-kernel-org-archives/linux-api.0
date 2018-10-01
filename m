From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path
 resolution
Date: Mon, 1 Oct 2018 16:00:09 +0200
Message-ID: <20181001140008.q6jupeylvfld2zpy@brauner.io>
References: <20180929103453.12025-1-cyphar@cyphar.com>
 <20180929131534.24472-1-cyphar@cyphar.com>
 <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: cyphar@cyphar.com, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Sep 29, 2018 at 06:35:17PM +0200, Jann Horn wrote:
> +cc linux-api; please keep them in CC for future versions of the patch
> 
> On Sat, Sep 29, 2018 at 4:29 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > The primary motivation for the need for this flag is container runtimes
> > which have to interact with malicious root filesystems in the host
> > namespaces. One of the first requirements for a container runtime to be
> > secure against a malicious rootfs is that they correctly scope symlinks
> > (that is, they should be scoped as though they are chroot(2)ed into the
> > container's rootfs) and ".."-style paths. The already-existing AT_XDEV
> > and AT_NO_PROCLINKS help defend against other potential attacks in a
> > malicious rootfs scenario.
> 
> So, I really like the concept for patch 1 of this series (but haven't
> read the code yet); but I dislike this patch because of its footgun
> potential.
> 
> If this patch landed as-is, the manpage would need some big warning
> labels. chroot() basically provides no security guarantees at all; and
> yes, that includes that if you do `chroot(...); chdir("/");
> open(attacker_controlled_path, ...);`, you can potentially end up
> opening a file outside the chroot. See
> https://github.com/QubesOS/qubes-secpack/blob/master/QSBs/qsb-014-2015.txt
> for an example, where Qubes OS did pretty much that, and ended up with
> a potentially exploitable security bug because of that, where one VM,
> while performing a file transfer into another VM, could write outside
> of the transfer target directory.
> The problem is what happens if a folder you are walking through is
> concurrently moved out of the chroot. Consider the following scenario:
> 
> You attempt to open "C/../../etc/passwd" under the root "/A/B".
> Something else concurrently moves /A/B/C to /A/C. This can result in
> the following:
> 
> 1. You start the path walk and reach /A/B/C.
> 2. The other process moves /A/B/C to /A/C. Your path walk is now at /A/C.
> 3. Your path walk follows the first ".." up into /A. This is outside
> the process root, but you never actually encountered the process root,
> so you don't notice.
> 4. Your path walk follows the second ".." up to /. Again, this is
> outside the process root, but you don't notice.
> 5. Your path walk walks down to /etc/passwd, and the open completes
> successfully. You now have an fd pointing outside your chroot.
> 
> If the root of your walk is below an attacker-controlled directory,
> this of course means that you lose instantly. If you point the root of
> the walk at a directory out of which a process in the container
> wouldn't be able to move the file, you're probably kinda mostly fine -
> as long as you know, for certain, that nothing else on the system
> would ever do that. But I still wouldn't feel good about that.
> 
> (Yes, this means that if you run an SFTP server with OpenSSH's
> ChrootDirectory directive, you have to be very careful about these
> things.)
> 
> I believe that the only way to robustly use this would be to point the
> dirfd at a mount point, such that you know that being moved out of the
> chroot is impossible because the mount point limits movement of
> directories under it. (Well, technically, it doesn't, but it ensures
> that if a directory does dangerously move away, the syscall fails.) It
> might make sense to hardcode this constraint in the implementation of
> AT_THIS_ROOT, to keep people from shooting themselves in the foot.

I'm very much in favor of dropping AT_THIS_ROOT from this patch series
at least for now and only land the first patch. The first patch is
something that we really want and that it seems we can find a good
design for.
If AT_THIS_ROOT is a feature that still makes sense we can revisit it.

> 
> > Currently most container runtimes try to do this resolution in
> > userspace[1], causing many potential race conditions. In addition, the
> > "obvious" alternative (actually performing a {ch,pivot_}root(2))
> > requires a fork+exec which is *very* costly if necessary for every
> > filesystem operation involving a container.
> 
> Wait. fork() I understand, but why exec? And actually, you don't need
> a full fork() either, clone() lets you do this with some process parts
> shared. And then you also shouldn't need to use SCM_RIGHTS, just keep
> the file descriptor table shared. And why chroot()/pivot_root(),
> wouldn't you want to use setns()? I think something like this should
> work (except that you should add some error handling - omitted here
> because I'm lazy), assuming that the container runtime does NOT have
> CAP_SYS_ADMIN in the init namespace (otherwise it's easier). Of
> course, this is entirely untested, and probably won't compile because
> I screwed something up. :P But you should get the idea...
> 
> // Ensure that we are non-dumpable. Together with
> // commit bfedb589252c, this ensures that container root
> // can't trace our child once it enters the container.
> // My patch
> // https://lore.kernel.org/lkml/1451098351-8917-1-git-send-email-jann@thejh.net/
> // would make this unnecessary, but that patch didn't
> // land because Eric nacked it (for political reasons,
> // because people incorrectly claimed that this was a
> // security fix):
> // https://lore.kernel.org/lkml/8760z7fope.fsf@x220.int.ebiederm.org/
> // Note that dumpability is per-mm, not per-process,
> // so this hack has the unfortunate side effect of preventing
> // unprivileged debugging of the container runtime.
> // Oh well.
> prctl(PR_SET_DUMPABLE, SUID_DUMP_DISABLE);
> // Inform gcc that this particular syscall will effectively
> // return twice, just like vfork() or setjmp().
> __attribute__((returns_twice)) long syscall_(long sysno, ...) = (void*)syscall;
> int result_fd = -1;
> // CLONE_FILES means we don't need to do fd passing,
> //     we share the file descriptor table.
> // CLONE_VM means we don't have the cost of duplicating
> //     our VMAs and page tables, and we don't have to mark
> //     all our pagetable entries as readonly for copy-on-write.
> // CLONE_VFORK is a dirty hack to avoid having to
> //     allocate a child stack.
> // Lack of SIGCHLD means we don't want to have to wait()
> //     for the child.
> int child_pid = syscall_(__NR_clone, CLONE_FILES|CLONE_VM|CLONE_VFORK,
> 0, 0, 0, 0);
> if (child_pid == 0) {
>   // Enter the container's user namespace; this allows us
>   // to afterwards join its mount namespace even if we're
>   // not capable in the init namespace.
>   // (I believe that it should be possible to change the kernel
>   // such that this is not required if you have set the
>   // no-new-privs flag.)
>   setns(container_user_ns_fd, CLONE_NEWUSER);
>   // Entering the filesystem namespace automatically
>   // moves us to that namespace's filesystem root.
>   setns(container_fs_ns_fd, CLONE_NEWNS);
>   result_fd = open(untrusted_container_path, ...);
>   syscall(__NR_exit, 0);
> }
> 
> > The most significant change in semantics with AT_THIS_ROOT is that
> > *at(2) syscalls now no longer have the property that an absolute
> > pathname causes the dirfd to be ignored completely (if LOOKUP_CHROOT is
> > specified). The reasoning behind this is that AT_THIS_ROOT necessarily
> > has to chroot-scope symlinks with absolute paths to dirfd, and so doing
> > it for the base path seems to be the most consistent behaviour (and also
> > avoids foot-gunning users who want to chroot-scope paths that might be
> > absolute).
> >
> > Currently this is only enabled for the stat(2) and openat(2) family (the
> > latter has its own flag O_THISROOT with the same semantics). Ideally
> > this flag would be supported by all *at(2) syscalls, but this will
> > require adding flags arguments to many of them (and will be done in a
> > separate patchset).
> >
> > [1]: https://github.com/cyphar/filepath-securejoin
> >
> > Cc: Eric Biederman <ebiederm@xmission.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> > ---
> >  fs/fcntl.c                       |   2 +-
> >  fs/namei.c                       | 121 +++++++++++++++++--------------
> >  fs/open.c                        |   2 +
> >  fs/stat.c                        |   4 +-
> >  include/linux/fcntl.h            |   2 +-
> >  include/linux/namei.h            |   1 +
> >  include/uapi/asm-generic/fcntl.h |   3 +
> >  include/uapi/linux/fcntl.h       |   2 +
> >  8 files changed, 81 insertions(+), 56 deletions(-)
> >
> > diff --git a/fs/fcntl.c b/fs/fcntl.c
> > index e343618736f7..4c36c5b9fdb9 100644
> > --- a/fs/fcntl.c
> > +++ b/fs/fcntl.c
> > @@ -1031,7 +1031,7 @@ static int __init fcntl_init(void)
> >          * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
> >          * is defined as O_NONBLOCK on some platforms and not on others.
> >          */
> > -       BUILD_BUG_ON(25 - 1 /* for O_RDONLY being 0 */ !=
> > +       BUILD_BUG_ON(26 - 1 /* for O_RDONLY being 0 */ !=
> >                 HWEIGHT32(
> >                         (VALID_OPEN_FLAGS & ~(O_NONBLOCK | O_NDELAY)) |
> >                         __FMODE_EXEC | __FMODE_NONOTIFY));
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 757dd783771c..1b984f0dbbb4 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -2193,9 +2193,64 @@ static int link_path_walk(const char *name, struct nameidata *nd)
> >         }
> >  }
> >
> > +/*
> > + * Configure nd->path based on the nd->dfd. This is only used as part of
> > + * path_init().
> > + */
> > +static inline int dirfd_path_init(struct nameidata *nd)
> > +{
> > +       if (nd->dfd == AT_FDCWD) {
> > +               if (nd->flags & LOOKUP_RCU) {
> > +                       struct fs_struct *fs = current->fs;
> > +                       unsigned seq;
> > +
> > +                       do {
> > +                               seq = read_seqcount_begin(&fs->seq);
> > +                               nd->path = fs->pwd;
> > +                               nd->inode = nd->path.dentry->d_inode;
> > +                               nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
> > +                       } while (read_seqcount_retry(&fs->seq, seq));
> > +               } else {
> > +                       get_fs_pwd(current->fs, &nd->path);
> > +                       nd->inode = nd->path.dentry->d_inode;
> > +               }
> > +       } else {
> > +               /* Caller must check execute permissions on the starting path component */
> > +               struct fd f = fdget_raw(nd->dfd);
> > +               struct dentry *dentry;
> > +
> > +               if (!f.file)
> > +                       return -EBADF;
> > +
> > +               dentry = f.file->f_path.dentry;
> > +
> > +               if (*nd->name->name && unlikely(!d_can_lookup(dentry))) {
> > +                       fdput(f);
> > +                       return -ENOTDIR;
> > +               }
> > +
> > +               nd->path = f.file->f_path;
> > +               if (nd->flags & LOOKUP_RCU) {
> > +                       nd->inode = nd->path.dentry->d_inode;
> > +                       nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
> > +               } else {
> > +                       path_get(&nd->path);
> > +                       nd->inode = nd->path.dentry->d_inode;
> > +               }
> > +               fdput(f);
> > +       }
> > +       if (unlikely(nd->flags & (LOOKUP_CHROOT | LOOKUP_BENEATH))) {
> > +               nd->root = nd->path;
> > +               if (!(nd->flags & LOOKUP_RCU))
> > +                       path_get(&nd->root);
> > +       }
> > +       return 0;
> > +}
> > +
> >  /* must be paired with terminate_walk() */
> >  static const char *path_init(struct nameidata *nd, unsigned flags)
> >  {
> > +       int error;
> >         const char *s = nd->name->name;
> >
> >         if (!*s)
> > @@ -2230,65 +2285,25 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
> >         nd->path.dentry = NULL;
> >
> >         nd->m_seq = read_seqbegin(&mount_lock);
> > +       if (unlikely(flags & LOOKUP_CHROOT)) {
> > +               error = dirfd_path_init(nd);
> > +               if (unlikely(error))
> > +                       return ERR_PTR(error);
> > +       }
> >         if (*s == '/') {
> > -               int error;
> > -               set_root(nd);
> > +               if (likely(!nd->root.mnt))
> > +                       set_root(nd);
> >                 error = nd_jump_root(nd);
> >                 if (unlikely(error))
> >                         s = ERR_PTR(error);
> >                 return s;
> > -       } else if (nd->dfd == AT_FDCWD) {
> > -               if (flags & LOOKUP_RCU) {
> > -                       struct fs_struct *fs = current->fs;
> > -                       unsigned seq;
> > -
> > -                       do {
> > -                               seq = read_seqcount_begin(&fs->seq);
> > -                               nd->path = fs->pwd;
> > -                               nd->inode = nd->path.dentry->d_inode;
> > -                               nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
> > -                       } while (read_seqcount_retry(&fs->seq, seq));
> > -               } else {
> > -                       get_fs_pwd(current->fs, &nd->path);
> > -                       nd->inode = nd->path.dentry->d_inode;
> > -               }
> > -               if (unlikely(flags & LOOKUP_BENEATH)) {
> > -                       nd->root = nd->path;
> > -                       if (!(flags & LOOKUP_RCU))
> > -                               path_get(&nd->root);
> > -               }
> > -               return s;
> > -       } else {
> > -               /* Caller must check execute permissions on the starting path component */
> > -               struct fd f = fdget_raw(nd->dfd);
> > -               struct dentry *dentry;
> > -
> > -               if (!f.file)
> > -                       return ERR_PTR(-EBADF);
> > -
> > -               dentry = f.file->f_path.dentry;
> > -
> > -               if (*s && unlikely(!d_can_lookup(dentry))) {
> > -                       fdput(f);
> > -                       return ERR_PTR(-ENOTDIR);
> > -               }
> > -
> > -               nd->path = f.file->f_path;
> > -               if (flags & LOOKUP_RCU) {
> > -                       nd->inode = nd->path.dentry->d_inode;
> > -                       nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
> > -               } else {
> > -                       path_get(&nd->path);
> > -                       nd->inode = nd->path.dentry->d_inode;
> > -               }
> > -               if (unlikely(flags & LOOKUP_BENEATH)) {
> > -                       nd->root = nd->path;
> > -                       if (!(flags & LOOKUP_RCU))
> > -                               path_get(&nd->root);
> > -               }
> > -               fdput(f);
> > -               return s;
> >         }
> > +       if (likely(!nd->path.mnt)) {
> > +               error = dirfd_path_init(nd);
> > +               if (unlikely(error))
> > +                       return ERR_PTR(error);
> > +       }
> > +       return s;
> >  }
> >
> >  static const char *trailing_symlink(struct nameidata *nd)
> > diff --git a/fs/open.c b/fs/open.c
> > index 80f5f566a5ff..81d148f626cd 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -996,6 +996,8 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
> >                 lookup_flags |= LOOKUP_NO_PROCLINKS;
> >         if (flags & O_NOSYMLINKS)
> >                 lookup_flags |= LOOKUP_NO_SYMLINKS;
> > +       if (flags & O_THISROOT)
> > +               lookup_flags |= LOOKUP_CHROOT;
> >         op->lookup_flags = lookup_flags;
> >         return 0;
> >  }
> > diff --git a/fs/stat.c b/fs/stat.c
> > index 791e61b916ae..e8366e4812c3 100644
> > --- a/fs/stat.c
> > +++ b/fs/stat.c
> > @@ -172,7 +172,7 @@ int vfs_statx(int dfd, const char __user *filename, int flags,
> >
> >         if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT | AT_EMPTY_PATH |
> >                       KSTAT_QUERY_FLAGS | AT_BENEATH | AT_XDEV |
> > -                     AT_NO_PROCLINKS | AT_NO_SYMLINKS))
> > +                     AT_NO_PROCLINKS | AT_NO_SYMLINKS | AT_THIS_ROOT))
> >                 return -EINVAL;
> >
> >         if (flags & AT_SYMLINK_NOFOLLOW)
> > @@ -189,6 +189,8 @@ int vfs_statx(int dfd, const char __user *filename, int flags,
> >                 lookup_flags |= LOOKUP_NO_PROCLINKS;
> >         if (flags & AT_NO_SYMLINKS)
> >                 lookup_flags |= LOOKUP_NO_SYMLINKS;
> > +       if (flags & AT_THIS_ROOT)
> > +               lookup_flags |= LOOKUP_CHROOT;
> >
> >  retry:
> >         error = user_path_at(dfd, filename, lookup_flags, &path);
> > diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
> > index ad5bba4b5b12..95480cd4c09d 100644
> > --- a/include/linux/fcntl.h
> > +++ b/include/linux/fcntl.h
> > @@ -10,7 +10,7 @@
> >          O_APPEND | O_NDELAY | O_NONBLOCK | O_NDELAY | __O_SYNC | O_DSYNC | \
> >          FASYNC | O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
> >          O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE | O_BENEATH | O_XDEV | \
> > -        O_NOPROCLINKS | O_NOSYMLINKS)
> > +        O_NOPROCLINKS | O_NOSYMLINKS | O_THISROOT)
> >
> >  #ifndef force_o_largefile
> >  #define force_o_largefile() (BITS_PER_LONG != 32)
> > diff --git a/include/linux/namei.h b/include/linux/namei.h
> > index 5ff7f3362d1b..7ec9e2d84649 100644
> > --- a/include/linux/namei.h
> > +++ b/include/linux/namei.h
> > @@ -53,6 +53,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
> >  #define LOOKUP_NO_PROCLINKS    0x040000 /* No /proc/$pid/fd/ "symlink" crossing. */
> >  #define LOOKUP_NO_SYMLINKS     0x080000 /* No symlink crossing *at all*.
> >                                             Implies LOOKUP_NO_PROCLINKS. */
> > +#define LOOKUP_CHROOT          0x100000 /* Treat dirfd as %current->fs->root. */
> >
> >  extern int path_pts(struct path *path);
> >
> > diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
> > index c2bf5983e46a..11206b0e927c 100644
> > --- a/include/uapi/asm-generic/fcntl.h
> > +++ b/include/uapi/asm-generic/fcntl.h
> > @@ -113,6 +113,9 @@
> >  #ifndef O_NOSYMLINKS
> >  #define O_NOSYMLINKS   01000000000
> >  #endif
> > +#ifndef O_THISROOT
> > +#define O_THISROOT     02000000000
> > +#endif
> >
> >  #define F_DUPFD                0       /* dup */
> >  #define F_GETFD                1       /* get close_on_exec */
> > diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> > index 551a9e2166a8..ea978457b68f 100644
> > --- a/include/uapi/linux/fcntl.h
> > +++ b/include/uapi/linux/fcntl.h
> > @@ -99,6 +99,8 @@
> >  #define AT_NO_PROCLINKS                0x40000 /* No /proc/$pid/fd/... "symlinks". */
> >  #define AT_NO_SYMLINKS         0x80000 /* No symlinks *at all*.
> >                                            Implies AT_NO_PROCLINKS. */
> > +#define AT_THIS_ROOT           0x100000 /* Path resolution acts as though
> > +                                          it is chroot-ed into dirfd. */
> >
> >
> >  #endif /* _UAPI_LINUX_FCNTL_H */
> > --
> > 2.19.0
> >
> >
