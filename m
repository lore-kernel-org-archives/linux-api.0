From: Jann Horn <jannh@google.com>
Subject: Re: [RFC v3 1/1] ns: add binfmt_misc to the user namespace
Date: Mon, 8 Oct 2018 12:58:33 +0200
Message-ID: <CAG48ez0z2b-xwME25mrEnd7++mTj=07g_L+pZdgowGLY9-xqPQ@mail.gmail.com>
References: <20181003225022.32033-1-laurent@vivier.eu> <20181003225022.32033-2-laurent@vivier.eu>
 <20181006060427.GA15164@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181006060427.GA15164@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: avagin@gmail.com
Cc: Laurent Vivier <laurent@vivier.eu>, kernel list <linux-kernel@vger.kernel.org>, Andrei Vagin <avagin@openvz.org>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, dima@arista.com, James Bottomley <James.Bottomley@hansenpartnership.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 6, 2018 at 8:04 AM Andrei Vagin <avagin@gmail.com> wrote:
> On Thu, Oct 04, 2018 at 12:50:22AM +0200, Laurent Vivier wrote:
> > This patch allows to have a different binfmt_misc configuration
> > for each new user namespace. By default, the binfmt_misc configuration
> > is the one of the host, but if the binfmt_misc filesystem is mounted
> > in the new namespace a new empty binfmt instance is created and used
> > in this namespace.
> >
> > For instance, using "unshare" we can start a chroot of an another
> > architecture and configure the binfmt_misc interpreter without being root
> > to run the binaries in this chroot.
> >
> > Signed-off-by: Laurent Vivier <laurent@vivier.eu>
> > ---
> >  fs/binfmt_misc.c               | 85 +++++++++++++++++++++++-----------
> >  include/linux/user_namespace.h | 15 ++++++
> >  kernel/user.c                  | 14 ++++++
> >  kernel/user_namespace.c        |  9 ++++
> >  4 files changed, 95 insertions(+), 28 deletions(-)
> >
> > diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> > index aa4a7a23ff99..78780bc87506 100644
> > --- a/fs/binfmt_misc.c
> > +++ b/fs/binfmt_misc.c
> > @@ -38,9 +38,6 @@ enum {
> >       VERBOSE_STATUS = 1 /* make it zero to save 400 bytes kernel memory */
> >  };
> >
> > -static LIST_HEAD(entries);
> > -static int enabled = 1;
> > -
> >  enum {Enabled, Magic};
> >  #define MISC_FMT_PRESERVE_ARGV0 (1 << 31)
> >  #define MISC_FMT_OPEN_BINARY (1 << 30)
> > @@ -60,10 +57,7 @@ typedef struct {
> >       struct file *interp_file;
> >  } Node;
> >
> > -static DEFINE_RWLOCK(entries_lock);
> >  static struct file_system_type bm_fs_type;
> > -static struct vfsmount *bm_mnt;
> > -static int entry_count;
> >
> >  /*
> >   * Max length of the register string.  Determined by:
> > @@ -85,13 +79,13 @@ static int entry_count;
> >   * if we do, return the node, else NULL
> >   * locking is done in load_misc_binary
> >   */
> > -static Node *check_file(struct linux_binprm *bprm)
> > +static Node *check_file(struct user_namespace *ns, struct linux_binprm *bprm)
> >  {
> >       char *p = strrchr(bprm->interp, '.');
> >       struct list_head *l;
> >
> >       /* Walk all the registered handlers. */
> > -     list_for_each(l, &entries) {
> > +     list_for_each(l, &ns->binfmt_ns->entries) {
> >               Node *e = list_entry(l, Node, list);
> >               char *s;
> >               int j;
> > @@ -133,17 +127,18 @@ static int load_misc_binary(struct linux_binprm *bprm)
> >       struct file *interp_file = NULL;
> >       int retval;
> >       int fd_binary = -1;
> > +     struct user_namespace *ns = current_user_ns();
> >
> >       retval = -ENOEXEC;
> > -     if (!enabled)
> > +     if (!ns->binfmt_ns->enabled)
> >               return retval;
> >
> >       /* to keep locking time low, we copy the interpreter string */
> > -     read_lock(&entries_lock);
> > -     fmt = check_file(bprm);
> > +     read_lock(&ns->binfmt_ns->entries_lock);
>
> It looks like ns->binfmt_ns isn't protected by any lock and
> ns->binfmt_ns can be changed between read_lock() and read_unlock().
>
> This can be fixed if ns->binfmt_ns will be dereferenced only once in
> this function:
>
>         struct binfmt_namespace *binfmt_ns = ns->binfmt_ns;

Technically, wouldn't you want READ_ONCE(ns->binfmt_ns)?
