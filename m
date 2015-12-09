From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Wed, 9 Dec 2015 16:51:31 -0600
Message-ID: <20151209225131.GA31415@mail.hallyn.com>
References: <1449689341-28742-1-git-send-email-serge.hallyn@ubuntu.com>
 <1449689341-28742-2-git-send-email-serge.hallyn@ubuntu.com>
 <20151209213806.GP30240@mtj.duckdns.org>
 <20151209221327.GA13029@ubuntumail>
 <20151209223651.GQ30240@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151209223651.GQ30240@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, lxc-devel@lists.linuxcontainers.org, gregkh@linuxfoundation.org, cgroups@vger.kernel.org, akpm@linux-foundation.org
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

Ok - I'm now gone until Dec 21 (and laptopping won't be an option :( ).
I'll make the other changes then and do this as well.  So
pr_cont_kernfs_path() will dynamically allocate a longer buffer (only)
if needed.

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

Gah.  I saw one and removed it.  Grep tells me I missed some, will
remove them all next time.

> There are a couple more things.
> 
> * Can you please put the ns related decls after the regular cgroup
>   stuff in cgroup.h?

ok

> * I think I might need to edit the documentation anyway but it'd be
>   great if you can make the namespace section more in line with the
>   rest of the documentation - e.g. s/CGroup/cgroup/ and more
>   structured sectioning.

I'll read through it and look for patterns to change.

> At this point, it all generally looks good to me.  Let's get the
> nits out of the way and merge it.
> 
> Thanks.

thanks,
-serge
