From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 3/3] fs: let filldir_t return bool instead of an error code
Date: Wed, 23 Jan 2019 16:07:59 +0100
Message-ID: <CAG48ez2UmgEkitbgyCCs9LLdgahweFFAJWCU_vcqES6YgN=gLw@mail.gmail.com>
References: <20190118161440.220134-1-jannh@google.com> <20190118161440.220134-3-jannh@google.com>
 <20190120224059.GA4205@dastard> <CAG48ez3SgejgGbctHwxON1B1k26xk-z16xdozKZkx7=-Li0aHw@mail.gmail.com>
 <20190121222411.GD4205@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190121222411.GD4205@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-alpha@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 21, 2019 at 11:24 PM Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Jan 21, 2019 at 04:49:45PM +0100, Jann Horn wrote:
> > On Sun, Jan 20, 2019 at 11:41 PM Dave Chinner <david@fromorbit.com> wrote:
> > > On Fri, Jan 18, 2019 at 05:14:40PM +0100, Jann Horn wrote:
> > > > As Al Viro pointed out, many filldir_t functions return error codes, but
> > > > all callers of filldir_t functions just check whether the return value is
> > > > non-zero (to determine whether to continue reading the directory); more
> > > > precise errors have to be signalled via struct dir_context.
> > > > Change all filldir_t functions to return bool instead of int.
> > > >
> > > > Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> > > > Signed-off-by: Jann Horn <jannh@google.com>
> > > > ---
> > > >  arch/alpha/kernel/osf_sys.c | 12 +++----
> > > >  fs/afs/dir.c                | 30 +++++++++--------
> > > >  fs/ecryptfs/file.c          | 13 ++++----
> > > >  fs/exportfs/expfs.c         |  8 ++---
> > > >  fs/fat/dir.c                |  8 ++---
> > > >  fs/gfs2/export.c            |  6 ++--
> > > >  fs/nfsd/nfs4recover.c       |  8 ++---
> > > >  fs/nfsd/vfs.c               |  6 ++--
> > > >  fs/ocfs2/dir.c              | 10 +++---
> > > >  fs/ocfs2/journal.c          | 14 ++++----
> > > >  fs/overlayfs/readdir.c      | 24 +++++++-------
> > > >  fs/readdir.c                | 64 ++++++++++++++++++-------------------
> > > >  fs/reiserfs/xattr.c         | 20 ++++++------
> > > >  fs/xfs/scrub/dir.c          |  8 ++---
> > > >  fs/xfs/scrub/parent.c       |  4 +--
> > > >  include/linux/fs.h          | 10 +++---
> > > >  16 files changed, 125 insertions(+), 120 deletions(-)
> > > >
> > > > diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
> > > > index db1c2144d477..14e5ae0dac50 100644
> > > > --- a/arch/alpha/kernel/osf_sys.c
> > > > +++ b/arch/alpha/kernel/osf_sys.c
> > > > @@ -108,7 +108,7 @@ struct osf_dirent_callback {
> > > >       int error;
> > > >  };
> > > >
> > > > -static int
> > > > +static bool
> > > >  osf_filldir(struct dir_context *ctx, const char *name, int namlen,
> > > >           loff_t offset, u64 ino, unsigned int d_type)
> > > >  {
> > > > @@ -120,14 +120,14 @@ osf_filldir(struct dir_context *ctx, const char *name, int namlen,
> > > >
> > > >       buf->error = check_dirent_name(name, namlen);
> > > >       if (unlikely(buf->error))
> > > > -             return -EFSCORRUPTED;
> > > > +             return false;
> > > >       buf->error = -EINVAL;   /* only used if we fail */
> > > >       if (reclen > buf->count)
> > > > -             return -EINVAL;
> > > > +             return false;
> > >
> > > Oh, it's because the error being returned is being squashed by
> > > dir_emit():
> >
> > Yeah.
> >
> > > >  struct dir_context {
> > > > @@ -3469,17 +3471,17 @@ static inline bool dir_emit(struct dir_context *ctx,
> > > >                           const char *name, int namelen,
> > > >                           u64 ino, unsigned type)
> > > >  {
> > > > -     return ctx->actor(ctx, name, namelen, ctx->pos, ino, type) == 0;
> > > > +     return ctx->actor(ctx, name, namelen, ctx->pos, ino, type);
> > > >  }
> > >
> > > /me wonders if it would be cleaner to do:
> > >
> > > static inline bool dir_emit(...)
> > > {
> > >         buf->error = ctx->actor(....)
> > >         if (buf->error)
> > >                 return false;
> > >         return true;
> > > }
> > >
> > > And clean up all filldir actors just to return the error state
> > > rather than have to jump through hoops to stash the error state in
> > > the context buffer and return the error state?
> >
> > One negative thing about that, IMO, is that it mixes up the request
> > for termination of the loop and the presence of an error.
>
> Doesn't the code already do that, only worse?

The current code does that, yes. But with this patch, I think that's
not really the case anymore?

> > > That then allows callers who want/need the full error info can
> > > continue to call ctx->actor directly,
> >
> > "continue to call ctx->actor directly"? I don't remember any code that
> > calls ctx->actor directly.
>
> ovl_fill_real().

Ah, right.


> And the XFS directory scrubber could probably make better use of the
> error return from ctx->actor when validating the directory contents
> rather than just calling dir_emit() and aborting the scan at the
> first error encountered. We eventually want to know exactly what
> error was encountered here to determine if it is safe to continue,
> not just a "stop processing" flag. e.g. a bad name length will need
> to stop traversal because we can't trust the underlying structure,
> but an invalid file type isn't a structural flaw that prevents us
> from continuing to traverse and check the rest of the directory....

Sorry, maybe I'm a bit dense right now, I don't get your point. Are
you talking about filesystem errors detected in the actor? If so,
doesn't it make *more* sense for non-fatal errors to put a note that
an error happened into the xchk_dir_ctx (if that information should be
kept around), then return a value that says "please continue"?

Or are you talking about filesystem errors detected in the readdir
implementation? In that case, you're AFAICS going to need special-case
logic gated on ctx->actor==xchk_dir_actor anyway if you want the
scrubber to continue while readdir() stops.

(But as I've said, I don't really care about this patch. If Al takes
patches 1 and 2 from this series, I'm happy; this patch is just in
response to <https://lore.kernel.org/lkml/20180731165112.GJ30522@ZenIV.linux.org.uk/>.)
