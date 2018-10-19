From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 2/5] uapi: deprecate STATX_ALL
Date: Fri, 19 Oct 2018 16:35:22 +0100
Message-ID: <16382.1539963322@warthog.procyon.org.uk>
References: <20181019122049.27121-2-mszeredi@redhat.com> <20181019122049.27121-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019122049.27121-2-mszeredi@redhat.com>
Content-ID: <16381.1539963322.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> wrote:

> +/*
> + * This is deprecated, and shall remain the same value in the future.  To avoid
> + * confusion please use the equivalent (STATX_BASIC_STATS | STATX_BTIME)
> + * instead.
> + */
> +#define STATX_ALL		0x00000fffU

The comment is misleading.  STATX_ALL is *not* equivalent to
STATX_BASIC_STATS | STATX_BTIME, even though it might be numerically the
same.  You would need to update the comment when you add STATX_ATTRIBUTES
to mention that also.

Apart from that, I'm okay with this.

Further, please provide a manpage update also.

David
