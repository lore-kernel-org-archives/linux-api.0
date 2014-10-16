From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv1 1/8] kernfs: Add API to generate relative kernfs path
Date: Thu, 16 Oct 2014 18:07:36 +0200
Message-ID: <20141016160736.GA1392@mail.hallyn.com>
References: <adityakali-cgroupns>
 <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-2-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1413235430-22944-2-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> The new function kernfs_path_from_node() generates and returns
> kernfs path of a given kernfs_node relative to a given parent
> kernfs_node.
> 
> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

(with or without my comment below taken)

> ---
>  fs/kernfs/dir.c        | 53 ++++++++++++++++++++++++++++++++++++++++----------
>  include/linux/kernfs.h |  3 +++
>  2 files changed, 46 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> index a693f5b..8655485 100644
> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c
> @@ -44,14 +44,24 @@ static int kernfs_name_locked(struct kernfs_node *kn, char *buf, size_t buflen)
>  	return strlcpy(buf, kn->parent ? kn->name : "/", buflen);
>  }
>  
> -static char * __must_check kernfs_path_locked(struct kernfs_node *kn, char *buf,
> -					      size_t buflen)
> +static char * __must_check kernfs_path_from_node_locked(
> +	struct kernfs_node *kn_root,
> +	struct kernfs_node *kn,
> +	char *buf,
> +	size_t buflen)
>  {
>  	char *p = buf + buflen;
>  	int len;
>  
> +	BUG_ON(!buflen);
> +
>  	*--p = '\0';
>  
> +	if (kn == kn_root) {
> +		*--p = '/';
> +		return p;
> +	}
> +
>  	do {
>  		len = strlen(kn->name);
>  		if (p - buf < len + 1) {
> @@ -63,6 +73,8 @@ static char * __must_check kernfs_path_locked(struct kernfs_node *kn, char *buf,
>  		memcpy(p, kn->name, len);
>  		*--p = '/';
>  		kn = kn->parent;
> +		if (kn == kn_root)
> +			break;

I wonder if it would be clearer if you instead changed the while condition, i.e.

	} while (kn && kn != kn_root && kn_parent);

i.e .it's not a special condition, just a part of the expected flow.

>  	} while (kn && kn->parent);
>  
>  	return p;
> @@ -92,26 +104,47 @@ int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
>  }
>  
>  /**
> - * kernfs_path - build full path of a given node
> + * kernfs_path_from_node - build path of node @kn relative to @kn_root.
> + * @kn_root: parent kernfs_node relative to which we need to build the path
>   * @kn: kernfs_node of interest
> - * @buf: buffer to copy @kn's name into
> + * @buf: buffer to copy @kn's path into
>   * @buflen: size of @buf
>   *
> - * Builds and returns the full path of @kn in @buf of @buflen bytes.  The
> - * path is built from the end of @buf so the returned pointer usually
> + * Builds and returns @kn's path relative to @kn_root. @kn_root is expected to
> + * be parent of @kn at some level. If this is not true or if @kn_root is NULL,
> + * then full path of @kn is returned.
> + * The path is built from the end of @buf so the returned pointer usually
>   * doesn't match @buf.  If @buf isn't long enough, @buf is nul terminated
>   * and %NULL is returned.
>   */
> -char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
> +char *kernfs_path_from_node(struct kernfs_node *kn_root, struct kernfs_node *kn,
> +			    char *buf, size_t buflen)
>  {
>  	unsigned long flags;
>  	char *p;
>  
>  	spin_lock_irqsave(&kernfs_rename_lock, flags);
> -	p = kernfs_path_locked(kn, buf, buflen);
> +	p = kernfs_path_from_node_locked(kn_root, kn, buf, buflen);
>  	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
>  	return p;
>  }
> +EXPORT_SYMBOL_GPL(kernfs_path_from_node);
> +
> +/**
> + * kernfs_path - build full path of a given node
> + * @kn: kernfs_node of interest
> + * @buf: buffer to copy @kn's name into
> + * @buflen: size of @buf
> + *
> + * Builds and returns the full path of @kn in @buf of @buflen bytes.  The
> + * path is built from the end of @buf so the returned pointer usually
> + * doesn't match @buf.  If @buf isn't long enough, @buf is nul terminated
> + * and %NULL is returned.
> + */
> +char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
> +{
> +	return kernfs_path_from_node(NULL, kn, buf, buflen);
> +}
>  EXPORT_SYMBOL_GPL(kernfs_path);
>  
>  /**
> @@ -145,8 +178,8 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
>  
>  	spin_lock_irqsave(&kernfs_rename_lock, flags);
>  
> -	p = kernfs_path_locked(kn, kernfs_pr_cont_buf,
> -			       sizeof(kernfs_pr_cont_buf));
> +	p = kernfs_path_from_node_locked(NULL, kn, kernfs_pr_cont_buf,
> +					 sizeof(kernfs_pr_cont_buf));
>  	if (p)
>  		pr_cont("%s", p);
>  	else
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index 30faf79..3c2be75 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -258,6 +258,9 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
>  }
>  
>  int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen);
> +char * __must_check kernfs_path_from_node(struct kernfs_node *root_kn,
> +					  struct kernfs_node *kn, char *buf,
> +					  size_t buflen);
>  char * __must_check kernfs_path(struct kernfs_node *kn, char *buf,
>  				size_t buflen);
>  void pr_cont_kernfs_name(struct kernfs_node *kn);
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
