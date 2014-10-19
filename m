From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Sun, 19 Oct 2014 13:53:58 -0700
Message-ID: <544424E6.1060002@zytor.com>
References: <1401975635-6162-1-git-send-email-drysdale@google.com> <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com> <20141019202034.GH7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141019202034.GH7996-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/19/2014 01:20 PM, Al Viro wrote:
> On Fri, Oct 17, 2014 at 02:45:03PM -0700, Andy Lutomirski wrote:
> 
>> For example, I want to be able to reliably do something like nsenter
>> --namespace-flags-here toybox sh.  Toybox's shell is unusual in that
>> it is more or less fully functional, so this should Just Work (tm),
>> except that the toybox binary might not exist in the namespace being
>> entered.  If execveat were available, I could rig nsenter or a similar
>> tool to open it with O_CLOEXEC, enter the namespace, and then call
>> execveat.
> 
> The question I hadn't seen really answered through all of that was how to
> deal with #!...  "Just use d_path()" isn't particulary appealing - if that
> file has a pathname reachable for you, you could bloody well use _that_
> from the very beginning.
> 
> Frankly, I wonder if it would make sense to provide something like
> dupfs.  We can't mount it by default on /dev/fd (more's the pity), but
> it might be a good thing to have.
> 
> What it is, for those who are not familiar with Plan 9: a filesystem with
> one directory and a bunch of files in it.  Directory contents depends on
> who's looking; for each opened descriptor in your descriptor table, you'll
> see two files there.  One series is 0, 1, ... - opening one of those gives
> dup().  IOW, it's *not* giving you a new struct file; it gives you a new
> reference to existing one, complete with sharing IO position, etc.  Another
> is 0ctl, 1ctl, ... - those are read-only and reading from them gives pretty
> much a combination of our /proc/self/fdinfo/n with readlink of /proc/self/fd/n.
> 
> It's actually a better match for what one would expect at /dev/fd than what
> we do.  Example:
> 

Yes, it is really unfortunate that /proc/self/fd/* had the wrong
semantics for the start, due to then-existing implementation issues.

	-hpa
