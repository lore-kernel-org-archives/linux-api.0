From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 00/14] support "task_isolation" mode for nohz_full
Date: Fri, 23 Oct 2015 10:49:51 +0200
Message-ID: <20151023084951.GV17308@twins.programming.kicks-ass.net>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <20151021123900.GD3604@twins.programming.kicks-ass.net>
 <562947B0.7050103@ezchip.com>
 <20151023023300.GC28099@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151023023300.GC28099@lerouge>
Sender: linux-kernel-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 23, 2015 at 04:33:02AM +0200, Frederic Weisbecker wrote:
> On Thu, Oct 22, 2015 at 04:31:44PM -0400, Chris Metcalf wrote:
> > On 10/21/2015 08:39 AM, Peter Zijlstra wrote:
> > >Can you *please* start a new thread with each posting?
> > >
> > >This is absolutely unmanageable.
> > 
> > I've been explicitly threading the multiple patch series on purpose
> > due to this text in "git help send-email":
> > 
> >        --in-reply-to=<identifier>
> >               Make the first mail (or all the mails with --no-thread) appear
> >               as a reply to the given Message-Id, which avoids breaking
> >               threads to provide a new patch series. The second and subsequent
> >               emails will be sent as replies according to the
> >               --[no]-chain-reply-to setting.
> > 
> >               So for example when --thread and --no-chain-reply-to are
> >               specified, the second and subsequent patches will be replies to
> >               the first one like in the illustration below where [PATCH v2
> >               0/3] is in reply to [PATCH 0/2]:
> > 
> >               [PATCH 0/2] Here is what I did...
> >                 [PATCH 1/2] Clean up and tests
> >                 [PATCH 2/2] Implementation
> >                 [PATCH v2 0/3] Here is a reroll
> >                   [PATCH v2 1/3] Clean up
> >                   [PATCH v2 2/3] New tests
> >                   [PATCH v2 3/3] Implementation
> > 
> > It sounds like this is exactly the behavior you are objecting
> > to.  It's all one to me because I am not seeing these emails
> > come up in some hugely nested fashion, but just viewing the
> > responses that I haven't yet triaged away.

Yeah, the git people are not per definition following lkml standards,
even though git originated 'here'. They, for a long time, also defaulted
to --chain-reply-to, which is absolutely insane.

> I personally (and I think this is the general LKML behaviour) use in-reply-to
> when I post a single patch that is a fix for a bug, or a small enhancement,
> discussed on some thread. It works well as it fits the conversation inline.
> 
> But for anything that requires significant changes, namely a patchset,
> and that includes a new version of such patchset, it's usually better
> to create a new thread. Otherwise the thread becomes an infinite mess and it
> eventually expands further the mail client columns.

Agreed, although for single patches I use my regular mailer (mutt) and
can't be arsed with tools. Also I don't actually use git-send-email
ever, so I might be biased.
