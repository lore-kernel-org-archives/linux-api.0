From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: ABI change for setitimer(2) [in feature-removal-schedule.txt]
Date: Sun, 30 Sep 2012 08:30:20 +0200
Message-ID: <CAHO5Pa2dnFH+SVkrJngR8Vn4VomsfJ00nOCzRB3+Ns4zs_pxnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sasikantha Babu <sasikanth.v19-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trevor Woerner <twoerner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[Was: Re: [GIT pull] timer fixes for 3.4]

[CC+=Trevor Woerner, after an independent mail led me to find this thread.]
[CC+=linux-api@, which really should have been CCed on the original patch]

Linus,

On Fri, Apr 13, 2012 at 12:19 AM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Thu, Apr 12, 2012 at 3:06 PM, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
>>
>> The itimer removal one is not strictly a fix, but I really wanted to
>> avoid a rebase of the urgent ones.
>
> Btw, I think that setitimer NULL pointer removal commit is crap.
>
> If people actually do rely on the NULL pointer thing, we're not
> "scheduling it for removal". And we most *definitely* aren't
> scheduling it for removal for some short timeframe like 3.6.
>
> That's not how ABI's work. If it has become something people rely on,
> it now *is* part of the ABI, and no amount of "violates the spec"
> matters what-so-ever.
>
> "The spec" is paper - and worthless. What people actually *do* is all
> that matters.

So, to restore some context some months after the last mail in this
thread, commit aa2bf9bc6414b6972b9e51903c1ce7b1f057aee2 added this to
Documentation/feature-removal-schedule.txt:

[[
What:   setitimer accepts user NULL pointer (value)
When:   3.6
Why:    setitimer is not returning -EFAULT if user pointer is NULL. This
        violates the spec.
]]

And the commit message said:

    setitimer() should return -EFAULT if called with an invalid pointer
    for value. The current code excludes a NULL pointer from this rule and
    silently uses it to stop the timer. This violates the spec.

The last sentence is rather questionable. POSIX is actually rather
silent on this point, since it doesn't say anything explicit about the
new_value==NULL case. The Linux man page is also rather silent about
it. (By the way, the current behavior seems to have been present on
Linux since 1.0.) So, I'm not sure what spec is being referred to (and
thus, what the rationale is for the change).

In any case, if the behavior here should change, the proposed change
is the wrong change. The right thing to do would be to make Linux
consistent with other systems. At least Solaris, FreeBSD, and NetBSD
(which are all the systems that I have for testing) all do the
following (though none of them seem to document it):

    If the 'new_value' of setitimer() is NULL, then (assuming
    that 'old_value' is not NULL) the call is equivalent to
    getitimer(), simply return the current value of the timer
    in 'old_value'

If Linux is to change, then it should at least be made consistent with
those other systems. There is one question if that path is taken: what
to do in the case where both 'old_value" and 'new_value' are NULL?
Solaris treats that case as a no-op; FreeBSD gives EFAULT. The FreeBSD
behavior seems a little more sensible, IMO.

Would you entertain a patch to implement FreeBSD semantics for
setitimer() where 'new_value' is NULL?

Later in this thread you said:

> I think the whole "let's deprecate this six months into the future" is
> unnecessary. Yes, it may well be worth doing for something with bigger
> consequences, but I think that for something like this, it's just
> overthinking the issue.

When it comes to ABIs, I think there *is* value in a lead time on the
change. This particular example is a good example of why. Making ABI
changes like this should be done with a bit or research and review,
rather than bluntly making the change and seeing if anybody squawks
because something breaks. If this change _had_ been instantly executed
in 3.4, then we'd have missed a chance to bring greater consistency
across systems (here, I assume that having added the EFAULT behavior,
there'd probably be resistance to changing the ABI a *second* time in
order to achieve consistency).

Thanks,

Michael


-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
