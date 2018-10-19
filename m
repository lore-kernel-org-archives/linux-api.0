From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 6/5] statx: add STATX_RESULT_MASK flag
Date: Fri, 19 Oct 2018 16:59:48 +0100
Message-ID: <18142.1539964788@warthog.procyon.org.uk>
References: <20181019143932.6697-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019143932.6697-1-mszeredi@redhat.com>
Content-ID: <18141.1539964788.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> wrote:

> FUSE needs this, because it uses legacy inode initialization, that doesn't
> return a result_mask, so needs a refresh when caller asks for it with
> statx().

Can't you just make it up in fuse?  Presumably, fuse doesn't support any of
the non-basic statx fields either?

> It might make sense later to promote this to a proper statx mask flag and
> return it in stx_mask to userspace.

That sounds kind of recursive - a bit in stx_mask would be saying whether or
not stx_mask can be used.

Besides, what would it mean if that bit says you can't use stx_mask?  None of
the stx_* fields are valid?

> +#define STATX_RESULT_MASK STATX__RESERVED

Please don't use that bit.


Sorry, this patch doesn't make sense.  Just set result_mask to
STATX_BASIC_STATS in fuse_fill_attr().

David
