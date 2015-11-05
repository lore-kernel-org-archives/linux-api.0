From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v13 45/51] sunrpc: Allow to demand-allocate pages to
 encode into
Date: Thu, 5 Nov 2015 12:07:05 +0100
Message-ID: <CAHc6FU5xkjWJeGFR5mO8+OAEMwwU6yWK7H8CV1fn5dk-LS23-g@mail.gmail.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-46-git-send-email-agruenba@redhat.com>
	<CAHQdGtScoRb-722ES168O8tkp-Rbvwe6bZ=70WwgiXpCC3vsHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHQdGtScoRb-722ES168O8tkp-Rbvwe6bZ=70WwgiXpCC3vsHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Trond,

On Tue, Nov 3, 2015 at 5:25 PM, Trond Myklebust
<trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org> wrote:
> On Tue, Nov 3, 2015 at 10:17 AM, Andreas Gruenbacher
> <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> When encoding large, variable-length objects such as acls into xdr_bufs,
>> it is easier to allocate buffer pages on demand rather than precomputing
>> the required buffer size.
>
> NACK. We're not doing allocations from inside the XDR encoders. This
> can and should be done before calling into the SUNRPC layer.

an XDR-encoded ACL can be up to 64k (16 pages) in size. In practice,
large ACLs like that will almost never occur and almost all ACLs will
fit into a single page though.

The XDR-encoded ACL contains strings for the user and group names
which need to be looked up when the idmapper is used. Those lookups
are somewhat expensive; in addition, the lookup results can change
over time. When precomputing the size, allocating space, and then
encoding the ACL, we could run out of space when encoding.

So we could always allocate the maximum 16 pages, encode the acl, and
free the unused pages. This would be rather wasteful though.

Given how simple it is to allocate pages as we go, this seems the
better choice here. This doesn't break any existing code either; NULL
page pointers would have oopsed in xdr_get_next_encode_buffer before.

>From the memory management point of view, there is no difference in
preallocating GFP_NOFS pages and allocating them on demand; the pages
are allocated in the same task and locking context in both cases.

So could you please explain why you object to this change?

Thanks,
Andreas
