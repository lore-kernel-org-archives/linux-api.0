From: Michal Simek <michal.simek@xilinx.com>
Subject: Re: rseq system call incompletely wired up in microblaze
Date: Mon, 15 Oct 2018 09:37:13 +0200
Message-ID: <65035668-ebce-bd8f-328d-0d3672a4a065@xilinx.com>
References: <1913468383.3666.1539535618042.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1913468383.3666.1539535618042.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Michal Simek <michal.simek@xilinx.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Mathieu,

On 14.10.2018 18:46, Mathieu Desnoyers wrote:
> Hi Michal,
> 
> I notice the following commit went into 4.18:
> 
> commit 54b0a2011dfcd2e3fe2c28062694fbbe3eb377a3
> Author: Michal Simek <michal.simek@xilinx.com>
> Date:   Thu Jun 14 08:24:39 2018 +0200
> 
>     microblaze: Add new syscalls io_pgetevents and rseq
>     
>     Wire up new syscalls io_pgetevents and rseq.
>     
>     Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> 
> It adds the rseq system call to the microblaze syscall list, but
> does not add the required hooks in the architecture code, nor does
> it select HAVE_RSEQ. So effectively, even though sys_rseq is reserved
> on microblaze, it currently always returns ENOSYS.
> 
> Is your intent to simply reserve the system call number, or to
> also get rseq to work on microblaze ?

Yes. my indentation is allocate syscall numbers for all these new
syscalls because it takes some time when new syscalls numbers are
propagated to toolchain builds.
I can't see a problem if ENOSYS is returned because it is proper
reaction when syscall is not implemented.

Thanks,
Michal
