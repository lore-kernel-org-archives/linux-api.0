From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 3/8] namespaces: expose ns instance serial numbers in
 proc
Date: Thu, 21 Aug 2014 21:58:03 -0400
Message-ID: <20140822015803.GG20529@madcap2.tricolour.ca>
References: <cover.1408581429.git.rgb@redhat.com>
 <cd6cd0622ce677b639afae18a69ff79c72490bab.1408581429.git.rgb@redhat.com>
 <CALCETrUnzG1V8w+H9ctAJP+Hvo8LQax=dhLG4bBpBKmVi+C1cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUnzG1V8w+H9ctAJP+Hvo8LQax=dhLG4bBpBKmVi+C1cQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 14/08/21, Andy Lutomirski wrote:
> On Aug 20, 2014 8:12 PM, "Richard Guy Briggs" <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Expose the namespace instace serial numbers in the proc filesystem at
> > /proc/<pid>/ns/<ns>_snum.  The link text gives the serial number in hex.
> 
> What's the use case?
> 
> I understand the utility of giving unique numbers to the audit code,
> but I don't think this part is necessary for that, and I'd like to
> understand what else will use this before committing to a duplicative
> API like this.

How does a container manager get those numbers?  It could provoke a task
to cause an audit event that emits a NS_INFO message, or it could run a
task in that container to report its namespace serial numbers directly
from its /proc mount.

The discussion in this thread touches on the use cases:
	https://lkml.org/lkml/2014/4/22/662

> Note that this API is thoroughly incompatible with CRIU.  If we do
> this, someone will ask for a namespace number namespace, and that way
> lies madness.

I had a very brief look at CRIU, but not enough to understand the issue.
Others have hinted at this problem.

Do you have a suggestion of a different approach that would be
compatible with CRIU?

I'd originally considered some sort of UUID that would be globally
unique, but that would be very hard to devise or guarantee, and besides,
namespaces aren't only used by containers and could be shared in other
ways.  Tracking the usage and migration of namespaces should be the task
of an upper layer.

> --Andy
> 
> >
> > "snum" was chosen instead of "seq" for consistency with inum and there are a
> > number of other uses of "seq" in the namespace code.
> >
> > Suggested-by: Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/proc/namespaces.c |   33 +++++++++++++++++++++++++--------
> >  1 files changed, 25 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
> > index 8902609..e953e0a 100644
> > --- a/fs/proc/namespaces.c
> > +++ b/fs/proc/namespaces.c
> > @@ -47,12 +47,15 @@ static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
> >         struct inode *inode = dentry->d_inode;
> >         const struct proc_ns_operations *ns_ops = PROC_I(inode)->ns.ns_ops;
> >
> > -       return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
> > -               ns_ops->name, inode->i_ino);
> > +       if (strstr(dentry->d_iname, "_snum"))
> > +               return dynamic_dname(dentry, buffer, buflen, "%s_snum:[%llx]",
> > +                       ns_ops->name, ns_ops->snum(PROC_I(inode)->ns.ns));
> > +       else
> > +               return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
> > +                       ns_ops->name, inode->i_ino);
> >  }
> >
> > -const struct dentry_operations ns_dentry_operations =
> > -{
> > +const struct dentry_operations ns_dentry_operations = {
> >         .d_delete       = always_delete_dentry,
> >         .d_dname        = ns_dname,
> >  };
> > @@ -160,7 +163,10 @@ static int proc_ns_readlink(struct dentry *dentry, char __user *buffer, int bufl
> >         if (!ns)
> >                 goto out_put_task;
> >
> > -       snprintf(name, sizeof(name), "%s:[%u]", ns_ops->name, ns_ops->inum(ns));
> > +       if (strstr(dentry->d_iname, "_snum"))
> > +               snprintf(name, sizeof(name), "%s_snum:[%llx]", ns_ops->name, ns_ops->snum(ns));
> > +       else
> > +               snprintf(name, sizeof(name), "%s:[%u]", ns_ops->name, ns_ops->inum(ns));
> >         res = readlink_copy(buffer, buflen, name);
> >         ns_ops->put(ns);
> >  out_put_task:
> > @@ -210,16 +216,23 @@ static int proc_ns_dir_readdir(struct file *file, struct dir_context *ctx)
> >
> >         if (!dir_emit_dots(file, ctx))
> >                 goto out;
> > -       if (ctx->pos >= 2 + ARRAY_SIZE(ns_entries))
> > +       if (ctx->pos >= 2 + 2 * ARRAY_SIZE(ns_entries))
> >                 goto out;
> >         entry = ns_entries + (ctx->pos - 2);
> >         last = &ns_entries[ARRAY_SIZE(ns_entries) - 1];
> >         while (entry <= last) {
> >                 const struct proc_ns_operations *ops = *entry;
> > +               char name[50];
> > +
> >                 if (!proc_fill_cache(file, ctx, ops->name, strlen(ops->name),
> >                                      proc_ns_instantiate, task, ops))
> >                         break;
> >                 ctx->pos++;
> > +               snprintf(name, sizeof(name), "%s_snum", ops->name);
> > +               if (!proc_fill_cache(file, ctx, name, strlen(name),
> > +                                    proc_ns_instantiate, task, ops))
> > +                       break;
> > +               ctx->pos++;
> >                 entry++;
> >         }
> >  out:
> > @@ -247,9 +260,13 @@ static struct dentry *proc_ns_dir_lookup(struct inode *dir,
> >
> >         last = &ns_entries[ARRAY_SIZE(ns_entries)];
> >         for (entry = ns_entries; entry < last; entry++) {
> > -               if (strlen((*entry)->name) != len)
> > +               char name[50];
> > +
> > +               snprintf(name, sizeof(name), "%s_snum", (*entry)->name);
> > +               if (strlen((*entry)->name) != len && strlen(name) != len)
> >                         continue;
> > -               if (!memcmp(dentry->d_name.name, (*entry)->name, len))
> > +               if (!memcmp(dentry->d_name.name, (*entry)->name, len)
> > +                   || !memcmp(dentry->d_name.name, name, len))
> >                         break;
> >         }
> >         if (entry == last)
> > --
> > 1.7.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-api" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

- RGB

--
Richard Guy Briggs <rbriggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
