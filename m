From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 2/5] uapi: deprecate STATX_ALL
Date: Fri, 19 Oct 2018 17:40:40 +0200
Message-ID: <CAJfpegviiy=9fru3zButbqLnhshH85srH3qyZO2zf-_RPqSs=g@mail.gmail.com>
References: <20181019122049.27121-1-mszeredi@redhat.com> <20181019122049.27121-2-mszeredi@redhat.com>
 <16382.1539963322@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <16382.1539963322@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 19, 2018 at 5:35 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <mszeredi@redhat.com> wrote:
>
>> +/*
>> + * This is deprecated, and shall remain the same value in the future.  To avoid
>> + * confusion please use the equivalent (STATX_BASIC_STATS | STATX_BTIME)
>> + * instead.
>> + */
>> +#define STATX_ALL            0x00000fffU
>
> The comment is misleading.  STATX_ALL is *not* equivalent to
> STATX_BASIC_STATS | STATX_BTIME, even though it might be numerically the
> same.  You would need to update the comment when you add STATX_ATTRIBUTES
> to mention that also.

The definition of STATX_ALL is, and will remain, equivalent to
STATX_BASIC_STATS | STATX_BTIME.

What is misleading about this?

If you feel confused by this comment, then maybe I should just drop that part.

Thanks,
Miklos
