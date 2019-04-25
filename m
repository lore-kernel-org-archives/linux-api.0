From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v17 1/3] proc: add /proc/<pid>/arch_status
Date: Thu, 25 Apr 2019 12:50:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904251249200.1960@nanos.tec.linutronix.de>
References: <20190421183529.9141-1-aubrey.li@linux.intel.com> <alpine.DEB.2.21.1904242310040.1762@nanos.tec.linutronix.de> <da1fcb4f-e856-d31f-7c72-76c969af3935@linux.intel.com> <6a9e6bd9-8e1a-9fe5-135d-c7a49697b5a4@metux.net> <4456cc68-5120-e820-90ed-cb5b5dfcd760@linux.intel.com>
 <ee1620d5-9650-5bfa-c458-fa2d051522b1@metux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ee1620d5-9650-5bfa-c458-fa2d051522b1@metux.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>, mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 25 Apr 2019, Enrico Weigelt, metux IT consult wrote:

> On 25.04.19 12:42, Li, Aubrey wrote:
> > 
> > Yep, I'll make it disabled by default and not switchable and let arch select it.
> > 
> 
> That's not quite what I've suggested. Instead:
> 
> #1: make the switch depend on the arch's that support it

No. That's what select is for.

> #2: still leave it selectable to the user, so somebody who doesn't need
>     it, can just disable it.

Well, the number of knobs is exploding over time and the number of people
actually tweaking them is close to 0. So no, we don't want to have the
extra tunable for everything and the world.

Thanks,

	tglx
