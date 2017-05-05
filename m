From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Thu, 4 May 2017 21:01:23 -0700
Message-ID: <CA+55aFy8faOrivrKREJHVd2Ua5VsuOz+CKQu=Y+k_xQHU5TqGA@mail.gmail.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk> <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
 <20170505003030.GM29622@ZenIV.linux.org.uk> <CA+55aFyOKM7DW7+0sdDFKdZFXgptb5r1id9=Wvhd8AgSP7qjwQ@mail.gmail.com>
 <20170505030058.GO29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170505030058.GO29622@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 4, 2017 at 8:00 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> That could still allow crossing mount-points, but only if they are
>> non-bind mounts and cannot let us escape.
>>
>> I'm not sure if that's testable, though.
>
> This one isn't, unfortunately - there is no difference between bind and
> no-bind; vfsmounts form a tree and both normal mount and bind add leaves
> to it.  Moreover, mount -t ext2 /dev/sdc7 /mnt; mount -t ext2 /dev/sdc7 /tmp/a
> yield the same state as mount -t ext2 /dev/sdc7; mount --bind /mnt /tmp/a.
> There is no way to tell the difference, simply because there *is* no
> difference.  Moreover, either can be followed by umount /mnt and you'll get
> the same state as you would have after a solitary mount of the same fs on
> /tmp/a.

Fair enough.

> Ho-hum...  So:
>
>                         AT_BENEATH      AT_XDEV         AT_NO_SYMLINKS
> absolute pathname:      EXDEV
> non-relative symlink:   EXDEV           ?               ELOOP
> relative symlink:                                       ELOOP
> .. from starting point: EXDEV
> .. crossing mountpoint:                 EXDEV
> crossing into mountpoint:               EXDEV
>
> 1) What should AT_XDEV do about absolute symlinks?  Nothing special?  EXDEV?
> EXDEV if we are not on root?

My mental model would say that AT_XDEV without AT_BENEATH would
_logically_ result in "EXDEV if / is a different vfsmount", accept the
absolute path otherwise.

But honestly, just returning EXDEV unconditionally for an absolute
symlink might just be the simpler and more straightforward thing to
do.

Because testing the particular vfsmount of / simply doesn't seem to be
a very useful operation.  I dunno.

> 2) What should AT_BENEATH | AT_NO_SYMLINKS do on absolute symlinks?  My
> preference would be "AT_NO_SYMLINKS wins, ELOOP for you", but that's based
> mostly upon the convenience of implementation.

I think either is fine, and convenience wins.

> 3) What effect should AT_NO_SYMLINKS have upon the final component?  Same
> as AT_SYMLINK_NOFOLLOW?

I actually would suggest "error if it's followed".

So if you use AT_SYMLINK_NOFOLLOW | AT_NO_SYMLINKS, then you do *not*
get an error if the last component (but nothing before it) is a
symlink, and the end result is the symlink itself.

If you use just AT_NO_SYMLINKS, then the lack of NOFOLLOW implies that
you'd follow the symlink to look it up, and then AT_NO_SYMLINKS means
that you get an error (ELOOP).

So the user gets to choose, and gets to basically indicate whether
it's fine to end at a dangling symlink or not. Which is exactly what
AT_SYMLINK_NOFOLLOW is all about.

No?

                   Linus
