From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 6/5] statx: add STATX_RESULT_MASK flag
Date: Fri, 19 Oct 2018 19:42:27 +0200
Message-ID: <CAJfpegtPv4+QxzcqMAGwTt7QALjBaxQtt2Qet98pdmuT1MRUeA@mail.gmail.com>
References: <20181019143932.6697-1-mszeredi@redhat.com> <18142.1539964788@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18142.1539964788@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 19, 2018 at 5:59 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <mszeredi@redhat.com> wrote:
>
>> FUSE needs this, because it uses legacy inode initialization, that doesn't
>> return a result_mask, so needs a refresh when caller asks for it with
>> statx().
>
> Can't you just make it up in fuse?  Presumably, fuse doesn't support any of
> the non-basic statx fields either?

This is very much about the basic statx fields.  I.e. what does
result_mask == STATX_BASIC_STATS means?

 a) this is a legacy stat() implementation that doesn't fill in the
result_mask properly

 b) this is an up-todate stat() implementation that does fill the
result_mask properly and all fields are valid

There's no way to tell which one it is, and no way to request that
filesystem try b) even if it's more costly.

>> It might make sense later to promote this to a proper statx mask flag and
>> return it in stx_mask to userspace.
>
> That sounds kind of recursive - a bit in stx_mask would be saying whether or
> not stx_mask can be used.

Yes.  See above.

>> +#define STATX_RESULT_MASK STATX__RESERVED
>
> Please don't use that bit.

Using it internally is perfectly harmless.   If we'll need to extend
statx in the future and make use of this flag externally, then we can
easily move the internal flag somewhere else (e.g. extend request_mask
to 64bit, which we'll probably need to do anyway in that case).

Thanks,
Miklos
