From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 5/5] nfs: don't clear STATX_ATIME from result_mask
Date: Fri, 19 Oct 2018 16:44:44 +0100
Message-ID: <17057.1539963884@warthog.procyon.org.uk>
References: <20181019122049.27121-5-mszeredi@redhat.com> <20181019122049.27121-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019122049.27121-5-mszeredi@redhat.com>
Content-ID: <17056.1539963884.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>, Trond Myklebust <trond.myklebust@primarydata.com>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> wrote:

> As per statx(2) man page only clear out flags that are unsupported by the
> fs or have an unrepresentable value.  Atime is supported by NFS as long as
> it's supported on the server.
> 
> So the STATX_ATIME flag should not be cleared in the result_mask if the
> operation was requested on a MNT_NOATIME or MNT_NODIRATIME mount.
> 
> This patch doesn't change the revalidation algorithm in any way, just the
> clearing of flags in stat->result_mask.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Fixes: 9ccee940bd5b ("Support statx() mask and query flags parameters")
> Cc: Trond Myklebust <trond.myklebust@primarydata.com>

Reviewed-by: David Howells <dhowells@redhat.com>
