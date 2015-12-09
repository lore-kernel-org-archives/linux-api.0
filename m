From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Wed, 9 Dec 2015 22:13:27 +0000
Message-ID: <20151209221327.GA13029@ubuntumail>
References: <1449689341-28742-1-git-send-email-serge.hallyn@ubuntu.com>
 <1449689341-28742-2-git-send-email-serge.hallyn@ubuntu.com>
 <20151209213806.GP30240@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151209213806.GP30240-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, "Serge E. Hallyn" <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> Hello, Serge.
> 
> On Wed, Dec 09, 2015 at 01:28:54PM -0600, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> > +/* kernfs_node_depth - compute depth from @from to @to */
> > +static size_t kernfs_depth(struct kernfs_node *from, struct kernfs_node *to)
> ...
> > +char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
> > +{
> > +	return kernfs_path_from_node(NULL, kn, buf, buflen);
> > +}
> ...
> > diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> > index 5d4e9c4..d025ebd 100644
> > --- a/include/linux/kernfs.h
> > +++ b/include/linux/kernfs.h
> > @@ -267,6 +267,9 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
> >  
> >  int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen);
> >  size_t kernfs_path_len(struct kernfs_node *kn);
> > +char * __must_check kernfs_path_from_node(struct kernfs_node *root_kn,
> > +					  struct kernfs_node *kn, char *buf,
> > +					  size_t buflen);
> 
> I think I commented on the same thing before, but I think it'd make
> more sense to put @from after @to

Oh.  You said that for kernfs_path_from_node_locked(), and those were
changed.  kernfs_path_form_node() is a different fn, but

> and the prototype is using @root_kn
> which is a bit confusing.

we can rename kn_root to from here if you think that's clearer (and
change the order here as well).

> Was converting the path functions to return
> length too much work?  If so, that's fine but please explain what
> decisions were made.

Yes, I had replied saying:

 |I can change that, but the callers right now don't re-try with
 |larger buffer anyway, so this would actually complicate them just
 |a smidgeon.  Would you want them changed to do that?  (pr_cont_kernfs_path
 |right now writes into a static char[] for instance)

I can still make that change if you like.

> I skimmed through the series and spotted several other review points
> which didn't get addressed.  Can you please go over the previous
> review cycle and address the review points?

I did go through every email twice, once while making changes (one
branch per response) and once while making changelog for each patch,
sorry about whatever I missed.  I'll go through each again.

I'm going to be out for awhile after today, so next version will
unfortunately take awhile.

thanks,
-serge
