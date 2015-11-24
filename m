From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Tue, 24 Nov 2015 11:16:30 -0500
Message-ID: <20151124161630.GL17033@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-2-git-send-email-serge@hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447703505-29672-2-git-send-email-serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Nov 16, 2015 at 01:51:38PM -0600, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org wrote:
> +static char * __must_check kernfs_path_from_node_locked(
> +	struct kernfs_node *kn_from,
> +	struct kernfs_node *kn_to,
> +	char *buf,
> +	size_t buflen)
> +{
> +	char *p = buf;
> +	struct kernfs_node *kn;
> +	size_t depth_from = 0, depth_to, d;
>  	int len;
>  
> +	/* We atleast need 2 bytes to write "/\0". */
> +	BUG_ON(buflen < 2);

I don't think this is BUG worthy.  Just return NULL?  Also, the only
reason the original function returned char * was because the starting
point may not be the start of the buffer which helps keeping the
implementation simple.  If this function is gonna be complex anyway, a
better approach would be returning ssize_t and implement a simliar
behavior to strlcpy().

> +	/* Short-circuit the easy case - kn_to is the root node. */
> +	if ((kn_from == kn_to) || (!kn_from && !kn_to->parent)) {
> +		*p = '/';
> +		*(p + 1) = '\0';

Hmm... so if kn_from == kn_to, the output is "/"?

> +		return p;
> +	}
> +
> +	/* We can find the relative path only if both the nodes belong to the
> +	 * same kernfs root.
> +	 */
> +	if (kn_from) {
> +		BUG_ON(kernfs_root(kn_from) != kernfs_root(kn_to));

Ditto, just return NULL and maybe trigger WARN_ON_ONCE().

> +		depth_from = kernfs_node_depth(kn_from);
> +	}
> +
> +	depth_to = kernfs_node_depth(kn_to);
> +
> +	/* We compose path from left to right. So first write out all possible
                                             ^
					     , so

> +	 * "/.." strings needed to reach from 'kn_from' to the common ancestor.
> +	 */

Please fully-wing multiline comments.

> +	if (kn_from) {
> +		while (depth_from > depth_to) {
> +			len = strlen("/..");

Maybe do something like the following instead?

			const char parent_str[] = "/..";
			size_t len = sizeof(parent_str) - 1;

> +			if ((buflen - (p - buf)) < len + 1) {
> +				/* buffer not big enough. */
> +				buf[0] = '\0';
> +				return NULL;
> +			}
> +			memcpy(p, "/..", len);
> +			p += len;
> +			*p = '\0';
> +			--depth_from;
> +			kn_from = kn_from->parent;
>  		}
> +
> +		d = depth_to;
> +		kn = kn_to;
> +		while (depth_from < d) {
> +			kn = kn->parent;
> +			d--;
> +		}
> +
> +		/* Now we have 'depth_from == depth_to' at this point. Add more

Ditto with winging.

> +		 * "/.."s until we reach common ancestor. In the worst case,
> +		 * root node will be the common ancestor.
> +		 */
> +		while (depth_from > 0) {
> +			/* If we reached common ancestor, stop. */
> +			if (kn_from == kn)
> +				break;
> +			len = strlen("/..");
> +			if ((buflen - (p - buf)) < len + 1) {
> +				/* buffer not big enough. */
> +				buf[0] = '\0';
> +				return NULL;
> +			}
> +			memcpy(p, "/..", len);
> +			p += len;
> +			*p = '\0';
> +			--depth_from;
> +			kn_from = kn_from->parent;
> +			kn = kn->parent;
> +		}

Hmmm... I wonder whether this and the above block can be merged.
Wouldn't it be simpler to calculate common ancestor and generate
/.. till it reached that point?

Thanks.

-- 
tejun
