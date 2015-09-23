From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC v7 26/41] richacl: Apply the file masks to a richacl
Date: Wed, 23 Sep 2015 16:33:57 -0400
Message-ID: <20150923203357.GC30521@fieldses.org>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
 <1441448856-13478-27-git-send-email-agruenba@redhat.com>
 <20150922191108.GC19127@fieldses.org>
 <20150923191832.GA29577@fieldses.org>
 <CAHc6FU4YkLJUAQEfH7CG8sAzXYbGzg_ibyT7m26Fc1p26v1=VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHc6FU4YkLJUAQEfH7CG8sAzXYbGzg_ibyT7m26Fc1p26v1=VQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Gruenbacher <agruen-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 23, 2015 at 10:29:40PM +0200, Andreas Gruenbacher wrote:
> 2015-09-23 21:18 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> > On Tue, Sep 22, 2015 at 03:11:08PM -0400, bfields wrote:
> >> user aces like owner aces what you intended to do,
> >> and if so, why?
> >
> > That does look wrong to me; in an example like:
> >
> >         file owner bfields
> >         mask 0700, not WRITE_THROUGH
> >         bfields:rwx::allow
> >
> > The permission algorithm grants nothing to anyone, but it looks to me
> > like richacl_apply_masks just leaves this as
> >
> >         bfields:rwx::allow
> >
> > but it would give the right result (an empty/deny-all ACL) if it weren't
> > for this odd case here.
> 
> In POSIX ACLs, only the entry that best matches the process determines
> the access permissions. For the file owner, this would always be the
> "user::" entry, and such an entry always exists.
> 
> In richacls, permissions from multiple entries do accumulate; the
> permission check algorithm does not pick a "best match". When bfields
> owns a file and a "bfields:rwx::allow" entry exists, denying rwx
> access to bfields would be very surprising.

The same could be said if there's a group-i-belong-to:rwx::allow entry,
do we make that exception too?

--b.

> It makes more sense to put
> user entries that match the current owner into the owner class, and
> apply the owner mask instead of the group mask. This was working in an
> earlier version but apparently broke at some point.
> 
> So the result that richacl_apply_masks computes here is correct, and
> the permission check algorithm needs a little fix.
> 
> Thanks,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
