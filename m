From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: statx(2) API and documentation
Date: Thu, 18 Oct 2018 09:23:22 +0200
Message-ID: <CAJfpegtM2Sk2fi974rgtWXvRG=Z51KOyt8RekrR4HhAmz6Agfg@mail.gmail.com>
References: <CAJfpegsxFUGeczcC-pzK0WWROjv48_PvXtNun-f5QJMoUDn1Dw@mail.gmail.com>
 <006890C4-64D4-4DE2-A1F0-335FFFD585BB@dilger.ca> <CAJfpeguvJZbP83mSULc74Yhpp_CPMBW1XvcgbvCbLnF7QCncUA@mail.gmail.com>
 <E9903911-9289-4038-9835-9353762A3BAF@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E9903911-9289-4038-9835-9353762A3BAF@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, David Howells <dhowells@redhat.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 17, 2018 at 10:22 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Oct 17, 2018, at 1:04 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

>> So what's the point exactly?
>
> Ah, I see your point...  STATX_ALL seems to be mostly useful for the kernel
> to mask off flags that it doesn't currently understand.

And even there it's quite pointless, since no sane implementation
would put the request mask into the result mask (aka. stx_mask)
verbatim, without picking out bits which correspond to *supported*
fields.

So it's pointless across the board.  But since it's already published
in a userspace API, the best we can do is leave it at its current
value, but with a comment to warn that it  should not be updated when
new flags are added.  And remove all traces of it from the kernel.

>> Right, OTOH I sort of see the value in  NFS: no roundtrip to server if
>> atime value is useless anyway.
>
> Well, "noatime" might be a client-only option, which doesn't mean that the
> server or some other client isn't updating the atime.  Returning an old
> atime isn't the same as not returning anything at all.

Fs is allowed (and in case of basic stats, required) to fill in dummy
values for even unsupported fields.

I understand your argument, since that was my first thought, but I
also understand the reason behind clearing STATX_ATIME.  And atime is
something that very few applications care about anyway.   But I do
think such behavior should be clarified in the documentation and
handled more consistently in the code.

> To my thinking, if the user/app requests btime/ctime/size/blocks the kernel
> should return these fields.  If DONT_SYNC is set, it means the kernel can
> return potentially stale values, but if the kernel doesn't have *any*
> values for these fields at all it still should query the server instead of
> just returning random garbage.

I'm not saying it should return garbage, instead it can just not set
the bit in the result mask to indicate that that field cannot be
filled (without network traffic, in this case).

This requires generalizing the definition of the result mask, because
the above (clearing STATX_ATIME on ro/noatim or clearing STATX_BTIME
on DONT_SYNC) don't fit the current "unsupported or unrepresentable"
definition.

> That said, it seems that it isn't even possible to get into nfs_getattr()
> without the VFS having instantiated a dentry and inode (i.e. queried the
> server via nfs_lookup() at some point), so the inode fields have already
> been filled with *something*.

There's no "i_btime" field.

But it's hard to argue this point with btime, so lets instead think
about a theoretical attribute that is:

 - hard to calculate, so filesystem will not want to cache it on inode
initialization (because it's very unlikely to be actually needed)

 - isn't constant and can be cached, so all sync types make sense.

I think the following semantics would be the most useful and sane:
FORCE_SYNC or SYNC_AS_STAT would always retrieve the attribute if
supported, and set the bit in the result mask; DONT_SYNC would only
set the bit in the result mask if the attribute is already cached.

Thanks,
Miklos
