From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] statx: add STATX_ATTRIBUTES flag
Date: Thu, 18 Oct 2018 16:22:35 +0100
Message-ID: <1684.1539876155@warthog.procyon.org.uk>
References: <20181018131125.6303-3-mszeredi@redhat.com> <20181018131125.6303-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018131125.6303-3-mszeredi@redhat.com>
Content-ID: <1683.1539876155.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> wrote:

> +	/* Having anything in attributes_mask means attributes are valid. */
> +	if (tmp.stx_attributes_mask)
> +		tmp.stx_mask |= STATX_ATTRIBUTES;

That would be superfluous, since userspace can make this check too.

Note that fsinfo() might inform you better - if and when it arrives.

David
