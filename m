From: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] KEYS: make keyctl_invalidate() also require Setattr
 permission
Date: Tue, 5 Sep 2017 11:32:50 -0700
Message-ID: <20170905183250.GA92687@gmail.com>
References: <20170816211403.121920-1-ebiggers3@gmail.com>
 <13221.1504605295@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <13221.1504605295-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paul Crowley <paulcrowley-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Ryo Hashimoto <hashimoto-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi David,

On Tue, Sep 05, 2017 at 10:54:55AM +0100, David Howells wrote:
> Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > This patch fixes the flaw by requiring both Search and Setattr permission to
> > invalidate a key rather than just Search permission.
> 
> I'm not sure I agree.  The problem is that you then have to grant someone
> Setattr permission for them to be able to do this, which then opens up a whole
> host of other things they can also do.
> 

True, but Setattr permission has already been overloaded to allow several
different types of modifications, and it makes *much* more sense than Search
permission which should not allow any modifications.  And in practice I expect
people care more about whether modifications are permitted or not, than the
details of the finer-grained permissions.

> > Requiring Setattr permission is appropriate because Setattr permission also
> > allows revoking (via keyctl_revoke()) or expiring (via keyctl_set_timeout())
> > the key, which also make the key inaccessible regardless of how many
> > keyrings it is in.
> 
> Note that setting the expiry time is not really equivalent to revokation in
> this regard as setting the expiry time is something you do when setting up a
> key, whereas revokation is something you do later to kill a key off.
> 

Sort of, but actually keyctl_set_timeout() can be called at any time, and the
timeout can be set to as little as 1 second.  So I don't see how keyctl_revoke()
is that much different, fundamentally.

> How about another solution:
> 
>  (1) I add a flag to a key to say that it can be invalidated and a keyctl to
>      change that flag.

And who would have permission to change that flag?  It seems to be the same
problem again.

> 
>  (2) I add a new key type op called ->allow_invalidation() that allows key
>      types to govern separately who is allowed to invalidate keys of that
>      type.
> 
>      So, for instance, DNS record invalidation would require CAP_NET_ADMIN.

What would the behavior be if ->allow_invalidation() was not supplied?  In other
words, would the purpose of this be to lock down invalidation of dns_resolver
keys, or to restrict invalidation to *only* dns_resolver keys?

> 
>  (3) Allow keyrings to be cleared by users who don't have Write permission but
>      do have other permission, such as CAP_NET_ADMIN.  This would need to be
>      granted on a per-keyring basis.

Granted by who, and how?  And do you mean keyctl_clear(), or
keyctl_invalidate()?

- Eric
