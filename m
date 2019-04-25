From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: [PATCH v17 1/3] proc: add /proc/<pid>/arch_status
Date: Thu, 25 Apr 2019 12:46:18 +0200
Message-ID: <ee1620d5-9650-5bfa-c458-fa2d051522b1@metux.net>
References: <20190421183529.9141-1-aubrey.li@linux.intel.com>
 <alpine.DEB.2.21.1904242310040.1762@nanos.tec.linutronix.de>
 <da1fcb4f-e856-d31f-7c72-76c969af3935@linux.intel.com>
 <6a9e6bd9-8e1a-9fe5-135d-c7a49697b5a4@metux.net>
 <4456cc68-5120-e820-90ed-cb5b5dfcd760@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4456cc68-5120-e820-90ed-cb5b5dfcd760@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Li, Aubrey" <aubrey.li@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On 25.04.19 12:42, Li, Aubrey wrote:
> 
> Yep, I'll make it disabled by default and not switchable and let arch select it.
> 

That's not quite what I've suggested. Instead:

#1: make the switch depend on the arch's that support it
#2: still leave it selectable to the user, so somebody who doesn't need
    it, can just disable it.

(I, personally, tend to disable everything I don't need)


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
