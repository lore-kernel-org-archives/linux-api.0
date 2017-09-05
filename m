From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] KEYS: make keyctl_invalidate() also require Setattr permission
Date: Tue, 05 Sep 2017 10:54:55 +0100
Message-ID: <13221.1504605295@warthog.procyon.org.uk>
References: <20170816211403.121920-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170816211403.121920-1-ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-ID: <13220.1504605295.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paul Crowley <paulcrowley-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Ryo Hashimoto <hashimoto-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This patch fixes the flaw by requiring both Search and Setattr permission to
> invalidate a key rather than just Search permission.

I'm not sure I agree.  The problem is that you then have to grant someone
Setattr permission for them to be able to do this, which then opens up a whole
host of other things they can also do.

> Requiring Setattr permission is appropriate because Setattr permission also
> allows revoking (via keyctl_revoke()) or expiring (via keyctl_set_timeout())
> the key, which also make the key inaccessible regardless of how many
> keyrings it is in.

Note that setting the expiry time is not really equivalent to revokation in
this regard as setting the expiry time is something you do when setting up a
key, whereas revokation is something you do later to kill a key off.

> Alternatively, the problem could be solved by requiring Write permission.

That's not really a viable solution as things stand.  You can't turn Write
permission on on a key whose type doesn't have an ->update() method (though
this could be changed) and it also opens up a key to being modified.

How about another solution:

 (1) I add a flag to a key to say that it can be invalidated and a keyctl to
     change that flag.

 (2) I add a new key type op called ->allow_invalidation() that allows key
     types to govern separately who is allowed to invalidate keys of that
     type.

     So, for instance, DNS record invalidation would require CAP_NET_ADMIN.

 (3) Allow keyrings to be cleared by users who don't have Write permission but
     do have other permission, such as CAP_NET_ADMIN.  This would need to be
     granted on a per-keyring basis.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
