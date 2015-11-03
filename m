From: Trond Myklebust <trond.myklebust@primarydata.com>
Subject: Re: [PATCH v13 45/51] sunrpc: Allow to demand-allocate pages to
 encode into
Date: Tue, 3 Nov 2015 11:25:46 -0500
Message-ID: <CAHQdGtScoRb-722ES168O8tkp-Rbvwe6bZ=70WwgiXpCC3vsHw@mail.gmail.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-46-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1446563847-14005-46-git-send-email-agruenba@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 3, 2015 at 10:17 AM, Andreas Gruenbacher
<agruenba@redhat.com> wrote:
> When encoding large, variable-length objects such as acls into xdr_bufs,
> it is easier to allocate buffer pages on demand rather than precomputing
> the required buffer size.
>

NACK. We're not doing allocations from inside the XDR encoders. This
can and should be done before calling into the SUNRPC layer.

Trond
