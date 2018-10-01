From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path resolution
Date: Mon, 1 Oct 2018 13:29:16 +0200
Message-ID: <CAG48ez32xKKdtNWreLUMqB+tOfMy-bUK2Bo=vujOTb3qK9NwBg@mail.gmail.com>
References: <20180929103453.12025-1-cyphar@cyphar.com> <20180929131534.24472-1-cyphar@cyphar.com>
 <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
 <20181001054246.gfinmx3api7kjhmc@ryuk> <20181001104202.f6tz54s3fbvld56g@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181001104202.f6tz54s3fbvld56g@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: christian@brauner.io
Cc: cyphar@cyphar.com, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 1, 2018 at 12:42 PM Christian Brauner <christian@brauner.io> wrote:
> On Mon, Oct 01, 2018 at 03:44:28PM +1000, Aleksa Sarai wrote:
> > On 2018-09-29, Jann Horn <jannh@google.com> wrote:
> > > The problem is what happens if a folder you are walking through is
> > > concurrently moved out of the chroot. Consider the following scenario:
> > >
> > > You attempt to open "C/../../etc/passwd" under the root "/A/B".
> > > Something else concurrently moves /A/B/C to /A/C. This can result in
> > > the following:
> > >
> > > 1. You start the path walk and reach /A/B/C.
> > > 2. The other process moves /A/B/C to /A/C. Your path walk is now at /A/C.
> > > 3. Your path walk follows the first ".." up into /A. This is outside
> > > the process root, but you never actually encountered the process root,
> > > so you don't notice.
> > > 4. Your path walk follows the second ".." up to /. Again, this is
> > > outside the process root, but you don't notice.
> > > 5. Your path walk walks down to /etc/passwd, and the open completes
> > > successfully. You now have an fd pointing outside your chroot.
> > >
> > > If the root of your walk is below an attacker-controlled directory,
> > > this of course means that you lose instantly. If you point the root of
> > > the walk at a directory out of which a process in the container
> > > wouldn't be able to move the file, you're probably kinda mostly fine -
> > > as long as you know, for certain, that nothing else on the system
> > > would ever do that. But I still wouldn't feel good about that.
> >
> > Please correct me if I'm wrong here (this is the first patch I've
> > written for VFS). Isn't the retry/LOOKUP_REVAL code meant to handle this
> > -- or does that only handle if a particular path component changes
> > *while* it's being walked through? Is it possible for a path walk to
> > succeed after a path component was unmounted (obviously you can't delete
> > a directory path component since you'd get -ENOTEMPTY)?
> >
> > If this is an issue for AT_THIS_ROOT, I believe this might also be an
> > issue for AT_BENEATH since they are effectively both using the same
> > nd->root trick (so you could similarly trick AT_BENEATH to not error
> > out). So we'd need to figure out how to solve this problem in order for
> > AT_BENEATH to be safe.
> >
> > Speaking naively, doesn't it make sense to invalidate the walk if a path
> > component was modified? Or is this something that would be far too
> > costly with little benefit? What if we do more aggressive nd->root
> > checks when resolving with AT_BENEATH or AT_THIS_ROOT (or if nd->root !=
> > current->mnt_ns->root)?
> >
> > Regarding chroot attacks, I was aware of the trivial
> > chroot-open-chroot-fchdir attack but I was not aware that there was a
> > rename attack for chroot. Thanks for bringing this up!
> >
> > > I believe that the only way to robustly use this would be to point the
> > > dirfd at a mount point, such that you know that being moved out of the
> > > chroot is impossible because the mount point limits movement of
> > > directories under it. (Well, technically, it doesn't, but it ensures
> > > that if a directory does dangerously move away, the syscall fails.) It
> > > might make sense to hardcode this constraint in the implementation of
> > > AT_THIS_ROOT, to keep people from shooting themselves in the foot.
> >
> > Unless I'm missing something, would this not also affect using a
> > mountpoint as a dirfd-root (with MS_MOVE of an already-walked-through
> > path component) -- or does MS_MOVE cause a rewalk in a way that rename
> > does not?
> >
> > I wouldn't mind tying AT_THIS_ROOT to only work on mountpoints (I
> > thought that bind-mounts would be an issue but you also get -EXDEV when
> > trying to rename across bind-mounts even if they are on the same
> > underlying filesystem). But AT_BENEATH might be a more bitter pill to
> > swallow. I'm not sure.
> >
> > In the usecase of container runtimes, we wouldn't generally be doing
> > resolution of attacker-controlled paths but it still definitely doesn't
> > hurt to consider this part of the threat model -- to avoid foot-gunning
> > as you've said. (There also might be some nested-container cases where
> > you might want to do that.)
> >
> > > > Currently most container runtimes try to do this resolution in
> > > > userspace[1], causing many potential race conditions. In addition, the
> > > > "obvious" alternative (actually performing a {ch,pivot_}root(2))
> > > > requires a fork+exec which is *very* costly if necessary for every
> > > > filesystem operation involving a container.
> > >
> > > Wait. fork() I understand, but why exec? And actually, you don't need
> > > a full fork() either, clone() lets you do this with some process parts
> > > shared. And then you also shouldn't need to use SCM_RIGHTS, just keep
> > > the file descriptor table shared. And why chroot()/pivot_root(),
> > > wouldn't you want to use setns()?
> >
> > You're right about this -- for C runtimes. In Go we cannot do a raw
> > clone() or fork() (if you do it manually with RawSyscall you'll end with
> > broken runtime state). So you're forced to do fork+exec (which then
> > means that you can't use CLONE_FILES and must use SCM_RIGHTS). Same goes
> > for CLONE_VFORK.
> >
> > (It should be noted that multi-threaded C runtimes have somewhat similar
> > issues -- AFAIK you can technically only use AS-Safe glibc functions
> > after a fork() but that's more of a theoretical concern here. If you
> > just use raw syscalls there isn't an issue.)
> >
> > As for why use setns() rather than pivot_root(), there are cases where
> > you're operating on a container's image without a running container
> > (think image extraction or snapshotting tools). In those cases, you
> > would need to set up a dummy container process in order to setns() into
> > its namespaces. You are right that setns() would be a better option if
> > you want the truthful state of what mounts the container sees.
> >
> > [I also don't like the idea of joining the user namespace of a malicious
> > container unless it's necessary but that's probably just needless
> > paranoia more than anything -- since you're not joining the pidns you
> > aren't trivially addressable by a malicious container.]
> >
> > > // Ensure that we are non-dumpable. Together with
> > > // commit bfedb589252c, this ensures that container root
> > > // can't trace our child once it enters the container.
> > > // My patch
> > > // https://lore.kernel.org/lkml/1451098351-8917-1-git-send-email-jann@thejh.net/
> > > // would make this unnecessary, but that patch didn't
> > > // land because Eric nacked it (for political reasons,
> > > // because people incorrectly claimed that this was a
> > > // security fix):
> >
> > Unless I'm very much mistaken this was fixed by bfedb589252c ("mm: Add a
> > user_ns owner to mm_struct and fix ptrace permission checks"). If you
> > join a user namespace then processes within that user namespace won't
> > have ptrace_may_access() permissions because your mm is owned by an
> > ancestor user namespace -- only after exec() will you be traceable.
>
> That is not _completely_ true.
> Iirc (Please someone do yell at me if I'm wrong!), this is as follows.
> You will in fact be dumpable as long as you don't set{g,u}id() to an
> effective uid that is different from the effective uid of the process
> that created the task. For example, if you clone(CLONE_NEWUSER) as an
> unprivileged user with uid and euid 1000 you are in fact dumpable and
> thus traceable *but* if you do a setuid(0) in the new task then you will
> end up with old->euid = 1000 and new->euid = 0 at which point the kernel
> will remove the dumpable flag and the creating process cannot trace you
> anymore (which has funny consequences for lsm isolation and sending fds
> around). Iiuc, The same logic applies when you do a setns() to another
> user namespace.

(Note that this is only true if your un-namespaced UID actually
changes. If you create a user namespace and then write to its uid_map
such that your namespaced UID is zero, that won't trigger this logic.)
