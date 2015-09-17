From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [RFC PATCH v2 6/9] arm: allocate sys_membarrier system call
 number
Date: Thu, 17 Sep 2015 14:49:09 +0100
Message-ID: <20150917134908.GP21084@n2100.arm.linux.org.uk>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1441642556-30972-7-git-send-email-mathieu.desnoyers@efficios.com>
 <2106738851.9514.1442428030540.JavaMail.zimbra@efficios.com>
 <20150917131316.GO21084@n2100.arm.linux.org.uk>
 <886006042.10465.1442497073084.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <886006042.10465.1442497073084.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Jeanson <mjeanson-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 17, 2015 at 01:37:53PM +0000, Mathieu Desnoyers wrote:
> ----- On Sep 17, 2015, at 9:13 AM, Russell King - ARM Linux linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org wrote:
> 
> > On Wed, Sep 16, 2015 at 06:27:10PM +0000, Mathieu Desnoyers wrote:
> >> ----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers
> >> mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:
> >> 
> >> > [ Untested on this architecture. To try it out: fetch linux-next/akpm,
> >> >  apply this patch, build/run a membarrier-enabled kernel, and do make
> >> >  kselftest. ]
> >> 
> >> Hi,
> >> 
> >> We tested the system call on our ARM board (Wandboard, SoC
> >> Freescale i.MX6 Quad) by applying this patch on top of
> >> Linux 4.3-rc1. Both the membarrier kselftest and
> >> Userspace RCU regression tests (the latter manually wired up
> >> on sys_membarrier) work fine.
> >> 
> >> Tested-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> >> 
> >> sys_membarrier has been pulled into Linux 4.3-rc1. Please
> >> feel free to wire it up on ARM.
> > 
> > Well, it's not going to end up with 388, but 389, because we also have
> > userfaultfd added in the same merge window, and I follow the x86
> > syscall ordering when adding to ARM.
> 
> That's fine with me!

I'll also merge my patch after -rc2's out, so expect it to appear in
linux-next next week.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
