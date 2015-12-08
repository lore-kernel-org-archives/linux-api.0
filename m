From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/7] kernfs: Add API to generate relative kernfs path
Date: Tue, 8 Dec 2015 12:45:02 -0600
Message-ID: <20151208184502.GA14814@mail.hallyn.com>
References: <1449529582-4075-1-git-send-email-serge.hallyn@ubuntu.com>
 <1449529582-4075-2-git-send-email-serge.hallyn@ubuntu.com>
 <20151208155251.GA30240@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208155251.GA30240-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 08, 2015 at 10:52:51AM -0500, Tejun Heo wrote:
> Hello, Serge.
> 
> On Mon, Dec 07, 2015 at 05:06:16PM -0600, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> > +/* kernfs_node_depth - compute depth from @from to @to */
> > +static size_t kernfs_node_distance(struct kernfs_node *from, struct kernfs_node *to)
> >  {
> > +	size_t depth = 0;
> >  
> > +	BUG_ON(!to);
> > +	BUG_ON(!from);
> 
> Do these BUG_ON()s achieve anything?

Just try to catch caller errors early on, but I'll drop these.

>   Also, would something like
> kernfs_relative_depth() be a better name for the function?  Maybe even
> just kernfs_depth()?

ok

> ...
> > +static struct kernfs_node *kernfs_common_ancestor(struct kernfs_node *a,
> > +		struct kernfs_node *b)
> > +{
> > +	size_t da = kernfs_node_distance(kernfs_root(a)->kn, a);
> > +	size_t db = kernfs_node_distance(kernfs_root(b)->kn, b);
> > +
> > +	if (da == 0)
> > +		return a;
> > +	if (db == 0)
> > +		return b;
> 
> Hmm... are the above two ifs necessary?  Wouldn't the outcome be the
> same?

Yeah it would, dropping them.

>   Furthermore, if a and b are on different roots the above may
> give the wrong answer while not doing the above would return NULL.

Right, thanks for catching that.  I'm adding a check that the
roots are the same before proceeding.

> > +	while (da > db) {
> > +		a = a->parent;
> > +		da--;
> > +	}
> > +	while (db > da) {
> > +		b = b->parent;
> > +		db--;
> > +	}
> > +
> > +	/* worst case b and a will be the same at root */
> > +	while (b != a) {
> > +		b = b->parent;
> > +		a = a->parent;
> > +	}
> > +
> > +	return a;
> > +}
> ...
> > +static char *
> > +__must_check kernfs_path_from_node_locked(struct kernfs_node *kn_from,
> 
> Maybe
> 
> static char * __must_check
> kernfs_path...

Actually that __must_check seems weird, I'll just drop it.  (ISTM __must_check
makes sense in a fn that does something where we worry the caller doesn't
check that it succeeded, not in a fn where we are just querying a value.

> > +					  struct kernfs_node *kn_to, char *buf,
> > +					  size_t buflen)
> 
> Given that @kn_from is optional and is not the target node, maybe put
> @kn_to before @kn_from?

ok

> > +{
> > +	char *p = buf;
> > +	struct kernfs_node *kn, *common;
> > +	const char parent_str[] = "/..";
> > +	int i;
> > +	size_t depth_from, depth_to, len = 0, nlen = 0,
> > +	       plen = sizeof(parent_str) - 1;
> 
> Heh, idk, just put plen on a separate decl?
> 
> > +
> > +	/* We atleast need 2 bytes to write "/\0". */
> > +	if (buflen < 2)
> > +		return NULL;
> > +
> > +	if (!kn_from)
> > +		kn_from = kernfs_root(kn_to)->kn;
> > +
> > +	if (kn_from == kn_to) {
> > +		*p = '/';
> > +		*(++p) = '\0';
> > +		return buf;
> > +	}
> > +
> > +	common = kernfs_common_ancestor(kn_from, kn_to);
> > +	if (!common) {
> > +		WARN_ONCE("%s: kn_from and kn_to on different roots\n",
> > +			__func__);
> > +		return NULL;
> > +	}
> 
> Have you compiled it?  WARN_ONCE()'s first argument is condition, so
> you'd write
> 
> 	if (WARN_ONCE(!common, "blah blah"))
> 		return NULL;

D'oh.  Actually once isn't even right.  I'll just do WARN_ON
(and try to do it right).

> > +	depth_to = kernfs_node_distance(common, kn_to);
> > +	depth_from = kernfs_node_distance(common, kn_from);
> > +
> > +	for (i = 0; i < depth_from; i++) {
> > +		if (len + plen + 1 > buflen)
> > +			return NULL;
> > +		strcpy(p, parent_str);
> > +		p += plen;
> > +		len += plen;
> > +	}
> > +
> > +	/* Calculate how many bytes we need for the rest */
> > +	for (kn = kn_to; kn != common; kn = kn->parent)
> > +		nlen += strlen(kn->name) + 1;
> > +
> > +	if (len + nlen + 1 > buflen)
> > +		return NULL;
> 
> Hmm... if we do this anyway, maybe we can make the function behave
> more like other string formatting function (strlcpy) and return the
> would-be length instead where ret >= len indicates truncation?

I can change that, but the callers right now don't re-try with
larger buffer anyway, so this would actually complicate them just
a smidgeon.  Would you want them changed to do that?  (pr_cont_kernfs_path
right now writes into a static char[] for instance)
