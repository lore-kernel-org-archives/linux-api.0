From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Wed, 9 Dec 2015 16:38:06 -0500
Message-ID: <20151209213806.GP30240@mtj.duckdns.org>
References: <1449689341-28742-1-git-send-email-serge.hallyn@ubuntu.com>
 <1449689341-28742-2-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1449689341-28742-2-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, "Serge E. Hallyn" <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello, Serge.

On Wed, Dec 09, 2015 at 01:28:54PM -0600, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> +/* kernfs_node_depth - compute depth from @from to @to */
> +static size_t kernfs_depth(struct kernfs_node *from, struct kernfs_node *to)
...
> +char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
> +{
> +	return kernfs_path_from_node(NULL, kn, buf, buflen);
> +}
...
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index 5d4e9c4..d025ebd 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -267,6 +267,9 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
>  
>  int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen);
>  size_t kernfs_path_len(struct kernfs_node *kn);
> +char * __must_check kernfs_path_from_node(struct kernfs_node *root_kn,
> +					  struct kernfs_node *kn, char *buf,
> +					  size_t buflen);

I think I commented on the same thing before, but I think it'd make
more sense to put @from after @to and the prototype is using @root_kn
which is a bit confusing.  Was converting the path functions to return
length too much work?  If so, that's fine but please explain what
decisions were made.

I skimmed through the series and spotted several other review points
which didn't get addressed.  Can you please go over the previous
review cycle and address the review points?

Thanks.

-- 
tejun
