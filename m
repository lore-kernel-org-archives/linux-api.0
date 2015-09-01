From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [RFC PATCH 1/9] powerpc: allocate sys_membarrier system call
 number
Date: Tue, 01 Sep 2015 11:00:43 +1000
Message-ID: <1441069243.26730.3.camel@ellerman.id.au>
References: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com>
	 <1440698215-8355-2-git-send-email-mathieu.desnoyers@efficios.com>
	 <1441004045.5735.8.camel@ellerman.id.au>
	 <131898944.32688.1441035174419.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <131898944.32688.1441035174419.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-08-31 at 15:32 +0000, Mathieu Desnoyers wrote:
> ----- On Aug 31, 2015, at 2:54 AM, Michael Ellerman mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org wrote:
> 
> > On Thu, 2015-08-27 at 13:56 -0400, Mathieu Desnoyers wrote:
> >> Allow it to be used from SPU, since it should not have unwanted
> >> side-effects.

> > $ ./membarrier_test
> > membarrier MEMBARRIER_CMD_QUERY syscall available.
> > membarrier: MEMBARRIER_CMD_SHARED success.
> > membarrier: tests done!
> > 
> > Which looks good.
> > 
> > Assuming the membarrier support hits 4.3, I'll take this via my tree for 4.3
> > also.
> 
> Great! I'll take care of your comments about self-tests,

Thanks. None of them are critical so we can always fix them later.

cheers
