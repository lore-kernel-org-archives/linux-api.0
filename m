From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 1/2] fs,eventpoll: Add ability to install target file by
 its number
Date: Fri, 17 Feb 2017 20:11:36 +0300
Message-ID: <20170217171136.GA23766@uranus>
References: <20170217083324.627615532@openvz.org>
 <CALCETrUOaNaS6yAhLM9jLb8PD2eg2ZwXfu4v327aAOy82SbLwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUOaNaS6yAhLM9jLb8PD2eg2ZwXfu4v327aAOy82SbLwg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kirill Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 17, 2017 at 08:52:59AM -0800, Andy Lutomirski wrote:
> >
> > To resolve this tie lets add EPOLL_CTL_DUP operation which simply takes
> > target file descriptor number and installs it into a caller's file table,
> > thus we can use kcmp() syscall and figure out which exactly file to be
> > added into eventpoll on restore procedure.
> 
> This is a scary thing to let an unprivileged process do.
> 
> I'm wondering if there might be a nicer way to address this using a
> better interface in /proc.

Well, I tend to agree. Need to add security checking if the target
file is accessable by a caller. As to better interface to procfs
nothing comes to mind immediately. Another potential problem is that
since it is never guaranteed that target file number listed in fdinfo
matching existing /proc/pid/fd/N, so that I think we will have to
use this dup functionality for every target file, which of course
not that fast. Probably need to think more if I manage to invent
some better and faster interface to find where exactly target file
belong in the whole process tree of a container.

Thanks for pointing about this security problem, Andy!
