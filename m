From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 1/1] destroy_creds.2: new page documenting destroy_creds()
Date: Fri, 11 Aug 2017 07:18:25 -0400
Message-ID: <1502450305.4950.4.camel@redhat.com>
References: <20170807212355.29127-1-kolga@netapp.com>
         <20170807212355.29127-3-kolga@netapp.com>
         <1502281848.12841.2.camel@redhat.com>
         <87378yr2sx.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87378yr2sx.fsf-wvvUuzkyo1HefUI2i7LXDhCRmIWqnp/j@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>, Olga Kornievskaia <kolga-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2017-08-11 at 17:17 +1000, NeilBrown wrote:
> On Wed, Aug 09 2017, Jeff Layton wrote:
> ....
> > 
> > Thanks, that helps a bit. I'm less clear on what the higher-level
> > vision is here though:
> > 
> > Are we all going to be running scripts on logout that scrape
> > /proc/mounts and run fslogout on each? Will this be added to kdestroy?
> > 
> > Or are you aiming to have KCM do this on some trigger? (see:
> > https://fedoraproject.org/wiki/Changes/KerberosKCMCache)
> > 
> > Also, doing this per-mount seems wrong to me. Shouldn't this be done on
> > a per-net-namespace basis or maybe even globally?
> 
> Having looked at the code, I think this is invalidating cached
> credentials globally -- or at least, globally for all filesystems that
> use sunrpc.
> 
> I actually question the premise for wanting to do this.  Tickets have a
> timeout and will expire.  Any code that is allowed to get a ticket, can
> hold on to it as long as it likes - but it will cease to work after the
> expiry time.  Hunting out all the places that a key might be cached, and
> invalidating them, seems to deviate from the model.  If you are concerned
> about leaving credentials around where they can theoretically be
> misused, then set a smaller expiry time.
> 
> What is the threat-model that this change is supposed to guard against?
> 
> Looking that the syscall itself:
>  1/ why restrict the call to directories only?
>  2/ Every new syscall should have a 'flags' argument, because you never
>     know when you'll need one.
> 

I have some of the same concerns. For instance, we don't kill off ssh
sessions that were established with krb5 just because the credcache was
destroyed. RPC is a bit different since we authenticate every call, but
is this fundamentally different from keeping an ssh session around that
was established before the credcache was destroyed?

Are we just getting tickets with too long a lifetime here? Maybe we just
need to be more cavalier about destroying cached creds on some event or
on a more timely basis?

Also, the whole gssapi credcache in the kernel is showing its age a bit.
struct auth_cred has had this over it for about as long as I've been
doing kernel work:

    /* Work around the lack of a VFS credential */

We've had struct cred for ages now.

David and I were chatting about this the other day and were wondering if
we could change the RPC gssapi code to cache credentials in one of the
keyrings in struct cred. Then, once the struct cred goes away, the key
would go away as well. It wouldn't be destroyed on kdestroy, but once
the last process with those creds exits, they would go away.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
