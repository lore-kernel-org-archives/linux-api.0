From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: User-visible context-mount API
Date: Wed, 17 Jan 2018 10:53:36 +0100
Message-ID: <CAOssrKfN_ZT5yJC1mxkhUf6FG=_eMD4nzQtETfu_4X3vOf1kHw@mail.gmail.com>
References: <28167.1516032442@warthog.procyon.org.uk> <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com>
 <1643.1516117204@warthog.procyon.org.uk> <CAOssrKdn-ZhOB9V28uL-JK9zgNGJzF4cFBeyoqLLj4pADqNFVQ@mail.gmail.com>
 <20180117041727.GS13338@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180117041727.GS13338@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>, "Eric W. Biederman" <ebiederm@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, util-linux@vger.kernel.org, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

[Adding util-linux@vger and Michael Kerrisk]

On Wed, Jan 17, 2018 at 5:17 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Jan 16, 2018 at 05:41:46PM +0100, Miklos Szeredi wrote:
>
>> Right.
>>
>> Still, those two (propagation and flags) are properties of the mount.
>> No fundamental difference in how to handle them, that I see.  Okay, we
>> have MS_REC handling in the propagation and not in the flags, but
>> that's something that might make sense for flags as well.
>>
>> What's more interesting is how MS_PRIVATE + MS_REC semantics are
>> complete failure in the real world: the logical thing would be to mark
>> a mount private on the supplied mount AND propagate an umount event to
>> everywhere else.
>
> This is utter nonsense.  Most of the time it's "Fedora, in its infinite
> bogo^Wwisdom has made everything shared; I don't fucking need that
> idiocy, so please unshare this, this and that".  You really don't want
> (or have permissions for) unmounting e.g. /mnt in namespace of init
> when you do that.
>
> Sure, we get tons of bug reports.  Due to idiotic Fedora setup, with
> everything shared.  The same setup that would go up in flames on the
> semantics change you propose.

I wouldn't propose to change existing --make-private, as this would
not be backward compatible. The new semantics would mean a new op,
obviously.

Documenting  --make-private thing properly would also help.  To me the
wording "make private" strongly implies "I want to make submounts
private to this instance".  See for example rhbz#1432211.

> If anything, "private bind on itself" would be a useful operation.
> Turning given location into a mountpoint, and having everything
> under it looking as it used to, but with no propagation at all.
> Without bothering anybody else, even if location currently happens
> to be on a shared/master mount.
>
> I can slap that together for mount(2), but I'm not sure what a sane
> combination of flags for that would look like ;-)  For fsmount
> I think it would be very useful thing to have.

Yes, I think such an operation would be pretty useful.   Not sure if
it's the whole story, though.

Thanks,
Miklos
