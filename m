From: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Subject: Re: [RFC PATCH 4/9] mips: allocate sys_membarrier system call number
Date: Fri, 28 Aug 2015 09:40:34 +0200
Message-ID: <20150828074034.GA22604@linux-mips.org>
References: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1440698215-8355-5-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440698215-8355-5-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 27, 2015 at 01:56:50PM -0400, Mathieu Desnoyers wrote:

> [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>   apply this patch, build/run a membarrier-enabled kernel, and do make
>   kselftest. ]
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
> CC: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
> ---
>  arch/mips/include/uapi/asm/unistd.h | 15 +++++++++------
>  arch/mips/kernel/scall32-o32.S      |  1 +
>  arch/mips/kernel/scall64-64.S       |  1 +
>  arch/mips/kernel/scall64-n32.S      |  1 +
>  arch/mips/kernel/scall64-o32.S      |  1 +
>  5 files changed, 13 insertions(+), 6 deletions(-)

Looking good assuming there is no compat syscall required.

  Ralf
