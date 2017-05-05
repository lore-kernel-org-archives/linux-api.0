From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Fri, 05 May 2017 15:04:33 -0500
Message-ID: <878tmb83zi.fsf@xmission.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk>
        <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
        <20170505003030.GM29622@ZenIV.linux.org.uk>
        <CAG48ez1jzNvxB+bfOBnERFGp=oMM0vHWuLD6EULmne3R6xa53w@mail.gmail.com>
        <CA+55aFy1SokNNUgxBnFLdA1PRyeG13BqyYNg5xVrW-tNGqh2Bg@mail.gmail.com>
        <20170505043902.GP29622@ZenIV.linux.org.uk>
        <CALCETrVQ2fwDZOsGSoLyRb6Qjp4nszfDjOPSYi0kzqt23Aw1NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVQ2fwDZOsGSoLyRb6Qjp4nszfDjOPSYi0kzqt23Aw1NA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Andy Lutomirski's message of "Thu, 4 May 2017 21:44:04 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> On Thu, May 4, 2017 at 9:39 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
>> On Thu, May 04, 2017 at 08:46:49PM -0700, Linus Torvalds wrote:
>>> On Thu, May 4, 2017 at 7:47 PM, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>> >
>>> > Thread 1 starts an AT_BENEATH path walk using an O_PATH fd
>>> > pointing to /srv/www/example.org/foo; the path given to the syscall is
>>> > "bar/../../../../etc/passwd". The path walk enters the "bar" directory.
>>> > Thread 2 moves /srv/www/example.org/foo/bar to
>>> > /srv/www/example.org/bar.
>>> > Thread 1 processes the rest of the path ("../../../../etc/passwd"), never
>>> > hitting /srv/www/example.org/foo in the process.
>>> >
>>> > I'm not really familiar with the VFS internals, but from a coarse look
>>> > at the patch, it seems like it wouldn't block this?
>>>
>>> I think you're right.
>>>
>>> I guess it would be safe for the RCU case due to the sequence number
>>> check, but not the non-RCU case.
>>
>>         Yes and no...  FWIW, to exclude that it would suffice to have
>> mount --rbind /src/www/example.org/foo /srv/www/example.org/foo done first.
>> Then this kind of race will end up with -ENOENT due to path_connected()
>> logics in follow_dotdot_rcu()/follow_dotdot().  I'm not sure about the
>> intended applications, though - is that thing supposed to be used along with
>> some horror like seccomp, or...?
>
> How hard would it be for the kernel to prevent this on its own?
> Asking users to do the mount --rbind seems like it's asking for users
> to forget to do it.

The logic of path_connected checks every time you follow .. if the
parent directory you find is below your starting directory.
Mostly path_connected is optimized by noticing non-bind mounts
and doing nothing.  In this case we would need the is_subdir check
every time we follow ..

So it might just be cheaper not to follow ..

Which leads to something else we need to be careful with.

Suppose for whatever insane reason . is on a directory that has
another directory mounted on top.  Then following "some_dir/.."
would result in a different directory than we were on.

Eric
