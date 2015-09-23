From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC v7 22/41] richacl: Propagate everyone@ permissions to other
 aces
Date: Tue, 22 Sep 2015 21:46:30 -0400
Message-ID: <20150923014630.GB23581@fieldses.org>
References: <CAHc6FU5Ug3rN2-znFeABpdn+LCHgvzOnSRB4BCepNS6mToJVZg@mail.gmail.com>
 <1441448856-13478-1-git-send-email-agruenba@redhat.com>
 <1441448856-13478-23-git-send-email-agruenba@redhat.com>
 <20150918215611.GD22671@fieldses.org>
 <20150921192441.GA12968@fieldses.org>
 <1442972384-22757-1-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442972384-22757-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 23, 2015 at 03:39:44AM +0200, Andreas Gruenbacher wrote:
> Here are my improvements; hope that helps ...

Yes, looks good, thanks!--b.

> 
> Thanks,
> Andreas
> 
> diff --git a/fs/richacl_compat.c b/fs/richacl_compat.c
> index 9b76fc0..21af9a0 100644
> --- a/fs/richacl_compat.c
> +++ b/fs/richacl_compat.c
> @@ -351,26 +351,26 @@ richacl_propagate_everyone(struct richacl_alloc *alloc)
>  	struct richace *ace;
>  	unsigned int owner_allow, group_allow;
>  
> -	/*
> -	 * If the owner mask contains permissions which are not in the group
> -	 * mask, the group mask contains permissions which are not in the other
> -	 * mask, or the owner class contains permissions which are not in the
> -	 * other mask, we may need to propagate permissions up from the
> -	 * everyone@ allow ace.  The third condition is implied by the first
> -	 * two.
> -	 */
> -	if (!((acl->a_owner_mask & ~acl->a_group_mask) ||
> -	      (acl->a_group_mask & ~acl->a_other_mask)))
> -		return 0;
>  	if (!acl->a_count)
>  		return 0;
>  	ace = acl->a_entries + acl->a_count - 1;
>  	if (richace_is_inherit_only(ace) || !richace_is_everyone(ace))
>  		return 0;
>  
> +	/*
> +	 * Permissions the owner and group class are granted through the
> +	 * trailing everyone@ allow ace.
> +	 */
>  	owner_allow = ace->e_mask & acl->a_owner_mask;
>  	group_allow = ace->e_mask & acl->a_group_mask;
>  
> +	/*
> +	 * If the group or other masks hide permissions which the owner should
> +	 * be allowed, we need to propagate those permissions up.  Otherwise,
> +	 * those permissions may be lost when applying the other mask to the
> +	 * trailing everyone@ allow ace, or when isolating the group class from
> +	 * the other class through additional deny aces.
> +	 */
>  	if (owner_allow & ~(acl->a_group_mask & acl->a_other_mask)) {
>  		/* Propagate everyone@ permissions through to owner@. */
>  		who.e_id.special = RICHACE_OWNER_SPECIAL_ID;
> @@ -379,6 +379,11 @@ richacl_propagate_everyone(struct richacl_alloc *alloc)
>  		acl = alloc->acl;
>  	}
>  
> +	/*
> +	 * If the other mask hides permissions which the group class should be
> +	 * allowed, we need to propagate those permissions up to the owning
> +	 * group and to all other members in the group class.
> +	 */
>  	if (group_allow & ~acl->a_other_mask) {
>  		int n;
>  
> @@ -399,16 +404,15 @@ richacl_propagate_everyone(struct richacl_alloc *alloc)
>  			    richace_is_owner(ace) ||
>  			    richace_is_group(ace))
>  				continue;
> -			if (richace_is_allow(ace) || richace_is_deny(ace)) {
> -				/*
> -				 * Any inserted entry will end up below the
> -				 * current entry
> -				 */
> -				if (__richacl_propagate_everyone(alloc, ace,
> -								 group_allow))
> -					return -1;
> -				acl = alloc->acl;
> -			}
> +
> +			/*
> +			 * Any inserted entry will end up below the current
> +			 * entry.
> +			 */
> +			if (__richacl_propagate_everyone(alloc, ace,
> +							 group_allow))
> +				return -1;
> +			acl = alloc->acl;
>  		}
>  	}
>  	return 0;
> -- 
> 2.4.3
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
