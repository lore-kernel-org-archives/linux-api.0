From: David Drysdale <drysdale@google.com>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Thu, 18 May 2017 09:50:03 +0100
Message-ID: <CAHse=S9=Qpjcex+1O0n1r_pnyLZPUq+K03thbAozG61umEH9Ug@mail.gmail.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk> <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
 <20170505003030.GM29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170505003030.GM29622@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 5, 2017 at 1:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
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

BTW, FreeBSD head now allows .. if it stays in subtree:
https://svnweb.freebsd.org/base?view=revision&revision=308212
