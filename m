From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/8] cgroup: export cgroup_get() and cgroup_put()
Date: Tue, 24 Nov 2015 11:30:56 -0500
Message-ID: <20151124163056.GO17033@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
	<1447703505-29672-5-git-send-email-serge@hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447703505-29672-5-git-send-email-serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Nov 16, 2015 at 01:51:41PM -0600, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org wrote:
> From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> move cgroup_get() and cgroup_put() into cgroup.h so that
> they can be called from other places.
> 
> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  include/linux/cgroup.h |   21 +++++++++++++++++++++
>  kernel/cgroup.c        |   22 ----------------------
>  2 files changed, 21 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 29f0b02..99096be 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -231,6 +231,27 @@ void css_task_iter_end(struct css_task_iter *it);
>  #define css_for_each_descendant_post(pos, css)				\
>  	for ((pos) = css_next_descendant_post(NULL, (css)); (pos);	\
>  	     (pos) = css_next_descendant_post((pos), (css)))

Please insert a blank line here.

> +/* convenient tests for these bits */

And I don't think the comment makes sense here.

> +static inline bool cgroup_is_dead(const struct cgroup *cgrp)
> +{
> +	return !(cgrp->self.flags & CSS_ONLINE);
> +}
> +
> +static inline void cgroup_get(struct cgroup *cgrp)
> +{
> +	WARN_ON_ONCE(cgroup_is_dead(cgrp));
> +	css_get(&cgrp->self);
> +}
> +
> +static inline bool cgroup_tryget(struct cgroup *cgrp)
> +{
> +	return css_tryget(&cgrp->self);
> +}
> +
> +static inline void cgroup_put(struct cgroup *cgrp)
> +{
> +	css_put(&cgrp->self);
> +}

So these are being exposed for cgroup NS support.  Hmmm... idk, does
cgroup NS support needs to be in a spearate file?  The added amount
isn't that big.  If we split cgroup.c, I'd much prefer to have
cgroup-internal.h for internally shared stuff than pushing them out to
cgroup.h.

Thanks.

-- 
tejun
