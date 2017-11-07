From: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v16 00/13] support "task_isolation" mode
Date: Tue, 7 Nov 2017 12:27:00 -0500
Message-ID: <41f63344-ff57-2474-d1ba-41d67ee4c8c4@mellanox.com>
References: <1509728692-10460-1-git-send-email-cmetcalf@mellanox.com>
 <alpine.DEB.2.20.1711060932520.9015@nuc-kabylake>
 <bd5526d4-7b6e-3b3d-79d0-5d6567c0bdf8@mellanox.com>
 <alpine.DEB.2.20.1711071109090.19523@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1711071109090.19523@nuc-kabylake>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Francis Giraldeau <francis.giraldeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/7/2017 12:10 PM, Christopher Lameter wrote:
> On Mon, 6 Nov 2017, Chris Metcalf wrote:
>
>> On 11/6/2017 10:38 AM, Christopher Lameter wrote:
>>>> What about that d*mn 1 Hz clock?
>>>>
>>>> It's still there, so this code still requires some further work before
>>>> it can actually get a process into long-term task isolation (without
>>>> the obvious one-line kernel hack).  Frederic suggested a while ago
>>>> forcing updates on cpustats was required as the last gating factor; do
>>>> we think that is still true?  Christoph was working on this at one
>>>> point - any progress from your point of view?
>>> Well if you still have the 1 HZ clock then you can simply defer the numa
>>> remote page cleanup of the page allocator to that the time you execute
>>> that tick.
>> We have to get rid of the 1 Hz tick, so we don't want to tie anything
>> else to it...
> Yes we want to get rid of the 1 HZ tick but the work on that could also
> include dealing with the remove page cleanup issue that we have deferred.
>
> Presumably we have another context there were we may be able to call into
> the cleanup code with interrupts enabled.

Right now for task isolation we run with interrupts enabled during the
initial sys_prctl() call, and call quiet_vmstat_sync() there, which 
currently
calls refresh_cpu_vm_stats(false).  In fact we could certainly pass "true"
there instead (and probably should) since we can handle dealing with
the pagesets at this time.  As we return to userspace we will test that
nothing surprising happened with vmstat; if so we jam an EAGAIN into
the syscall result value, but if not, we will be in userspace and won't need
to touch the vmstat counters until we next go back into the kernel.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
