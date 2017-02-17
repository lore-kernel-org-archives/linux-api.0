From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 1/2] fs,eventpoll: Add ability to install target file by
 its number
Date: Fri, 17 Feb 2017 21:01:18 +0300
Message-ID: <20170217180118.GB23766@uranus>
References: <20170217083324.627615532@openvz.org>
 <CALCETrUOaNaS6yAhLM9jLb8PD2eg2ZwXfu4v327aAOy82SbLwg@mail.gmail.com>
 <20170217171136.GA23766@uranus>
 <CALCETrUmUOXL=72SA-pqNhQda0ic946UNnWUe_vwSHVruiyFfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUmUOXL=72SA-pqNhQda0ic946UNnWUe_vwSHVruiyFfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kirill Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 17, 2017 at 09:20:34AM -0800, Andy Lutomirski wrote:
> >>
> >> This is a scary thing to let an unprivileged process do.
> >>
> >> I'm wondering if there might be a nicer way to address this using a
> >> better interface in /proc.
> >
> > Well, I tend to agree. Need to add security checking if the target
> > file is accessable by a caller. As to better interface to procfs
> > nothing comes to mind immediately. Another potential problem is that
> > since it is never guaranteed that target file number listed in fdinfo
> > matching existing /proc/pid/fd/N, so that I think we will have to
> > use this dup functionality for every target file, which of course
> > not that fast. Probably need to think more if I manage to invent
> > some better and faster interface to find where exactly target file
> > belong in the whole process tree of a container.
> 
> i was imagining some proc or proc-like interface that lets you inspect
> an open file without needing to know what process has the fd.

We will have to find out which process opened the target fd (currently
in criu we simply assume that target file is always in process which
created epoll and other scenarios are not supported. in most situations
that's enough but unfortunately we find a testcase where it's not
true and have to find a way to support migrated targets too).

> What if you introduced a new type of fd that's an "fd reference".  You
> could add a kcmp mode that tells you whether an fd reference refers to
> the same thing as a real fd, but you'd arrange for fd references to be
> otherwise useless.
> 
> Alternatively, you could simply have an interface like kcmp (maybe a
> new kcmp mode) that lets you compare an epoll set entry to an actual
> fd.  Then you could figure out what it is but only if you already have
> the fd by some other means.  Of course, if there are no references
> left, you still have a problem.  Hmm.

kcmp over target set seems to be preferred since it gonna be a way
faster. But I think about fd-ref idea too. Thanks a huge!
