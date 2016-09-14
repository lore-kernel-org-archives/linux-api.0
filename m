From: Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH] prctl,x86 Add PR_[GET|SET]_CPUID for controlling the
 CPUID instruction.
Date: Wed, 14 Sep 2016 20:22:42 +0100
Message-ID: <daa2c246-f1dc-de80-21ad-12cb27df6d1a@citrix.com>
References: <1473640169-24145-1-git-send-email-khuey@kylehuey.com>
 <CALCETrVJAib918qn9CL4Tvyfok-8eAHimYDabXUF=1Nsxo4-Pw@mail.gmail.com>
 <CAP045ApLcQXZP44wry8mofLz2ip1vQbvpnhCjQZsT+JxXmVEzg@mail.gmail.com>
 <CALCETrWo2XcOvnWOwU4oS-pU1+KL2PnoHa0pdFX=PA3xeM7eqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWo2XcOvnWOwU4oS-pU1+KL2PnoHa0pdFX=PA3xeM7eqg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Kyle Huey <me@kylehuey.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@redhat.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, "Michael S. Tsirkin" <mst@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>, Vlastimil Babka <vbabka@suse.cz>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Mateusz Guzik <mguzik@redhat.com>, Alex Thorlton <athorlton@sgi.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Dmitry Vyukov <dvyukov@google.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Jiri Slaby <jslaby@suse.cz>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ben Segall <bsegall@google.com>, maintainer:X86 ARCHITECTURE (32-BIT
List-Id: linux-api@vger.kernel.org

On 14/09/2016 19:52, Andy Lutomirski wrote:
> On Tue, Sep 13, 2016 at 11:13 PM, Kyle Huey <me@kylehuey.com> wrote:
>> On Mon, Sep 12, 2016 at 9:56 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> You should explicitly check that, if the
>>> feature is set under Xen PV, then the MSR actually works as
>>> advertised.  This may require talking to the Xen folks to make sure
>>> you're testing the right configuration.
>> This is interesting.  When running under Xen PV the kernel is allowed
>> to read the real value of MSR_PLATFORM_INFO and see that CPUID
>> faulting is supported.  But as you suggested, writing to
>> MSR_MISC_FEATURES_ENABLES doesn't actually enable CPUID faulting, at
>> least not in any way that works.
>>
>> It's not obvious to me how to test this, because when this feature
>> works, CPUID only faults in userspace, not in the kernel.  Is there
>> existing code somewhere that runs tests like this in userspace?
>>
> Andrew, Boris: should we expect Xen PV to do anything sensible when we
> write to MSR_PLATFORM_INFO to turn on CPUID faulting?

It will drop the write, so "No" is the answer to your question.

> Should the Xen
> PV rdmsr hooks or perhaps the hypervisor mask out the feature if it
> isn't going to be supported?

Yes.

Sadly, whomever hacked these things together in the early days decided
that the most simple solution to getting guests to boot was to allow all
domains default-read access across the CPUID and MSR space, blacklisting
out specific areas known to cause problems.  I am in the process of
sorting this stupidity^W "feature" out, but it is taking a while.

What is the purpose of the check?  I think it might be easiest to just
do the native thing, and raise a bug in general against Xen citing
"incorrect behaviour with respect to MSR_PLATFORM_INFO", get it fixed in
stable trees and pretend that this breakage never happened.

Short of having a small userspace stub check, I can't see any way to
actually test this, and I certainly would prefer to avoid workarounds
which end up like the OXSAVE detection, which is a complete disaster for
both Linux and Xen.

~Andrew
