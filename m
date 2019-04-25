From: "Li, Aubrey" <aubrey.li@linux.intel.com>
Subject: Re: [PATCH v17 1/3] proc: add /proc/<pid>/arch_status
Date: Thu, 25 Apr 2019 18:42:04 +0800
Message-ID: <4456cc68-5120-e820-90ed-cb5b5dfcd760@linux.intel.com>
References: <20190421183529.9141-1-aubrey.li@linux.intel.com>
 <alpine.DEB.2.21.1904242310040.1762@nanos.tec.linutronix.de>
 <da1fcb4f-e856-d31f-7c72-76c969af3935@linux.intel.com>
 <6a9e6bd9-8e1a-9fe5-135d-c7a49697b5a4@metux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6a9e6bd9-8e1a-9fe5-135d-c7a49697b5a4@metux.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On 2019/4/25 18:11, Enrico Weigelt, metux IT consult wrote:
> On 25.04.19 03:50, Li, Aubrey wrote:
> 
>>>> +>>> +config PROC_PID_ARCH_STATUS>>> +	bool "Enable
> /proc/<pid>/arch_status file">>>> Why is this switchable? x86 selects it
> if PROC_FS is enabled and all other>> architectures are absolutely not
> interested in this.> > Above and this, I was trying to avoid an empty
> arch_file on other architectures.> In previous proposal the entry only
> exists on the platform with AVX512.
> Why not making it depend on those archs that actually support it ?

Yep, I'll make it disabled by default and not switchable and let arch select it.
