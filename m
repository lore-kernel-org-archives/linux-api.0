From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Fri, 8 May 2015 19:11:10 -0400
Message-ID: <554D428E.6020702@ezchip.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>	<20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org> <20150508172210.559830a9@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150508172210.559830a9-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 5/8/2015 5:22 PM, Steven Rostedt wrote:
> On Fri, 8 May 2015 14:18:24 -0700
> Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
>> On Fri, 8 May 2015 13:58:41 -0400 Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
>>
>>> A prctl() option (PR_SET_DATAPLANE) is added
>> Dumb question: what does the term "dataplane" mean in this context?  I
>> can't see the relationship between those words and what this patch
>> does.
> I was thinking the same thing. I haven't gotten around to searching
> DATAPLANE yet.
>
> I would assume we want a name that is more meaningful for what is
> happening.

The text in the commit message and the 0/6 cover letter do try to explain
the concept.  The terminology comes, I think, from networking line cards,
where the "dataplane" is the part of the application that handles all the
fast path processing of network packets, and the "control plane" is the part
that handles routing updates, etc., generally slow-path stuff.  I've probably
just been using the terms so long they seem normal to me.

That said, what would be clearer?  NO_HZ_STRICT as a superset of
NO_HZ_FULL?  Or move away from the NO_HZ terminology a bit; after all,
we're talking about no interrupts of any kind, and maybe NO_HZ is too
limited in scope?  So, NO_INTERRUPTS?  USERSPACE_ONLY?  Or look
to vendors who ship bare-metal runtimes and call it BARE_METAL?
Borrow the Tilera marketing name and call it ZERO_OVERHEAD?

Maybe BARE_METAL seems most plausible -- after DATAPLANE, to me,
of course :-)

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
