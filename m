From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v8 00/14] support "task_isolation" mode for nohz_full
Date: Thu, 22 Oct 2015 16:31:44 -0400
Message-ID: <562947B0.7050103@ezchip.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <20151021123900.GD3604@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151021123900.GD3604@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/21/2015 08:39 AM, Peter Zijlstra wrote:
> Can you *please* start a new thread with each posting?
>
> This is absolutely unmanageable.

I've been explicitly threading the multiple patch series on purpose
due to this text in "git help send-email":

        --in-reply-to=<identifier>
               Make the first mail (or all the mails with --no-thread) appear
               as a reply to the given Message-Id, which avoids breaking
               threads to provide a new patch series. The second and subsequent
               emails will be sent as replies according to the
               --[no]-chain-reply-to setting.

               So for example when --thread and --no-chain-reply-to are
               specified, the second and subsequent patches will be replies to
               the first one like in the illustration below where [PATCH v2
               0/3] is in reply to [PATCH 0/2]:

               [PATCH 0/2] Here is what I did...
                 [PATCH 1/2] Clean up and tests
                 [PATCH 2/2] Implementation
                 [PATCH v2 0/3] Here is a reroll
                   [PATCH v2 1/3] Clean up
                   [PATCH v2 2/3] New tests
                   [PATCH v2 3/3] Implementation

It sounds like this is exactly the behavior you are objecting
to.  It's all one to me because I am not seeing these emails
come up in some hugely nested fashion, but just viewing the
responses that I haven't yet triaged away.

So is your recommendation to avoid the git send-email --in-reply-to
option?  If so, would you recommend including an lkml.kernel.org
link in the cover letter pointing to the previous version, or
is there something else that would make your workflow better?

If you think this is actually the wrong thing, is it worth trying
to fix the git docs to deprecate this option?  Or is it more a question
of scale, and the 80-odd patches that I've posted so far just pushed
an otherwise good system into a more dysfunctional mode?  If so,
perhaps some text in Documentation/SubmittingPatches would be
helpful here.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
