From: Kyle Huey <me@kylehuey.com>
Subject: Re: [PATCH v3 3/3] x86,arch_prctl Add ARCH_[GET|SET]_CPUID for
 controlling the CPUID instruction
Date: Thu, 15 Sep 2016 22:30:08 -0700
Message-ID: <CAP045AoHaa_ogg_d_yv85R6t+Yt77b=X=mzxm-433B1fFTeF3g@mail.gmail.com>
References: <20160915233324.6060-1-khuey@kylehuey.com> <20160915233324.6060-4-khuey@kylehuey.com>
 <CALCETrVzcXHzQotpkFb7kyBn5Q1o0J7TyHezTuO0LDN5xfv5uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVzcXHzQotpkFb7kyBn5Q1o0J7TyHezTuO0LDN5xfv5uw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Robert O'Callahan <robert@ocallahan.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Safonov <0x7f454c46@gmail.com>, Borislav Petkov <bp@suse.de>, Linux API <linux-api@vger.kernel.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Shuah Khan <shuah@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <len.brown@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 15, 2016 at 5:07 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Sep 15, 2016 at 4:33 PM, Kyle Huey <me@kylehuey.com> wrote:
>> +int get_cpuid_mode(unsigned long adr)
>> +{
>> +       unsigned int val;
>> +
>> +       if (test_thread_flag(TIF_NOCPUID))
>> +               val = ARCH_CPUID_SIGSEGV;
>> +       else
>> +               val = ARCH_CPUID_ENABLE;
>> +
>> +       return put_user(val, (unsigned int __user *)adr);
>> +}
>
> Can we just do:
>
> if (arg2 != 0)
>   return -EINVAL;
> else
>  return test_thread_flag(TIF_NOCPUID) ? ARCH_CPUID_SIGSEGBV : ARCH_CPUID_ENABLE;

We could.  I copied the pattern of PR_GET_TSC here, but I don't feel
strongly about it.

>> diff --git a/tools/testing/selftests/x86/cpuid-fault.c b/tools/testing/selftests/x86/cpuid-fault.c
>> new file mode 100644
>> index 0000000..a9f3f68
>> --- /dev/null
>> +++ b/tools/testing/selftests/x86/cpuid-fault.c
>> @@ -0,0 +1,234 @@
>> +
>> +/*
>> + * Tests for arch_prctl(ARCH_GET_CPUID, ...) / prctl(ARCH_SET_CPUID, ...)
>> + *
>> + * Basic test to test behaviour of ARCH_GET_CPUID and ARCH_SET_CPUID
>> + */
>> +
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <unistd.h>
>> +#include <signal.h>
>> +#include <inttypes.h>
>> +#include <cpuid.h>
>> +#include <errno.h>
>> +#include <sys/wait.h>
>> +
>> +#include <sys/prctl.h>
>> +#include <linux/prctl.h>
>> +
>> +const char *cpuid_names[] = {
>> +       [0] = "[not set]",
>
> Is 0 even possible?

Only if the call fails.

- Kyle
