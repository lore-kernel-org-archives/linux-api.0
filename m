From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: ABI change for setitimer(2) [in feature-removal-schedule.txt]
Date: Sun, 30 Sep 2012 10:51:21 -0700
Message-ID: <CA+55aFyjvESz3FZwAdnOuZX7R5B0ES0Vj3SngikA1A9PqTcoyQ@mail.gmail.com>
References: <CAHO5Pa2dnFH+SVkrJngR8Vn4VomsfJ00nOCzRB3+Ns4zs_pxnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHO5Pa2dnFH+SVkrJngR8Vn4VomsfJ00nOCzRB3+Ns4zs_pxnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sasikantha Babu <sasikanth.v19-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trevor Woerner <twoerner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Sep 29, 2012 at 11:30 PM, Michael Kerrisk
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> I think the whole "let's deprecate this six months into the future" is
>> unnecessary. Yes, it may well be worth doing for something with bigger
>> consequences, but I think that for something like this, it's just
>> overthinking the issue.
>
> When it comes to ABIs, I think there *is* value in a lead time on the
> change. This particular example is a good example of why.

No. This whole example is a good example of the fact that YOU SHOULD
NOT MAKE ABI CHANGES.

I don't understand why this seems to be so hard for people to understand.

There are exactly *zero* reasons to change the ABI for its own sake,
and this whole thread is a wonderful example of how F*CKING STUPID it
was to even consider it.

There are real and valid reasons to change the ABI, but for every
single one of them, there is some external issue:

 - security. We've had cases where we had an ABI that simply exposed
too much information.

 - implementation issues. Sometimes, we've done something really
really badly, and some subtle ABI issue may simply not work. This is
basically never about normal system calls used by normal applications,
though - it's about things like the whole iptables flaps etc.

 - actual real applications breaking. We've had cases where we simply
did things wrong, and portable applications broke. Then we can *try*
to fix it, and see if something else breaks from that.

And quite frankly, for all but the security case, even then we're
often better off at least having a compatibilty layer for the old
cases, even if it was bad and wrong (example: the very original linux
'select()' timeout behavior, where Linux did the documented thing, but
nobody else did. Or the various versions of 'stat()' we've had. Or the
inotify/dnotify/fsnotify things).

Occasionally some compat model may not be worth it (if the interface
is too specialized and there really is just one or two system apps
that use it), but that's very very rare to the point where it
shouldn't even be considered an issue.

Quite frankly, our most common ABI change is that we don't even
realize that something changed. And then people may or may not notice
it. And we've had cases where the same system call returned
*different* things for different subsystems, and we tried to make it
at least internally consistent.

But the "premeditated ABI change just for the reason of an ABI
change"? It's bullshit. And it's bullshit whether it shows up in
feature-removal or not.

(The whole feature-removal file is BS, for that matter, but that's a
different issue).

SO STOP DOING ABI CHANGES. WE DON'T DO THEM.

The absolute worst thing a kernel can do is "change the user-level
interfaces". It has to be done occasionally (see above), and sometimes
we do it by mistake, but anybody who does it on purpose "just because"
should not be involved in kernel development (or library development
for that matter).

                Linus
