From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [CFT][PATCH 09/10] sysfs: Create mountpoints with
 sysfs_create_empty_dir
Date: Wed, 12 Aug 2015 16:00:35 -0400
Message-ID: <20150812200035.GB4496@mtj.duckdns.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
 <878ucrhxi9.fsf@x220.int.ebiederm.org>
 <20150811184426.GH23408@mtj.duckdns.org>
 <877fp1hcuj.fsf@x220.int.ebiederm.org>
 <CALCETrXE=fKa3XkEEo6y2=ZNtsuBfX=kaoyDwiP0C2BwqKJWjw@mail.gmail.com>
 <87mvxxcogp.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mvxxcogp.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 11, 2015 at 07:58:14PM -0500, Eric W. Biederman wrote:
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
> 
> > On Tue, Aug 11, 2015 at 11:57 AM, Eric W. Biederman
> > <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> >>
> >> *Boggle*
> >>
> >> The only time this should prevent anything is when in a container when
> >> you are not global root.  And then only mounting sysfs should be
> >> affected.
> >
> > Before:
> >
> > open("/sys/kernel/debug/asdf", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK,
> > 0666) = -1 EACCES (Permission denied)
> >
> >
> > After:
> >
> > open("/sys/kernel/debug/asdf", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK,
> > 0666) = -1 ENOENT (No such file or directory)
> >
> > Something broke.  I don't know whether CentOS cares about that change,
> > but there could be other odd side effects.
> 
> Thanks for pointing this out.  I don't know if broke is quite the right
> word for a change in error codes on lookup failure, but I agree it is a
> difference that could have affected something.
> 
> The behavior of empty proc dirs actually return -ENOENT in this
> situation and so it is a little fuzzy about which is the best behavior
> to use.
> 
> Creativing a negative dentry and and then letting vfs_create fail may be
> the better way to go.
> 
> Negative dentries are weird enough that I would prefer not to have code
> that creates negative dentries.  They could easily be a lurking trap
> for some filesystems dentry operations.
> 
> The patch below is enough to change the error code if someone who can
> reproduce this wants to try this.
> 
> Eric
> 
> diff --gdiff --git a/fs/libfs.c b/fs/libfs.c
> index 102edfd39000..3a452a485cbf 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -1109,7 +1109,7 @@ EXPORT_SYMBOL(simple_symlink_inode_operations);
>   */
>  static struct dentry *empty_dir_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
>  {
> -       return ERR_PTR(-ENOENT);
> +       return NULL;

And let's please restore this too.  Sentiments about negative dentries
aside, It's outright wrong to report -ENOENT on creat.

Thanks.

-- 
tejun
