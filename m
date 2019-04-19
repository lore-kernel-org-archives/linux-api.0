From: "Li, Aubrey" <aubrey.li@linux.intel.com>
Subject: Re: [PATCH v15 1/3] /proc/pid/status: Add support for architecture
 specific output
Date: Fri, 19 Apr 2019 19:42:01 +0800
Message-ID: <547c8966-8252-01b9-a807-5e28f91acf6b@linux.intel.com>
References: <20190416063250.7514-1-aubrey.li@linux.intel.com>
 <20190416160143.8292ced993dc803aae7fa0da@linux-foundation.org>
 <CALCETrUjF9PBmkzH1J86vw4ZW785DP7FtcT+gcSrx29=BUnjoQ@mail.gmail.com>
 <alpine.DEB.2.21.1904181500100.3174@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1904181500100.3174@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Arjan van de Ven <arjan@linux.intel.com>, Alexey Dobriyan <adobriyan@gmail.com>, aubrey.li@intel.com, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 2019/4/18 21:00, Thomas Gleixner wrote:
> On Wed, 17 Apr 2019, Andy Lutomirski wrote:
> 
>> On Tue, Apr 16, 2019 at 4:01 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>> On Tue, 16 Apr 2019 14:32:48 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:
>>>
>>>> The architecture specific information of the running processes could
>>>> be useful to the userland. Add support to examine process architecture
>>>> specific information externally.
>>>
>>> The implementation looks just fine to me.  Have you had any feedback on
>>> the overall desirability of adding this feature?
>>
>> I think I've been the most outspoken, and my not-all-that-strong
>> opinion is that I don't really like it.  /proc/PID/status is already a
>> bit of a mess, and I don't think we really want it to be a mess that
>> is different on different architectures.  Hence my suggestion of
>> /proc/PID/x86_status instead.  Or we could do /proc/PID/arch_status, I
> 
> arch_status looks like the right thing to do.

Thanks Andy and Thomas, let me change the patch to use arch_status instead.
