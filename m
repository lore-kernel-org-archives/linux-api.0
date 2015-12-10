From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Wed, 9 Dec 2015 19:28:16 -0600
Message-ID: <20151210012816.GA990@mail.hallyn.com>
References: <1449689341-28742-1-git-send-email-serge.hallyn@ubuntu.com>
	<1449689341-28742-2-git-send-email-serge.hallyn@ubuntu.com>
	<20151209213806.GP30240@mtj.duckdns.org>
	<20151209221327.GA13029@ubuntumail>
	<20151209223651.GQ30240@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151209223651.GQ30240-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 09, 2015 at 05:36:51PM -0500, Tejun Heo wrote:
> Hey,
> 
> On Wed, Dec 09, 2015 at 10:13:27PM +0000, Serge Hallyn wrote:
> > we can rename kn_root to from here if you think that's clearer (and
> > change the order here as well).
> 
> I think it'd be better for them to be consistent and in the same order
> - the target and then the optional base.
> 
> > > Was converting the path functions to return
> > > length too much work?  If so, that's fine but please explain what
> > > decisions were made.
> > 
> > Yes, I had replied saying:
> > 
> >  |I can change that, but the callers right now don't re-try with
> >  |larger buffer anyway, so this would actually complicate them just
> >  |a smidgeon.  Would you want them changed to do that?  (pr_cont_kernfs_path
> >  |right now writes into a static char[] for instance)
> > 
> > I can still make that change if you like.
> 
> Oops, sorry I forgot about that.  The reason why kernfs_path() is
> written the current way was me being lazy.  While I think it'd be
> better to make the functions behave like normal string handling
> functions if we're extending it, I don't think it's that important.
> If it's easy, please go ahead.  If not, we can get back to it later
> when necessary.
> 
> > > I skimmed through the series and spotted several other review points
> > > which didn't get addressed.  Can you please go over the previous
> > > review cycle and address the review points?
> > 
> > I did go through every email twice, once while making changes (one
> > branch per response) and once while making changelog for each patch,
> > sorry about whatever I missed.  I'll go through each again.
> 
> The other chunk I noticed was inline conversions of internal functions
> which didn't seem to belong to the patch.  I asked whether those were
> stray chunks.  Maybe the comment was too buried to notice?  Anyways,
> that part actually causes conflicts when applying to cgroup/for-4.5.
> 
> There are a couple more things.
> 
> * Can you please put the ns related decls after the regular cgroup
>   stuff in cgroup.h?
> 
> * I think I might need to edit the documentation anyway but it'd be
>   great if you can make the namespace section more in line with the
>   rest of the documentation - e.g. s/CGroup/cgroup/ and more
>   structured sectioning.

Ok fwiw I've fixed up the arguments to kernfs_path_from_node, removed
the inlines, and moved the ns related decls after the others in cgroup.h
(i.e. done the easy stuff) in the 2015-12-09/cgroupns.3 branch of
git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/linux-security.git

I'll address the rest either after next week or, hopefully, when I get
a chance earlier.

> At this point, it all generally looks good to me.  Let's get the
> nits out of the way and merge it.

If you wanted to take the branch as is, then I'll do the documentation
and pr_cont_kernfs_path() etc rewrite as separate patches, but I'll
assume you'd like to at least wait for doc rewrite.

-serge
