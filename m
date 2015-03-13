From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 0/6] CLONE_FD: Task exit notification via file descriptor
Date: Fri, 13 Mar 2015 14:51:47 -0700
Message-ID: <CALCETrWwkdWkNCsrcSAn+7f9SJCuYA-TV9=AygWMhXCC9Njp9Q@mail.gmail.com>
References: <CAHse=S9hnGm=Z8FR4f+z_TFwnrjBLkcV4wVwjDYgKuOSemdVrA@mail.gmail.com>
 <20150313194252.GA10317@cloud> <CALCETrXH+Ui1XqVZjFB=8vDpJLCYeVf+XNUPGWNfwDsNKi_nKg@mail.gmail.com>
 <20150313214556.GB10954@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150313214556.GB10954@cloud>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 2:45 PM,  <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> On Fri, Mar 13, 2015 at 02:33:44PM -0700, Andy Lutomirski wrote:
>> On Fri, Mar 13, 2015 at 12:42 PM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
>> > On Fri, Mar 13, 2015 at 04:05:29PM +0000, David Drysdale wrote:
>> >> On Fri, Mar 13, 2015 at 1:40 AM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
>> >> > This patch series introduces a new clone flag, CLONE_FD, which lets the caller
>> >> > handle child process exit notification via a file descriptor rather than
>> >> > SIGCHLD.  CLONE_FD makes it possible for libraries to safely launch and manage
>> >> > child processes on behalf of their caller, *without* taking over process-wide
>> >> > SIGCHLD handling (either via signal handler or signalfd).
>> >>
>> >> Hi Josh,
>> >>
>> >> From the overall description (i.e. I haven't looked at the code yet)
>> >> this looks very interesting.  However, it seems to cover a lot of the
>> >> same ground as the process descriptor feature that was added to FreeBSD
>> >> in 9.x/10.x:
>> >>   https://www.freebsd.org/cgi/man.cgi?query=pdfork&sektion=2
>> >
>> > Interesting.
>> >
>> >> I think it would ideally be nice for a userspace library developer to be
>> >> able to do subprocess management (without SIGCHLD) in a similar way
>> >> across both platforms, without lots of complicated autoconf shenanigans.
>> >>
>> >> So could we look at the overlap and seeing if we can come up with
>> >> something that covers your requirements and also allows for something
>> >> that looks like FreeBSD's process descriptors?
>> >
>> > Agreed; however, I think it's reasonable to provide appropriate Linux
>> > system calls, and then let glibc or libbsd or similar provide the
>> > BSD-compatible calls on top of those.  I don't think the kernel
>> > interface needs to exactly match FreeBSD's, as long as it's a superset
>> > of the functionality.
>>
>> We need to be careful with things like read(2), though.  It's hard to
>> write a glibc function that makes read(2) do something other than what
>> the kernel thinks.  Similarly, poll(2) is defined by the kernel.  It
>> would be really nice to be consistent here.
>
> It doesn't sound like FreeBSD implements read(2) on the pdfork file
> descriptor at all.  If it does, yes, we're not going to be able to be
> compatible with that.

There's an argument that using read(2) for stuff like this is a bad
idea.  If anyone tried to do this in C++ (or any other OO language):

class GenericInterface
{
public:
  virtual void DoAction(const char *value, size_t len) = 0;
};

class Process : public GenericInterface
{
public:
  virtual void DoAction(const char *value, size_t len) = 0;
};

void Kill(Process *p)
{
  p->DoAction("kill", 4);
};

They'd be re-educated very quickly.  This is like duck typing, but
taken to a whole new level: *everything* is a duck, and ducks have a
grand total of three operations.

On the other hand, this seems to be UNIX tradition.  It's not as if
using echo on pidfds is going to be a common idiom, though.

In any event, we should find out what FreeBSD does in response to
read(2) on the fd.

--Andy
