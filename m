From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 09/13] Move bp_type_idx to kernel/event/hw_breakpoint.c
Date: Wed, 4 Nov 2015 12:41:06 +0100
Message-ID: <20151104114106.GJ17308@twins.programming.kicks-ass.net>
References: <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
 <1446579994-9937-1-git-send-email-palmer@dabbelt.com>
 <1446579994-9937-10-git-send-email-palmer@dabbelt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446579994-9937-10-git-send-email-palmer@dabbelt.com>
Sender: linux-arch-owner@vger.kernel.org
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: arnd@arndb.de, dhowells@redhat.com, viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 03, 2015 at 11:46:30AM -0800, Palmer Dabbelt wrote:
> This has a "#ifdef CONFIG_*" that used to be exposed to userspace.
> 
> The names in here are so generic that I don't think it's a good idea
> to expose them to userspace (or even the rest of the kernel).  Since
> there's only one kernel user, it's been moved to that file.
> 
> Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
> Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
> Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>

Assuming you want to keep all these patches together in a tree or so.
Let me know if you want me to take this patch.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
