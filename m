From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched/core: expand sched_getaffinity(2) to return number
 of CPUs
Date: Fri, 5 Apr 2019 13:04:15 +0200
Message-ID: <20190405110415.GP12232@hirez.programming.kicks-ass.net>
References: <20190403200809.GA13876@avx2>
 <20190404084249.GS4038@hirez.programming.kicks-ass.net>
 <87wok83gfs.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87wok83gfs.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, mingo@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 05, 2019 at 12:16:39PM +0200, Florian Weimer wrote:

> > True; but I suppose glibc already does lots of that anyway, right? It
> > does contain the right information.
> 
> If I recall correctly my last investigation,
> /sys/devices/system/cpu/possible does not reflect the size of the
> affinity mask, either.

Strictly speaking correct; the bitmap can be longer than the highest
possible cpu number, however the remainder would be 0-padding and could
thus be stripped without issue.

So a bitmap sized to fit the max possible cpu number, should for all
practical purposes suffice.
