From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 3/5] statx: add STATX_ATTRIBUTES flag
Date: Fri, 19 Oct 2018 16:36:12 +0100
Message-ID: <16444.1539963372@warthog.procyon.org.uk>
References: <20181019122049.27121-3-mszeredi@redhat.com> <20181019122049.27121-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019122049.27121-3-mszeredi@redhat.com>
Content-ID: <16443.1539963372.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> wrote:

> FUSE will want to know if stx_attributes is interesting or not, because
> there's a non-zero cost of retreiving it.
> 
> This just a "want" flag, since stx_attributes_mask already indicates
> whether we "got" stx_attributes or not.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>

Subject to fixing the comment on STAT_ALL:

Acked-by: David Howells <dhowells@redhat.com>
