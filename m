From: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/24] user_namespace: introduce fsid mappings
Date: Wed, 12 Feb 2020 19:53:59 +0100
Message-ID: <CAG48ez18UkQwvtBqcd-_uZafwtKmHy0=JCkDCo9DUqHsR8sTwQ@mail.gmail.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
 <CAG48ez1GKOfXDZFD7-hGGjT8L9YEojn94DU5_=W8HL3pzdrCgg@mail.gmail.com> <20200212145149.zohmc6d3x52bw6j6@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200212145149.zohmc6d3x52bw6j6@wittgenstein>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 12, 2020 at 3:51 PM Christian Brauner
<christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Feb 11, 2020 at 09:55:46PM +0100, Jann Horn via Containers wrote:
> > On Tue, Feb 11, 2020 at 5:59 PM Christian Brauner
> > <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> > > This is the implementation of shiftfs which was cooked up during lunc=
h at
> > > Linux Plumbers 2019 the day after the container's microconference. Th=
e
> > > idea is a design-stew from St=C3=A9phane, Aleksa, Eric, and myself. B=
ack then
> > > we all were quite busy with other work and couldn't really sit down a=
nd
> > > implement it. But I took a few days last week to do this work, includ=
ing
> > > demos and performance testing.
> > > This implementation does not require us to touch the vfs substantiall=
y
> > > at all. Instead, we implement shiftfs via fsid mappings.
> > > With this patch, it took me 20 mins to port both LXD and LXC to suppo=
rt
> > > shiftfs via fsid mappings.
> > >
> > > For anyone wanting to play with this the branch can be pulled from:
> > > https://github.com/brauner/linux/tree/fsid_mappings
> > > https://gitlab.com/brauner/linux/-/tree/fsid_mappings
> > > https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log=
/?h=3Dfsid_mappings
> > >
> > > The main use case for shiftfs for us is in allowing shared writable
> > > storage to multiple containers using non-overlapping id mappings.
> > > In such a scenario you want the fsids to be valid and identical in bo=
th
> > > containers for the shared mount. A demo for this exists in [3].
> > > If you don't want to read on, go straight to the other demos below in
> > > [1] and [2].
> >
> > I guess essentially this means that you want to have UID separation
> > between containers to prevent the containers - or their owners - from
> > interfering between each other, but for filesystem access, you don't
> > want to isolate them from each other using DAC controls on the files
> > and folders inside the containers' directory hierarchies, instead
> > relying on mode-0700 parent directories to restrict access to the
> > container owner? Or would you still have separate UIDs for e.g. the
> > container's UID range 0-65535, and then map the shared UID range at
> > 100000, or something like that?
>
> Yes.
> So if you look at the permissions right now for the directory under
> which the rootfs for the container and other stuff resides we have
> root@wittgenstein|/var/lib/lxd/storage-pools/zfs/containers
> > perms *
> d--x------ 100 alp1
> d--x------ 100 f1
> d--x------ 100 f2
>
> We don't really share the rootfs between containers right now since we
> treat them as standalone systems but with fsid mappings that's possible
> too. Layer-sharing-centric runtimes very much will want something like
> that.
[...]
> > > With this patch series we simply introduce the ability to create fsid
> > > mappings that are different from the id mappings of a user namespace.
> > >
> > > In the usual case of running an unprivileged container we will have
> > > setup an id mapping, e.g. 0 100000 100000. The on-disk mapping will
> > > correspond to this id mapping, i.e. all files which we want to appear=
 as
> > > 0:0 inside the user namespace will be chowned to 100000:100000 on the
> > > host. This works, because whenever the kernel needs to do a filesyste=
m
> > > access it will lookup the corresponding uid and gid in the idmapping
> > > tables of the container.
> > > Now think about the case where we want to have an id mapping of 0 100=
000
> > > 100000 but an on-disk mapping of 0 300000 100000 which is needed to e=
.g.
> > > share a single on-disk mapping with multiple containers that all have
> > > different id mappings.
> > > This will be problematic. Whenever a filesystem access is requested, =
the
> > > kernel will now try to lookup a mapping for 300000 in the id mapping
> > > tables of the user namespace but since there is none the files will
> > > appear to be owned by the overflow id, i.e. usually 65534:65534 or
> > > nobody:nogroup.
> > >
> > > With fsid mappings we can solve this by writing an id mapping of 0
> > > 100000 100000 and an fsid mapping of 0 300000 100000. On filesystem
> > > access the kernel will now lookup the mapping for 300000 in the fsid
> > > mapping tables of the user namespace. And since such a mapping exists=
,
> > > the corresponding files will have correct ownership.
> >
> > Sorry to bring up something as disgusting as setuid execution, but:
>
> No that's exactly what this needs. :)
>
> > What happens when there's a setuid root file with ->i_uid=3D=3D300000? =
I
> > guess the only way to make that work inside the containers would be
> > something like make_kuid(current_user_ns(),
> > from_kfsuid(current_user_ns(), inode->i_uid)) in the setuid execve
> > path?
>
> What's the specific callpath you're thinking about?
>
> So if you look at patch
> https://lore.kernel.org/lkml/20200211165753.356508-16-christian.brauner@u=
buntu.com/
> it does
> -       new->suid =3D new->fsuid =3D new->euid;
> -       new->sgid =3D new->fsgid =3D new->egid;
> +       fsuid =3D from_kuid_munged(new->user_ns, new->euid);
> +       kfsuid =3D make_kfsuid(new->user_ns, fsuid);
> +       new->suid =3D new->euid;
> +       new->fsuid =3D kfsuid;
> +
> +       fsgid =3D from_kgid_munged(new->user_ns, new->egid);
> +       kfsgid =3D make_kfsgid(new->user_ns, fsgid);
> +       new->sgid =3D new->egid;
> +       new->fsgid =3D kfsgid;

Aaah, okay, I missed that.

> One thing I definitely missed though in the setuid path is to adapt
> fs/exec.c:bprm_fill_uid():
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 74d88dab98dd..ad839934fdff 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1547,8 +1547,8 @@ static void bprm_fill_uid(struct linux_binprm *bprm=
)
>         inode_unlock(inode);
>
>         /* We ignore suid/sgid if there are no mappings for them in the n=
s */
> -       if (!kuid_has_mapping(bprm->cred->user_ns, uid) ||
> -                !kgid_has_mapping(bprm->cred->user_ns, gid))
> +       if (!kfsuid_has_mapping(bprm->cred->user_ns, uid) ||
> +                !kfsgid_has_mapping(bprm->cred->user_ns, gid))
>                 return;
>
>         if (mode & S_ISUID) {
[...]
> > I want to open /proc/$pid/personality of another process with the same
> > UIDs, may_open() will call inode_permission() -> do_inode_permission()
> > -> generic_permission() -> acl_permission_check(), which will compare
> > current_fsuid() (which is 300000) against inode->i_uid. But
> > inode->i_uid was filled by proc_pid_make_inode()->task_dump_owner(),
> > which set inode->i_uid to 100000, right?
>
> Yes. That should be fixable by something like below, I think. (And we can
> probably shortcut this by adding a helper that does tell us whether there=
's
> been any fsid mapping setup or not for this user namespace.)
>  static int acl_permission_check(struct inode *inode, int mask)
>  {
> +       kuid_t kuid;
>         unsigned int mode =3D inode->i_mode;
>
> -       if (likely(uid_eq(current_fsuid(), inode->i_uid)))
> +       if (!is_userns_visible(inode->i_sb->s_iflags)) {
> +               kuid =3D inode->i_uid;
> +       } else {
> +               kuid =3D make_kuid(current_user_ns(),
> +                                from_kfsuid(current_user_ns(), inode->i_=
uid));
> +       }
> +
> +       if (likely(uid_eq(current_fsuid(), kuid)))
>                 mode >>=3D 6;
>         else {&& (mode & S_IRWXG)) {
>
> >
> > Also, e.g. __ptrace_may_access() uses cred->fsuid for a comparison
> > with another task's real/effective/saved UID.
>
> Right, you even introduced this check in 2015 iirc.
> Both of your points make me think that it'd be easiest to introduce
> cred->{kfsuid,kfsgid} and whenever an access decision on a
> is_userns_visible() filesystem has to be made those will be used. This av=
oids
> having to do on-the fly translations

I guess that might be less ugly.

> and ptrace_may_access() can just grow a
> flag indicating what fscreds it's supposed to look at?

Wouldn't you always end up using the "real" fsuid there?
