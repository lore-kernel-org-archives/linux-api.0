From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: rseq system call incompletely wired up in microblaze
Date: Sun, 14 Oct 2018 12:46:58 -0400 (EDT)
Message-ID: <1913468383.3666.1539535618042.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Simek <michal.simek@xilinx.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Michal,

I notice the following commit went into 4.18:

commit 54b0a2011dfcd2e3fe2c28062694fbbe3eb377a3
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Thu Jun 14 08:24:39 2018 +0200

    microblaze: Add new syscalls io_pgetevents and rseq
    
    Wire up new syscalls io_pgetevents and rseq.
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>

It adds the rseq system call to the microblaze syscall list, but
does not add the required hooks in the architecture code, nor does
it select HAVE_RSEQ. So effectively, even though sys_rseq is reserved
on microblaze, it currently always returns ENOSYS.

Is your intent to simply reserve the system call number, or to
also get rseq to work on microblaze ?

A good example of the architecture changes required to
wire up rseq can be found here:

commit 9d6d99e3ac8ccfd0945edb3c83cd912838775056
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Sat Jun 30 10:54:15 2018 +0200

    s390: wire up rseq system call
    
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Also, please make sure the tools/testing/selftests/rseq/ tests
pass before pushing a commit enabling it for your architecture.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
