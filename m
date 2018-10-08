From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path resolution
Date: Mon, 8 Oct 2018 12:50:34 +0200
Message-ID: <CAG48ez3M84-iL7_9__G81L+16K1eT3j-=QTjL_kVy6BC6sYZzQ@mail.gmail.com>
References: <20180929103453.12025-1-cyphar@cyphar.com> <20180929131534.24472-1-cyphar@cyphar.com>
 <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
 <20181004162611.vdlujbdguvagalpt@ryuk> <CAG48ez2u--Wac7d9n3idC92Pd-M40QzYtR6FKR8PAYr=VQHUBQ@mail.gmail.com>
 <20181005150728.mgqnpkbukpeu3bsm@ryuk> <CAG48ez3FG0axt92F=+vDe1Q=kj-YngmCgFqDET7E2xCE1mOgeg@mail.gmail.com>
 <20181006021002.6vzsdwd3klddbmji@ryuk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181006021002.6vzsdwd3klddbmji@ryuk>
Sender: linux-kernel-owner@vger.kernel.org
To: cyphar@cyphar.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 6, 2018 at 4:10 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2018-10-05, Jann Horn <jannh@google.com> wrote:
> > > What if we took rename_lock (call it nd->r_seq) at the start of the
> > > resolution, and then only tried the __d_path-style check
> > >
> > >   if (read_seqretry(&rename_lock, nd->r_seq) ||
> > >       read_seqretry(&mount_lock, nd->m_seq))
> > >           /* do the __d_path lookup. */
> > >
> > > That way you would only hit the slow path if there were concurrent
> > > renames or mounts *and* you are doing a path resolution with
> > > AT_THIS_ROOT or AT_BENEATH. I've attached a modified patch that does
> > > this (and after some testing it also appears to work).
> >
> > Yeah, I think that might do the job.
>
> *phew* I was all out of other ideas. :P
>
> > > ---
> > >  fs/namei.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
> > >  1 file changed, 46 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/namei.c b/fs/namei.c
> > > index 6f995e6de6b1..12c9be175cb4 100644
> > > --- a/fs/namei.c
> > > +++ b/fs/namei.c
> > > @@ -493,7 +493,7 @@ struct nameidata {
> > >         struct path     root;
> > >         struct inode    *inode; /* path.dentry.d_inode */
> > >         unsigned int    flags;
> > > -       unsigned        seq, m_seq;
> > > +       unsigned        seq, m_seq, r_seq;
> > >         int             last_type;
> > >         unsigned        depth;
> > >         int             total_link_count;
> > > @@ -1375,6 +1375,27 @@ static int follow_dotdot_rcu(struct nameidata *nd)
> > >                                 return -EXDEV;
> > >                         break;
> > >                 }
> > > +               if (unlikely((nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT)) &&
> > > +                            (read_seqretry(&rename_lock, nd->r_seq) ||
> > > +                             read_seqretry(&mount_lock, nd->m_seq)))) {
> > > +                       char *pathbuf, *pathptr;
> > > +
> > > +                       nd->r_seq = read_seqbegin(&rename_lock);
> > > +                       /* Cannot take m_seq here. */
> > > +
> > > +                       pathbuf = kmalloc(PATH_MAX, GFP_ATOMIC);
> > > +                       if (!pathbuf)
> > > +                               return -ECHILD;
> > > +                       pathptr = __d_path(&nd->path, &nd->root, pathbuf, PATH_MAX);
> > > +                       kfree(pathbuf);
> >
> > You're doing this check before actually looking up the parent, right?
> > So as long as I don't trigger the "path_equal(&nd->path, &nd->root)"
> > check that you do for O_BENEATH, escaping up by one level is possible,
> > right? You should probably move this check so that it happens after
> > following "..".
>
> Yup, you're right. I'll do that.
>
> > (Also: I assume that you're going to get rid of that memory allocation
> > in a future version.)
>
> Sure. Would you prefer adding some scratch space in nameidata, or that I
> change __d_path so it accepts NULL as the buffer (and thus it doesn't
> actually do any string operations)?

Well, I think accepting a NULL buffer would be much cleaner; but keep
in mind that I'm just someone making suggestions, Al Viro is the one
who has to like your code. :P

> > >                 if (nd->path.dentry != nd->path.mnt->mnt_root) {
> > >                         int ret = path_parent_directory(&nd->path);
> > >                         if (ret)
> > > @@ -2269,6 +2311,9 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
> > >         nd->last_type = LAST_ROOT; /* if there are only slashes... */
> > >         nd->flags = flags | LOOKUP_JUMPED | LOOKUP_PARENT;
> > >         nd->depth = 0;
> > > +       nd->m_seq = read_seqbegin(&mount_lock);
> > > +       nd->r_seq = read_seqbegin(&rename_lock);
> >
> > This means that now, attempting to perform a lookup while something is
> > holding the rename_lock will spin on the lock. I don't know whether
> > that's a problem in practice though. Does anyone on this thread know
> > whether this is problematic?
>
> I could make it so that we only take &rename_lock
>   if (nd->flags & (FOLLOW_BENEATH | FOLLOW_CHROOT)),
> since it's not used outside of that path.

I think that might be a sensible change; but as I said, I don't
actually know whether it's necessary, and it would be very helpful if
someone who actually knows commented on this.
