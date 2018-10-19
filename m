From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 4/5] statx: don't clear STATX_ATIME on SB_RDONLY
Date: Fri, 19 Oct 2018 16:40:10 +0100
Message-ID: <16708.1539963610@warthog.procyon.org.uk>
References: <20181019122049.27121-4-mszeredi@redhat.com> <20181019122049.27121-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019122049.27121-4-mszeredi@redhat.com>
Content-ID: <16707.1539963610.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> wrote:

> IS_NOATIME(inode) is defined as __IS_FLG(inode, SB_RDONLY|SB_NOATIME), so
> generic_fillattr() will clear STATX_ATIME from the result_mask if the super
> block is marked read only.
> 
> This was probably not the intention, so fix to only clear STATX_ATIME if
> the fs doesn't support atime at all.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
