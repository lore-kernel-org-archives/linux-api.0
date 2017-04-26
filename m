From: David Howells <dhowells@redhat.com>
Subject: Re: Revised statx(2) man page for review [and AT_EMPTY_PATH question]
Date: Wed, 26 Apr 2017 16:10:35 +0100
Message-ID: <20166.1493219435@warthog.procyon.org.uk>
References: <95977e2e-ac02-9960-4ed3-d9b988bed46a@gmail.com> <f3ef2be8-dfa5-e1dd-2315-d787a2a2acc3@gmail.com> <14390.1493206508@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <95977e2e-ac02-9960-4ed3-d9b988bed46a@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: dhowells@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, "Dmitry V. Levin" <ldv@altlinux.org>
List-Id: linux-api@vger.kernel.org

Michael Kerrisk (man-pages) <mtk.manpages@gmail.com> wrote:

> > This indicates what stx_attributes the VFS and filesystem actually support.
> > 
> >>                __s32 tv_nsec;   /* Nanoseconds before or since tv_sec */
> > 
> > If you're going to do Dmitry's suggestion, then this needs to be __u32 and you
> > should remove "before or".
> 
> I think the question is rather: what is going to be done to the API?
> Will it be changed as Dmitry suggests?

I've forwarded Dmitry's patch to this effect.

> Having two ways to do something is odd, and redundant. Note
> of the other APIs that provide this functionality do so
> in both ways, AFAIK. It's not a big problem, but certainly
> strange. If you settle on having just one, then I'd say
> choose AT_EMPTY_PATH.

If I choose that, I presume I would have to give EINVAL if the path is NULL or
anything other than ""?

> Under ERRORS I added:
> 
> .TP
> .B EINVAL
> Reserved flag specified in
> .IR mask .
> 
> Okay?

That's fine.

> >>        It should be noted that  the  kernel  may  return  fields  that
> >>        weren't  requested  and  may  fail  to  return fields that were
> >>        requested, depending on what the backing  filesystem  supports.
> > 
> > Maybe add "and can be safely ignored" in there somewhere since this seems to
> > be upsetting people.
> 
> You say "in there somewhere", but it's not quite clear to me which piece 
> this applies to. Could you propose a wording please.

Can you do footnotes in roff?

	It should be noted that  the  kernel  may  return  fields  that
	weren't  requested[*]  and  may  fail  to  return fields that were
	requested, depending on what the backing  filesystem  supports.

	[*] These can be safely ignored.

Or maybe:

	It should be noted that  the  kernel  may  return  fields  that
	weren't  requested  and  may  fail  to  return fields that were
	requested, depending on what the backing  filesystem  supports.
	Fields that are given values despite being unrequested can just
	be ignored.

> >>        If a filesystem does not support a field or if it has an unrep‐
> >>        resentable value (for instance, a file with  an  exotic  type),
> >>        then  the  mask bit corresponding to that field will be cleared
> >>        in stx_mask even if the user asked for it  and  a  dummy  value
> >>        will  be  filled in for compatibility purposes if one is avail‐
> >>        able (e.g., a dummy UID and GID may be specified to mount under
> >>        some circumstances).
> > 
> > I don't promise a dummy value for any "extended" field other than zero.
> 
> I don't know what you mean to say here. Do you mean some
> text in the page should change?

The paragraph promises a "dummy value will be filled in for compatibility
purposes if one is available", but doesn't place any restriction on the fields
towhich this applies.  This is only true of the basic stat fields; all other
fields will be cleared if not set.

Maybe we can just leave this as is.  We're not promising a dummy field will
*always* be emplaced.  We can always say that they're just not available for
extended fields if someone asks.

Maybe the best thing to do is to simply add "and cleared otherwise." to the
end of the paragraph.

> > Should this list either be in alphabetical order or offset-in-struct order?
> 
> Probably the same order as the struct.

Sounds good.

> Added. But, what does "no usable value here" mean? (The relationship
> between stx_attributes_mask and stx_attributes still isn't
> so clear to me.

It's not so obvious with the bits that are currently defined.  But I have a
patch that adds Windows attribute bits also (for cifs, ntfs, fat, ...).  What
does it mean, say, if the archive bit is clear?  Does it mean that archive
isn't set in the fs or that the fs doesn't support it?

Further, I have plans to add a 'setattrx' syscall that takes a statx struct
and calls notify_change() with its contents in the kernel.  If I do that, I
need to indicate to notify_change() what changes should be effected.  stx_mask
covers most of the fields, but not stx_attributes.  Some of these attributes
would be alterable.

Would you prefer it to be reverted for the moment?

David
