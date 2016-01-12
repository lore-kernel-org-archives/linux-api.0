From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 00/13] support "task_isolation" mode for nohz_full
Date: Tue, 12 Jan 2016 12:49:46 -0500
Message-ID: <56953CBA.9090208@ezchip.com>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <56941B86.9090009@ezchip.com> <20160112100708.GA15737@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160112100708.GA15737-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

(Adding Mark to cc's)

On 01/12/2016 05:07 AM, Will Deacon wrote:
> On Mon, Jan 11, 2016 at 04:15:50PM -0500, Chris Metcalf wrote:
>> Ping!  There has been no substantive feedback to this version of
>> the patch in the week since I posted it, which optimistically suggests
>> to me that people may be satisfied with it.  If that's true, Frederic,
>> I assume this would be pulled into your tree?
>>
>> I have slightly updated the v9 patch series since this posting:
>>
>> [...]
>>
>> - Incorporated Mark Rutland's changes to convert arm64
>>    assembly to C code instead of using my own version.
> Please avoid queuing these patches -- the first is already in the arm64
> queue for 4.5 and the second was found to introduce a substantial
> performance regression on the syscall entry/exit path. I think Mark had
> an updated version to address that, so it would be easier not to have
> an old version sitting in some other queue!

I am not formally queueing them anywhere (like linux-next), though
now that you mention it, that's a pretty good idea - I'll talk to Steven
about that, assuming this merge window closes without the task
isolation stuff going in.

In the arch/tile code, we load the thread_info_flags and test them
against a bitmask before we call into C code, to avoid the various
overheads involved in the C path.  Perhaps that same strategy is all
that's needed for the arm64 code?  Hopefully you can get that
code merged up during the 4.5 window so I can use it as the new
baseline for the task isolation stuff.

Thanks!

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
