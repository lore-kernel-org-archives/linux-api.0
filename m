From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC 1/2] fs,eventpoll: Add ability to install target file by its number
Date: Fri, 17 Feb 2017 09:20:34 -0800
Message-ID: <CALCETrUmUOXL=72SA-pqNhQda0ic946UNnWUe_vwSHVruiyFfg@mail.gmail.com>
References: <20170217083324.627615532@openvz.org> <CALCETrUOaNaS6yAhLM9jLb8PD2eg2ZwXfu4v327aAOy82SbLwg@mail.gmail.com>
 <20170217171136.GA23766@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170217171136.GA23766@uranus>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linuxfoundation.org>, Andrew Vagin <avagin@virtuozzo.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Kirill Kolyshkin <kir@openvz.org>, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 17, 2017 at 9:11 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Fri, Feb 17, 2017 at 08:52:59AM -0800, Andy Lutomirski wrote:
>> >
>> > To resolve this tie lets add EPOLL_CTL_DUP operation which simply takes
>> > target file descriptor number and installs it into a caller's file table,
>> > thus we can use kcmp() syscall and figure out which exactly file to be
>> > added into eventpoll on restore procedure.
>>
>> This is a scary thing to let an unprivileged process do.
>>
>> I'm wondering if there might be a nicer way to address this using a
>> better interface in /proc.
>
> Well, I tend to agree. Need to add security checking if the target
> file is accessable by a caller. As to better interface to procfs
> nothing comes to mind immediately. Another potential problem is that
> since it is never guaranteed that target file number listed in fdinfo
> matching existing /proc/pid/fd/N, so that I think we will have to
> use this dup functionality for every target file, which of course
> not that fast. Probably need to think more if I manage to invent
> some better and faster interface to find where exactly target file
> belong in the whole process tree of a container.

i was imagining some proc or proc-like interface that lets you inspect
an open file without needing to know what process has the fd.

What if you introduced a new type of fd that's an "fd reference".  You
could add a kcmp mode that tells you whether an fd reference refers to
the same thing as a real fd, but you'd arrange for fd references to be
otherwise useless.

Alternatively, you could simply have an interface like kcmp (maybe a
new kcmp mode) that lets you compare an epoll set entry to an actual
fd.  Then you could figure out what it is but only if you already have
the fd by some other means.  Of course, if there are no references
left, you still have a problem.  Hmm.

>
> Thanks for pointing about this security problem, Andy!



-- 
Andy Lutomirski
AMA Capital Management, LLC
