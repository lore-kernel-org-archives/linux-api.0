From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Wed, 23 Dec 2015 11:08:54 -0500
Message-ID: <20151223160854.GF5003@mtj.duckdns.org>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
 <1450844609-9194-2-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450844609-9194-2-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, "Serge E. Hallyn" <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello, Serge.

On Tue, Dec 22, 2015 at 10:23:22PM -0600, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> @@ -164,18 +286,39 @@ void pr_cont_kernfs_name(struct kernfs_node *kn)
>  void pr_cont_kernfs_path(struct kernfs_node *kn)
>  {
>  	unsigned long flags;
> -	char *p;
> +	char *p = NULL;
> +	int sz1, sz2;
>  
>  	spin_lock_irqsave(&kernfs_rename_lock, flags);
>  
> -	p = kernfs_path_locked(kn, kernfs_pr_cont_buf,
> -			       sizeof(kernfs_pr_cont_buf));
> -	if (p)
> -		pr_cont("%s", p);
> -	else
> -		pr_cont("<name too long>");
> +	sz1 = kernfs_path_from_node_locked(kn, NULL, kernfs_pr_cont_buf,
> +					   sizeof(kernfs_pr_cont_buf));
> +	if (sz1 < 0) {
> +		pr_cont("(error)");
> +		goto out;
> +	}
> +
> +	if (sz1 < sizeof(kernfs_pr_cont_buf)) {
> +		pr_cont("%s", kernfs_pr_cont_buf);
> +		goto out;
> +	}
> +
> +	p = kmalloc(sz1 + 1, GFP_NOFS);

We can't do GFP_NOFS allocation while holding a spinlock and we don't
want to do atomic allocation here either.  I think it'd be best to
keep using the static buffer.

Thanks.

-- 
tejun
