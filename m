From: Kyle Huey <me@kylehuey.com>
Subject: Re: [PATCH] prctl,x86 Add PR_[GET|SET]_CPUID for controlling the
 CPUID instruction.
Date: Tue, 13 Sep 2016 11:42:33 -0700
Message-ID: <CAP045AqzCq-3LOXjjFtRywT48-CmOYzhZwcY3XLOs8Z9cD2Gmg@mail.gmail.com>
References: <1473640169-24145-1-git-send-email-khuey@kylehuey.com>
 <20160912090722.2yal3mucf2x6j7pi@pd.tnic> <CAP045ArcuopWtoUTMFLW6zYse6OFX+SUDRqg=fn+Ty6vCPUJ8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAP045ArcuopWtoUTMFLW6zYse6OFX+SUDRqg=fn+Ty6vCPUJ8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Robert O'Callahan <robert@ocallahan.org>, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <len.brown@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Huang Rui <ray.huang@amd.com>, Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>, Fenghua Yu <fenghua.yu@intel.com>, "Luis R. Rodriguez" <mcgrof@kernel>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 12, 2016 at 7:15 AM, Kyle Huey <me@kylehuey.com> wrote:
> On Mon, Sep 12, 2016 at 2:07 AM, Borislav Petkov <bp@suse.de> wrote:
>> On Sun, Sep 11, 2016 at 05:29:23PM -0700, Kyle Huey wrote:
>>> @@ -2162,6 +2168,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>>>       case PR_SET_TSC:
>>>               error = SET_TSC_CTL(arg2);
>>>               break;
>>> +     case PR_GET_CPUID:
>>> +             error = GET_CPUID_CTL(arg2);
>>> +             break;
>>> +     case PR_SET_CPUID:
>>> +             error = SET_CPUID_CTL(arg2);
>>> +             break;
>>>       case PR_TASK_PERF_EVENTS_DISABLE:
>>>               error = perf_event_task_disable();
>>>               break;
>>
>> This whole fun should be in arch_prctl() as it is arch-specific.
>
> Yeah, I was debating about that, and did it this way because of
> PR_SET_TSC.  Will fix.

arch_prctl is not yet exposed on 32 bit x86, so we'll have to add that
as well to do this.

- Kyle
