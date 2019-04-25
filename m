From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v17 1/3] proc: add /proc/<pid>/arch_status
Date: Thu, 25 Apr 2019 10:20:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904251019520.1960@nanos.tec.linutronix.de>
References: <20190421183529.9141-1-aubrey.li@linux.intel.com> <alpine.DEB.2.21.1904242310040.1762@nanos.tec.linutronix.de> <da1fcb4f-e856-d31f-7c72-76c969af3935@linux.intel.com> <alpine.DEB.2.21.1904250917400.1762@nanos.tec.linutronix.de>
 <1d7954b3-32e9-b3ac-1157-6b9c29ddbfe7@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1d7954b3-32e9-b3ac-1157-6b9c29ddbfe7@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 25 Apr 2019, Li, Aubrey wrote:
> On 2019/4/25 15:20, Thomas Gleixner wrote:
> > Let the arch select CONFIG_PROC_PID_ARCH_STATUS 
> 
> Sorry, I didn't get the point here, above you mentioned not mixing arch and proc code
> and not enabling this on x86 right away, then how to let x86 select it?
> 

By using 'select PROC_PID_ARCH_STATUS' in the arch/xxxx/Kconfig file in the
patch which implements the required arch function perhaps?

Thanks,

	tglx
