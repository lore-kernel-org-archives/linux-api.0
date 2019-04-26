From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v17 1/3] proc: add /proc/<pid>/arch_status
Date: Fri, 26 Apr 2019 15:38:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904261532410.1863@nanos.tec.linutronix.de>
References: <20190421183529.9141-1-aubrey.li@linux.intel.com> <alpine.DEB.2.21.1904242310040.1762@nanos.tec.linutronix.de> <da1fcb4f-e856-d31f-7c72-76c969af3935@linux.intel.com> <6a9e6bd9-8e1a-9fe5-135d-c7a49697b5a4@metux.net> <4456cc68-5120-e820-90ed-cb5b5dfcd760@linux.intel.com>
 <ee1620d5-9650-5bfa-c458-fa2d051522b1@metux.net> <alpine.DEB.2.21.1904251249200.1960@nanos.tec.linutronix.de> <c6977015-094f-ad28-bdfa-7d350247fa46@metux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c6977015-094f-ad28-bdfa-7d350247fa46@metux.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>, mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, 26 Apr 2019, Enrico Weigelt, metux IT consult wrote:
> On 25.04.19 12:50, Thomas Gleixner wrote:
> > On Thu, 25 Apr 2019, Enrico Weigelt, metux IT consult wrote:
> > 
> >> On 25.04.19 12:42, Li, Aubrey wrote:
> >>>
> >>> Yep, I'll make it disabled by default and not switchable and let arch select it.
> >>>
> >>
> >> That's not quite what I've suggested. Instead:
> >>
> >> #1: make the switch depend on the arch's that support it
> > 
> > No. That's what select is for.
> 
> Just for clarification: I've proposed the depend, because not only some
> archs will support it - and avoid masses of #ifdef's in the code.
> Therefore, it can only be enabled, when the archi supports it.

What has the way how you enable support to do with masses of #ifdefs?
Absolutely nothing.

> But if you insist in not having it configurable, letting the arch just
> select this feature, your approach makes sense.

Even if you make it configurable, then having:

     depends on ARCH1 ... ARCHN

is just wrong. That's what dependency config symbols are for which can be
selected by the arch.
 
> >> #2: still leave it selectable to the user, so somebody who doesn't need
> >>     it, can just disable it.
> > 
> > Well, the number of knobs is exploding over time and the number of people
> > actually tweaking them is close to 0. So no, we don't want to have the
> > extra tunable for everything and the world.
> 
> The great configurability often is one of the major arguments for using
> Linux in the first place.
> 
> Would you propose killing all the CONFIG_EMBEDDED/CONFIG_EXPERT
> related knobs ?

No, but adding knobs for every tiny piece of code does not make the whole
thing any better in terms of usability and maintainability.

Thanks,

	tglx
