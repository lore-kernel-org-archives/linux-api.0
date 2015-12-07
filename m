From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside non-init
	cgroupns
Date: Mon, 7 Dec 2015 15:53:01 +0000
Message-ID: <20151207155301.GD10746@ubuntumail>
References: <20151201040704.GA31067@mail.hallyn.com>
	<20151201164649.GD12922@mtj.duckdns.org>
	<20151201215853.GA9153@mail.hallyn.com>
	<20151202165312.GB19878@mtj.duckdns.org>
	<20151202165637.GA20840@mail.hallyn.com>
	<20151202165839.GD19878@mtj.duckdns.org>
	<20151202170239.GA21009@mail.hallyn.com>
	<20151202170551.GE19878@mtj.duckdns.org>
	<20151203224706.GA19971@mail.hallyn.com>
	<20151207153911.GF9175@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151207153911.GF9175-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
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
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> Hello, Serge.
> 
> On Thu, Dec 03, 2015 at 04:47:06PM -0600, Serge E. Hallyn wrote:
> ...
> > +	dentry = dget(sb->s_root);
> > +	if (!kn->parent) // this is the root
> > +		return dentry;
> > +
> > +	knparent = find_kn_ancestor_below(kn, NULL);
> > +	BUG_ON(!knparent);
> 
> Doing WARN_ON() and returning failure is better, I think.  Failing ns
> mount is an okay failure mode and a lot better than crashing the
> system.

Ok - this shouldn't be user-triggerable, so if it happens it really
is a bug in our code, but I'll change it,

> Also, how about find_next_ancestor() for the name of the
> function?

Yeah it's static anyway :)

will change, squash, and resend the set.

> > +	do {
> > +		struct dentry *dtmp;
> > +		struct kernfs_node *kntmp;
> > +
> > +		if (kn == knparent)
> > +			return dentry;
> > +		kntmp = find_kn_ancestor_below(kn, knparent);
> > +		BUG_ON(!kntmp);
> > +		dtmp = lookup_one_len(kntmp->name, dentry, strlen(kntmp->name));
> > +		dput(dentry);
> > +		if (IS_ERR(dtmp))
> > +			return dtmp;
> > +		knparent = kntmp;
> > +		dentry = dtmp;
> > +	} while (1);
> 
> Other than the nitpicks, looks good to me.
> 
> Thanks.
> 
> -- 
> tejun
