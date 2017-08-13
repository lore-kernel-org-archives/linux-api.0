From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 1/1] destroy_creds.2: new page documenting destroy_creds()
Date: Sun, 13 Aug 2017 07:38:59 -0400
Message-ID: <1502624339.4839.4.camel@redhat.com>
References: <20170807212355.29127-1-kolga@netapp.com>
         <20170807212355.29127-3-kolga@netapp.com>
         <1502281848.12841.2.camel@redhat.com>
         <87378yr2sx.fsf@notabene.neil.brown.name>
         <1502450305.4950.4.camel@redhat.com>
         <E127503D-3DFC-4FD3-99F6-012D100C168B@netapp.com>
         <1502461341.4762.1.camel@redhat.com>
         <1502464329.5352.1.camel@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502464329.5352.1.camel-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, "kolga-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org" <kolga-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: "dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "neilb-IBi9RG/b67k@public.gmane.org" <neilb-IBi9RG/b67k@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2017-08-11 at 15:12 +0000, Trond Myklebust wrote:
> On Fri, 2017-08-11 at 10:22 -0400, Jeff Layton wrote:
> > I think I wasn't clear here. I'm not proposing that you move everyone
> > to
> > KEYRING: credcaches. This would not be a visible change to userland.
> > We'd still use rpc.gssd to upcall for creds.
> > 
> > What I'm saying is that instead of storing the creds in a hashtable
> > like
> > we do today, we'd just stash them in one of the keyrings hanging off
> > of
> > struct cred.
> > 
> > Change all of the authgss_ops operations to do query/store from the
> > appropriate keyring directly. With that, the effective lifetime of
> > GSSAPI creds would be bounded by the lifetime of the keyrings that
> > hold
> > references to it.
> > 
> > We'd probably need a new key_type for this to ensure that this
> > couldn't
> > be manipulated directly from userland. Or...maybe you'd still want to
> > allow userland to destroy the creds? No need for a new syscall with
> > that
> > -- they can just do a "keyctl unlink". There are a lot of options
> > here.
> > 
> > It's a non-trivial amount of work though (rpcauth_lookupcred() on
> > down
> > would probably need to be reworked) and I haven't looked at it
> > detail.
> > Still, it seems like it could be a more modern and cleaner design
> > than
> > what we have today.
> > 
> 
> The main annoyance with going from a global to a local cache such as
> the keyrings is that it makes comparing credentials a lot more work.
> Today, because the credentials are essentially unique per server, we
> just do pointer comparisons. Once we have non-global caches, we would
> need to do more elaborate comparisons to ensure that the uid, gid, and
> list of groups match.
> That's also why we never made the leap to using 'struct cred', btw...


Ok, it does seem better to have a global cache from that standpoint.
Still, a new syscall for this doesn't seem very elegant. I also worry a
bit about writeback here too (like David and Neil have pointed out).

What about changing how we hold references on these objects instead?

After we look up an auth token in e.g. rpcauth_lookupcred, take a
reference to it and stash a pointer to it somewhere in the cred.
Possibly in the thread or process keyrings, but it may work better
elsewhere.

When we go to look up creds from that thread in the future, we can get
to it directly (which is a nice bonus). When the cred is destroyed
(usually on process destruction), we'd drop the reference to the object,
which would drop the reference to the global cache object.

The global cache could then be changed to have a pretty short timeout (a
few seconds?) and reap the object soon afterward when there are no more
active processes that have used it.

It's a bit more work and we might need to grow struct cred to handle it
(maybe give it its own keyring?), but it seems like that might be a
cleaner solution than giving userland knobs to manage the kernel's
caches.
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
