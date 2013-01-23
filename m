From: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 0/3] signalfd: a kernel interface for dumping pending
 signals
Date: Wed, 23 Jan 2013 17:03:03 +0400
Message-ID: <20130123130303.GA17704@paralelels.com>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org>
 <CAKgNAkgfV3qdrvBUYKBAgaYXUTZ5hMYLhwaiLkZO0KBTA_=1zw@mail.gmail.com>
 <20130123110323.GA23139@paralelels.com>
 <CAKgNAkjCX4L6R3X7uaLufjY61ZszQTWbD+bLqadGRB-HLNKOrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkjCX4L6R3X7uaLufjY61ZszQTWbD+bLqadGRB-HLNKOrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 23, 2013 at 01:11:42PM +0100, Michael Kerrisk (man-pages) wrote:
> Hi Andrey,
> 
> On Wed, Jan 23, 2013 at 12:03 PM, Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> > On Wed, Jan 23, 2013 at 05:19:24AM +0100, Michael Kerrisk (man-pages) wrote:
> >> Hi Andrey,
> >>
> >> On Tue, Jan 22, 2013 at 11:15 AM, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> >> > This patch set adds ability to choose a signal queue and
> >> > to read signals without dequeuing them.
> >> >
> >> > Three new flags are added:
> >> > SFD_SHARED_QUEUE     -- reads will be from process-wide shared signal queue
> >> > SFD_PER_THREAD_QUEUE -- reads will be from per-thread signal queue
> >> > SFD_PEEK             -- don't dequeue signals
> >
> >>
> >> A fuller description of the patch, including information that was in
> >> previous versions of this patch would be helpful. Let me see if I can
> >> summarize/fill out the API side of things, and ask a few questions
> >> along the way (yes, I could answer some of the questions by checking
> >> the code, but I want to know what the *intended* behavior is).
> >>
> >> The patch series adds a total of 4 flags to signalfd(). In addition to
> >> those you list above, the other is
> >
> > In additional we can say, that this patch series adds three orthogonal,
> > independent groups of flags.
> > * SFD_RAW
> > * SFD_PEEK
> > * SFD_SHARED_QUEUE, SFD_PER_THREAD_QUEUE
> 
> Thanks. Nice summary.
> 
> >> SFD_RAW -- return raw siginfo structs when reading, rather than signalfd_siginfo
> >>
> >> The intention is that these flags be used in conjunction with pread(),
> >> to peek at queued signals. The 'offset' argument is treated as a
> >> position. Thus, for example, to non-destructively read all of the
> >> per-thread signals in raw form from the per-thread queue, one would
> >> write
> >>
> >
> > siginfo_t *buf;
> >
> >> fd = signalfd(-1, SFD_PER_THREAD_QUEUE | SFD_RAW | SFD_PEEK)
> >> for (j = 0; ; j++) {
> >>     s = pread(fd, buf, ocunt, j)
> >       s = pread(fd, buf + j, sizeof(siginfo_t), j);
> >>     if (s <= 0) /* No more signals */
> >>         break;
> >> }
> >
> > This examples reads signals one by one
> >
> > or
> >
> >   siginfo_t *buf = NULL;
> >   unsigned long buf_size = 0, nr = 0;
> >   int ret;
> >
> >   while (1) {
> >         bug_size += PAGE_SIZ;
> >         buf = realloc(buf, buf_size);
> >         if (buf == NULL)
> >                 goto err;
> >         ret = pread(fd, buf + nr, sizeof(siginfo_t), nr);
> >         if (ret == -1)
> >                 goto err;
> >         nr += ret / sizeof(siginfo_t);
> >         if (ret < PAGE_SIZE) /* No more signals */
> >                 break;
> >   }
> >
> > pread() can read more than one signal.
> 
> (Thanks for the reminder on that last point.)
> 
> > * The interface of signalfd could be a bit more predictable,
> >   if we will treat pos as offset in bytes, not in elements.
> >
> >   pread(fd, buf, sizeof(siginfo_t), i * sizeof(siginfo_t)) -
> >                reads a signal with a sequence number i in a queue.
> 
> Can you explain what you mean by "more predictable"? It's not clear to me.

offset is usual in bytes.

Lets imagine that we have a file, which contains siginfo-s.
If "pos" is offset in bytes, the same code can reads siginfo-s from the
file and from signalfd.

> 
> >> Right?
> >>
> >> Now some questions. I don't require all of the following, but I'm
> >> wanting to know what's possible, for documentation purposes.
> >>
> >> Q1: with this patch series, is it permissible to specify
> >> SFD_PER_THREAD_QUEUE or SFD_SHARED_QUEUE without specifying either
> >> SFD_PEEK or SFD_QUEUE? In other words, can one do traditional
> >> signalfd_siginfo reads, but selecting from a specific queue.
> >
> > Yes, we can
> >>
> >> Q2: Is it possible to specify SFD_PEEK without SFD_RAW, so that one
> >> can peek at siginfo structs rather than signalfd_siginfo structs?
> >
> > Yes, it is possible. read() and pread() returns signalfd_siginfo structs
> > in this case.
> >
> >>
> >> Q3: Is it possible to specify SFD_RAW without SFD_PEEK, so that one
> >> can destructively read signalfd_siginfo structs? Can that be done
> >> using any read interface (read(), pread(), etc.)?
> > Yes, it is possible too. read() will return siginfo structs.
> 
> 3 * yes is nice!
> 
> For which of the above 3 questions was the answer "No" with the
> previous version of these patches (the version that specified queue
> selection in pread())?

Only for the first question.

> 
> 
> >> Q4: Is it possible to specify both SFD_PER_THREAD_QUEUE and
> >> SFD_SHARED_QUEUE? In that case, in what order are signals read from
> >> the two queues?
> >>
> >
> > It is equal to the case, when none of these flags are not specified.
> > And it is equal to what we had before this patches.
> > signalfd() reads signals from a private queue, then from a shared queue.
> 
> So, the 'offset' argument of pread() is interpreted by considering the
> per-thread and shared queue as one concatenated list, right?

It's true, if both SFD_QUEUE flags was specified.
If only one for these flags is specified, the 'offset' argument is a
sequnce number in a proper list.

> 
> If yes to the previous question, then from an API design point of view
> that seems odd: it exposes an implementation detail. Is specifying
> both SFD_PER_THREAD_QUEUE and SFD_SHARED_QUEUE usefule for
> checkpoint/restore?

No. crtools reads signals from each queue separately.

> I almost wonder if, when SFD_PEEK is specified, a
> requirement should be enforced that SFD_PER_THREAD_QUEUE or
> SFD_SHARED_QUEUE, but not both, must be specified. What do you think?

Looks reasonable.

> 
> Thanks,
> 
> Michael
