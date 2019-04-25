From: "Li, Aubrey" <aubrey.li@linux.intel.com>
Subject: Re: [PATCH v17 1/3] proc: add /proc/<pid>/arch_status
Date: Thu, 25 Apr 2019 16:24:56 +0800
Message-ID: <7ccf247b-7c70-8542-58d4-e87d7fbba569@linux.intel.com>
References: <20190421183529.9141-1-aubrey.li@linux.intel.com>
 <alpine.DEB.2.21.1904242310040.1762@nanos.tec.linutronix.de>
 <da1fcb4f-e856-d31f-7c72-76c969af3935@linux.intel.com>
 <alpine.DEB.2.21.1904250917400.1762@nanos.tec.linutronix.de>
 <1d7954b3-32e9-b3ac-1157-6b9c29ddbfe7@linux.intel.com>
 <alpine.DEB.2.21.1904251019520.1960@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1904251019520.1960@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On 2019/4/25 16:20, Thomas Gleixner wrote:
> On Thu, 25 Apr 2019, Li, Aubrey wrote:
>> On 2019/4/25 15:20, Thomas Gleixner wrote:
>>> Let the arch select CONFIG_PROC_PID_ARCH_STATUS 
>>
>> Sorry, I didn't get the point here, above you mentioned not mixing arch and proc code
>> and not enabling this on x86 right away, then how to let x86 select it?
>>
> 
> By using 'select PROC_PID_ARCH_STATUS' in the arch/xxxx/Kconfig file in the
> patch which implements the required arch function perhaps?

Oh,oh, I misunderstood, thanks for the clarification!

Thanks,
-Aubrey
