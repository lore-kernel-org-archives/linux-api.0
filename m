From: Andy Lutomirski <luto@kernel.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Thu, 4 May 2017 17:44:19 -0700
Message-ID: <CALCETrXE2-841_VRgDJxRZBYAfvSe+GQN+0Jkfh3k1pL8XfDaA@mail.gmail.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk> <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
 <20170505003030.GM29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170505003030.GM29622@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 4, 2017 at 5:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, May 01, 2017 at 07:36:52PM +0200, Jann Horn wrote:
>
>> Oh, nice!
>>
>> It looks like this is somewhat similar to the old O_BENEATH proposal,
>> but because the intentions behind the proposals are different
>> (application sandboxing versus permitting an application to restrict its
>> own filesystem accesses), the semantics differ: AT_NO_JUMPS
>> doesn't prevent starting the path with "/", but does prevent mountpoint
>> traversal. Is that correct?
>
> It prevents both, actually - I missed that in description, but this
>         if (unlikely(nd->flags & LOOKUP_NO_JUMPS))
>                 return -ELOOP;
> in nd_jump_root() affects absolute pathnames same way as it affects
> absolute symlinks.
>
> It's not quite O_BENEATH, and IMO it's saner that way - a/b/c/../d is
> bloody well allowed, and so are relative symlinks that do not lead out of
> the subtree.  If somebody has a good argument in favour of flat-out
> ban on .. (_other_ than "other guys do it that way, and it doesn't need
> to make sense 'cuz security!!1!!!", please), I'd be glad to hear it.

I don't have an argument for allowing '..'.  I think it would be okay
to disallow it, but I don't think it matters all that much either way.

>
> As for mountpoint crossing...  it might make sense to split those.
> O_BENEATH allowed it, and if we want AT_BENEATH to match that - let's
> do it.  Then this one would become AT_BENEATH | AT_XDEV (the latter named
> after find(1) option, obviously).
>
> So how about this:
>
> AT_BENEATH:
>         * no absolute pathnames
>         * no absolute symlinks
>         * no procfs-style symlinks
>         * no traversal of .. when we are at the same place where we'd started
> (dir/../file is allowed, dir/../.. isn't)
>
> AT_XDEV:
>         * no mountpoint crossing allowed
>
> For the latter I would prefer -EXDEV, for obvious reasons.  For the former...
> not sure.  I'm not too happy about -ELOOP, but -EPERM (as with O_BENEATH)
> is an atrocity - it's even more overloaded.
>
> Suggestions?

-EDOTDOT would be amusing.
