From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 09/13] Move bp_type_idx to kernel/event/hw_breakpoint.c
Date: Tue, 15 Sep 2015 10:06:07 +0200
Message-ID: <20150915080607.GW16853@twins.programming.kicks-ass.net>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-10-git-send-email-palmer@dabbelt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442271047-4908-10-git-send-email-palmer@dabbelt.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: arnd@arndb.de, dhowells@redhat.com, viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Frederic Weisbecker <fweisbec@gmail.co>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 14, 2015 at 03:50:43PM -0700, Palmer Dabbelt wrote:
> This has a "#ifdef CONFIG_*" that used to be exposed to userspace.
> 
> The names in here are so generic that I don't think it's a good idea
> to expose them to userspace (or even the rest of the kernel).  Since
> there's only one kernel user, it's been moved to that file.
> 
> Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
> Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
> Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
> ---
>  include/uapi/linux/hw_breakpoint.h | 10 ----------
>  kernel/events/hw_breakpoint.c      | 10 ++++++++++
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/uapi/linux/hw_breakpoint.h b/include/uapi/linux/hw_breakpoint.h
> index b04000a2296a..7a6a5a7f9511 100644
> --- a/include/uapi/linux/hw_breakpoint.h
> +++ b/include/uapi/linux/hw_breakpoint.h
> @@ -17,14 +17,4 @@ enum {
>  	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
>  };
>  
> -enum bp_type_idx {
> -	TYPE_INST 	= 0,
> -#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
> -	TYPE_DATA	= 0,
> -#else
> -	TYPE_DATA	= 1,
> -#endif
> -	TYPE_MAX
> -};

This is rather unfortunate; you are correct that the naming is too
generic (and I tend to agree), but I think these values are required by
userspace to fill out:

  perf_event_attr::bp_type

So removing them will break things.

Frederic?
