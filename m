From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v8 00/14] support "task_isolation" mode for nohz_full
Date: Fri, 23 Oct 2015 11:04:59 +0200
Message-ID: <20151023090459.GW17308@twins.programming.kicks-ass.net>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <20151021123900.GD3604@twins.programming.kicks-ass.net>
 <562947B0.7050103@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <562947B0.7050103-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 22, 2015 at 04:31:44PM -0400, Chris Metcalf wrote:

> So is your recommendation to avoid the git send-email --in-reply-to
> option?  If so, would you recommend including an lkml.kernel.org
> link in the cover letter pointing to the previous version, or
> is there something else that would make your workflow better?

Mostly people don't bother with pointing to previous versions, and if
they have the same 0/x subject, they're typically trivial to find
anyway.

But if you really feel the need for explicit references to previous
versions, then yes, lkml.kernel.org/r/ links are preferred over pretty
much anything else I think.

> If you think this is actually the wrong thing, is it worth trying
> to fix the git docs to deprecate this option?

As said in the other email; git has different standards than lkml. By
now we're just one of many many users of git.

> Or is it more a question
> of scale, and the 80-odd patches that I've posted so far just pushed
> an otherwise good system into a more dysfunctional mode?  If so,
> perhaps some text in Documentation/SubmittingPatches would be
> helpful here.

Documentation/email-clients.txt maybe.
