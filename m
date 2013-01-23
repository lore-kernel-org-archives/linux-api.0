From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/3] signalfd: a kernel interface for dumping pending signals
Date: Wed, 23 Jan 2013 05:19:24 +0100
Message-ID: <CAKgNAkgfV3qdrvBUYKBAgaYXUTZ5hMYLhwaiLkZO0KBTA_=1zw@mail.gmail.com>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1358849741-9611-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

Hi Andrey,

On Tue, Jan 22, 2013 at 11:15 AM, Andrey Vagin <avagin@openvz.org> wrote:
> This patch set adds ability to choose a signal queue and
> to read signals without dequeuing them.
>
> Three new flags are added:
> SFD_SHARED_QUEUE     -- reads will be from process-wide shared signal queue
> SFD_PER_THREAD_QUEUE -- reads will be from per-thread signal queue
> SFD_PEEK             -- don't dequeue signals

A fuller description of the patch, including information that was in
previous versions of this patch would be helpful. Let me see if I can
summarize/fill out the API side of things, and ask a few questions
along the way (yes, I could answer some of the questions by checking
the code, but I want to know what the *intended* behavior is).

The patch series adds a total of 4 flags to signalfd(). In addition to
those you list above, the other is

SFD_RAW -- return raw siginfo structs when reading, rather than signalfd_siginfo

The intention is that these flags be used in conjunction with pread(),
to peek at queued signals. The 'offset' argument is treated as a
position. Thus, for example, to non-destructively read all of the
per-thread signals in raw form from the per-thread queue, one would
write

fd = signalfd(-1, SFD_PER_THREAD_QUEUE | SFD_RAW | SFD_PEEK)
for (j = 0; ; j++) {
    s = pread(fd, buf, ocunt, j)
    if (s == 0) /* No more signals */
        break;
}

Right?

Now some questions. I don't require all of the following, but I'm
wanting to know what's possible, for documentation purposes.

Q1: with this patch series, is it permissible to specify
SFD_PER_THREAD_QUEUE or SFD_SHARED_QUEUE without specifying either
SFD_PEEK or SFD_QUEUE? In other words, can one do traditional
signalfd_siginfo reads, but selecting from a specific queue.

Q2: Is it possible to specify SFD_PEEK without SFD_RAW, so that one
can peek at siginfo structs rather than signalfd_siginfo structs?

Q3: Is it possible to specify SFD_RAW without SFD_PEEK, so that one
can destructively read signalfd_siginfo structs? Can that be done
using any read interface (read(), pread(), etc.)?

Q4: Is it possible to specify both SFD_PER_THREAD_QUEUE and
SFD_SHARED_QUEUE? In that case, in what order are signals read from
the two queues?

Thanks,

Michael

> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> CC: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
>
> --
> 1.7.11.7
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
