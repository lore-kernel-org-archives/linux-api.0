From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] prctl,x86 Add PR_[GET|SET]_CPUID for controlling the
 CPUID instruction.
Date: Mon, 12 Sep 2016 16:34:13 +0200
Message-ID: <20160912143413.ew4zry5vpw6ycpl3@pd.tnic>
References: <1473640169-24145-1-git-send-email-khuey@kylehuey.com>
 <20160912090722.2yal3mucf2x6j7pi@pd.tnic>
 <CAP045ArcuopWtoUTMFLW6zYse6OFX+SUDRqg=fn+Ty6vCPUJ8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAP045ArcuopWtoUTMFLW6zYse6OFX+SUDRqg=fn+Ty6vCPUJ8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kyle Huey <me@kylehuey.com>
Cc: Robert O'Callahan <robert@ocallahan.org>, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <len.brown@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Huang Rui <ray.huang@amd.com>, Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>, Fenghua Yu <fenghua.yu@intel.com>, "Luis R. Rodriguez" <mcgrof@kernel.o>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 12, 2016 at 07:15:16AM -0700, Kyle Huey wrote:
> Copied from PR_SET_TSC. Would you prefer something like
> disable_cpuid/disable_cpuid_and_set_flag for
> hard_disable_CPUID/disable_CPUID?

Maybe something like this:

switch_cpuid_faulting(bool on)
{
	if (on)
		msr_set_bit(MSR_MISC_FEATURES_ENABLES, 0);
	else
		msr_clear_bit(MSR_MISC_FEATURES_ENABLES, 0);
}

and call it with the respective argument.

> >> @@ -210,6 +280,15 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
> >>               update_debugctlmsr(debugctl);
> >>       }
> >>
> >> +     if (test_tsk_thread_flag(prev_p, TIF_NOCPUID) ^
> >> +         test_tsk_thread_flag(next_p, TIF_NOCPUID)) {
> >> +             /* prev and next are different */
> >> +             if (test_tsk_thread_flag(next_p, TIF_NOCPUID))
> >> +                     hard_disable_CPUID();
> >> +             else
> >> +                     hard_enable_CPUID();
> >> +     }
> >> +
> >
> > Frankly, I can't say that I'm thrilled by this: if this is a niche
> > feature which has only a very narrow usage for debugging, I'd much
> > prefer if this whole thing were implemented with a static_key which was
> > false on the majority of the systems so that __switch_to() tests it much
> > cheaply.
> >
> > Then and only then if your debugger runs arch_prctl(), it would enable
> > the key and then set_cpuid_mode() can query the MSR directly instead of
> > using another flag in the thread_info flags.
> >
> > This would keep this niche feature out of the way of the hot paths.
> 
> My code is already in the slow path in __switch_to_xtra(), along with
> other debugging features like TIF_BLOCKSTEP and TIF_NOTSC. Adding a
> bit to the mask tested in __switch_to() shouldn't affect performance
> of the hot path.

TIF_BLOCKSTEP maybe but TIF_NOTSC doesn't look like a debugging feature
to me, especially if it is called in seccomp.

And I know it is not on the hot path. But you're using precious TIF bits
for a niche feature. Practically, this is code which will be dead on the
majority of machines out there, because either the hw feature is not
there or because nobody is using it.

Maybe the virtualization aspect would gather more users of this but I
don't know what kvm guys are thinking about faulting CPUID. Let me add
them to CC.

In any case, I'd do the static_key approach because it is simpler and
less obtrusive for your purpose.

But there are plenty more people on CC, this is just me.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
