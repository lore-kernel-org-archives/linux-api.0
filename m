From: Jann Horn <jannh@google.com>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Fri, 5 May 2017 04:47:31 +0200
Message-ID: <CAG48ez1jzNvxB+bfOBnERFGp=oMM0vHWuLD6EULmne3R6xa53w@mail.gmail.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk> <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
 <20170505003030.GM29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170505003030.GM29622@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux API <linux-api@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

+CC drysdale in case he has thoughts on this

On Fri, May 5, 2017 at 2:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
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

One annoying edgecase might be what happens when one thread
does an AT_BENEATH walk while another thread mutates the directory
structure. If some directory that is currently being traversed by the walk
is moved out of the directory at which the walk started, would that be
detected somehow, or could the walk then follow ".." path
components up to the root directory of the current process / of the
namespace the fd is referring to? As in:

Thread 1 starts an AT_BENEATH path walk using an O_PATH fd
pointing to /srv/www/example.org/foo; the path given to the syscall is
"bar/../../../../etc/passwd". The path walk enters the "bar" directory.
Thread 2 moves /srv/www/example.org/foo/bar to
/srv/www/example.org/bar.
Thread 1 processes the rest of the path ("../../../../etc/passwd"), never
hitting /srv/www/example.org/foo in the process.

I'm not really familiar with the VFS internals, but from a coarse look
at the patch, it seems like it wouldn't block this?
