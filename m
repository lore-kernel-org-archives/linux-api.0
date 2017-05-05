From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Fri, 05 May 2017 15:28:47 -0500
Message-ID: <8737cj6oao.fsf@xmission.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk>
        <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
        <20170505003030.GM29622@ZenIV.linux.org.uk>
        <CAG48ez1jzNvxB+bfOBnERFGp=oMM0vHWuLD6EULmne3R6xa53w@mail.gmail.com>
        <CA+55aFy1SokNNUgxBnFLdA1PRyeG13BqyYNg5xVrW-tNGqh2Bg@mail.gmail.com>
        <20170505043902.GP29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170505043902.GP29622@ZenIV.linux.org.uk> (Al Viro's message of
        "Fri, 5 May 2017 05:39:02 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Thu, May 04, 2017 at 08:46:49PM -0700, Linus Torvalds wrote:
>> On Thu, May 4, 2017 at 7:47 PM, Jann Horn <jannh@google.com> wrote:
>> >
>> > Thread 1 starts an AT_BENEATH path walk using an O_PATH fd
>> > pointing to /srv/www/example.org/foo; the path given to the syscall is
>> > "bar/../../../../etc/passwd". The path walk enters the "bar" directory.
>> > Thread 2 moves /srv/www/example.org/foo/bar to
>> > /srv/www/example.org/bar.
>> > Thread 1 processes the rest of the path ("../../../../etc/passwd"), never
>> > hitting /srv/www/example.org/foo in the process.
>> >
>> > I'm not really familiar with the VFS internals, but from a coarse look
>> > at the patch, it seems like it wouldn't block this?
>> 
>> I think you're right.
>> 
>> I guess it would be safe for the RCU case due to the sequence number
>> check, but not the non-RCU case.
>
> 	Yes and no...  FWIW, to exclude that it would suffice to have
> mount --rbind /src/www/example.org/foo /srv/www/example.org/foo done first.
> Then this kind of race will end up with -ENOENT due to path_connected()
> logics in follow_dotdot_rcu()/follow_dotdot().  I'm not sure about the
> intended applications, though - is that thing supposed to be used along with
> some horror like seccomp, or...?

As I recall the general idea is that if you have an application like a
tftp server or a web server that gets a path from a possibly dubious
source.  Instead of implementing an error prone validation logic in
userspace you can use AT_BENEATH and be certain the path resolution
stays in bounds.

As you can do stronger things as root this seems mostly targeted at
non-root applications.

I seem to recall part of the idea was to sometimes pair this to seccomp
to be certain your application can't escape a sandbox.  That plays to
seccomp limitations that it can inspect flags as they reside in
registers but seccomp can't follow pointers.

Which all suggests that we would want something similar to is_subdir
when AT_BENEATH is specified that we check every time we follow ..
that would verify that on the same filesystem we stay below and
that we also stay on a mount that is below.  mount --move has
all of the same challenges for enforcing you stay within bounds
as rename does.

Eric
