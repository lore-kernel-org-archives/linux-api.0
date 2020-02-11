From: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/24] user_namespace: introduce fsid mappings
Date: Tue, 11 Feb 2020 21:55:46 +0100
Message-ID: <CAG48ez1GKOfXDZFD7-hGGjT8L9YEojn94DU5_=W8HL3pzdrCgg@mail.gmail.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 11, 2020 at 5:59 PM Christian Brauner
<christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> This is the implementation of shiftfs which was cooked up during lunch at
> Linux Plumbers 2019 the day after the container's microconference. The
> idea is a design-stew from St=C3=A9phane, Aleksa, Eric, and myself. Back =
then
> we all were quite busy with other work and couldn't really sit down and
> implement it. But I took a few days last week to do this work, including
> demos and performance testing.
> This implementation does not require us to touch the vfs substantially
> at all. Instead, we implement shiftfs via fsid mappings.
> With this patch, it took me 20 mins to port both LXD and LXC to support
> shiftfs via fsid mappings.
>
> For anyone wanting to play with this the branch can be pulled from:
> https://github.com/brauner/linux/tree/fsid_mappings
> https://gitlab.com/brauner/linux/-/tree/fsid_mappings
> https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=
=3Dfsid_mappings
>
> The main use case for shiftfs for us is in allowing shared writable
> storage to multiple containers using non-overlapping id mappings.
> In such a scenario you want the fsids to be valid and identical in both
> containers for the shared mount. A demo for this exists in [3].
> If you don't want to read on, go straight to the other demos below in
> [1] and [2].

I guess essentially this means that you want to have UID separation
between containers to prevent the containers - or their owners - from
interfering between each other, but for filesystem access, you don't
want to isolate them from each other using DAC controls on the files
and folders inside the containers' directory hierarchies, instead
relying on mode-0700 parent directories to restrict access to the
container owner? Or would you still have separate UIDs for e.g. the
container's UID range 0-65535, and then map the shared UID range at
100000, or something like that?

> People not as familiar with user namespaces might not be aware that fsid
> mappings already exist. Right now, fsid mappings are always identical to
> id mappings. Specifically, the kernel will lookup fsuids in the uid
> mappings and fsgids in the gid mappings of the relevant user namespace.

That's a bit like saying that a kernel without CONFIG_USER_NS still
has user ID mappings, they just happen to be identity mappings. :P

> With this patch series we simply introduce the ability to create fsid
> mappings that are different from the id mappings of a user namespace.
>
> In the usual case of running an unprivileged container we will have
> setup an id mapping, e.g. 0 100000 100000. The on-disk mapping will
> correspond to this id mapping, i.e. all files which we want to appear as
> 0:0 inside the user namespace will be chowned to 100000:100000 on the
> host. This works, because whenever the kernel needs to do a filesystem
> access it will lookup the corresponding uid and gid in the idmapping
> tables of the container.
> Now think about the case where we want to have an id mapping of 0 100000
> 100000 but an on-disk mapping of 0 300000 100000 which is needed to e.g.
> share a single on-disk mapping with multiple containers that all have
> different id mappings.
> This will be problematic. Whenever a filesystem access is requested, the
> kernel will now try to lookup a mapping for 300000 in the id mapping
> tables of the user namespace but since there is none the files will
> appear to be owned by the overflow id, i.e. usually 65534:65534 or
> nobody:nogroup.
>
> With fsid mappings we can solve this by writing an id mapping of 0
> 100000 100000 and an fsid mapping of 0 300000 100000. On filesystem
> access the kernel will now lookup the mapping for 300000 in the fsid
> mapping tables of the user namespace. And since such a mapping exists,
> the corresponding files will have correct ownership.

Sorry to bring up something as disgusting as setuid execution, but:
What happens when there's a setuid root file with ->i_uid=3D=3D300000? I
guess the only way to make that work inside the containers would be
something like make_kuid(current_user_ns(),
from_kfsuid(current_user_ns(), inode->i_uid)) in the setuid execve
path?

> A note on proc (and sys), the proc filesystem is special in sofar as it
> only has a single superblock that is (currently but might be about to
> change) visible in all user namespaces (same goes for sys). This means
> it has special semantics in many ways, including how file ownership and
> access works. The fsid mapping implementation does not alter how proc
> (and sys) ownership works. proc and sys will both continue to lookup
> filesystem access in id mapping tables.

In your example, a process with namespaced UID set (0, 0, 0, 0) will
have kernel UIDs (100000, 100000, 100000, 300000), right? And then if
I want to open /proc/$pid/personality of another process with the same
UIDs, may_open() will call inode_permission() -> do_inode_permission()
-> generic_permission() -> acl_permission_check(), which will compare
current_fsuid() (which is 300000) against inode->i_uid. But
inode->i_uid was filled by proc_pid_make_inode()->task_dump_owner(),
which set inode->i_uid to 100000, right?

Also, e.g. __ptrace_may_access() uses cred->fsuid for a comparison
with another task's real/effective/saved UID.

[...]
> # Demos
> [1]: Create a container with different id and fsid mappings.
>      https://asciinema.org/a/300233
> [2]: Create a container with id mappings but without fsid mappings.
>      https://asciinema.org/a/300234
> [3]: Share storage between multiple containers with non-overlapping id
>      mappings.
>      https://asciinema.org/a/300235

(I really dislike this asciinema thing; if you want to quickly glance
through the output instead of reading at the same speed as it was
typed, a simple pastebin works much better unless you absolutely have
to show things that use stuff like ncurses UI.)
