From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH 00/13] Introduce first class virtual address spaces
Date: Mon, 13 Mar 2017 17:58:01 -0700
Message-ID: <CALCETrWe8uOi3m8qXUbMA4017+rxbi1C8hzZ0bwjVHmfdE4FnQ@mail.gmail.com>
References: <20170313221415.9375-1-till.smejkal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170313221415.9375-1-till.smejkal@gmail.com>
Sender: owner-linux-mm@kvack.org
To: Till Smejkal <till.smejkal@googlemail.com>
Cc: Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Miao <realmz6@gmail.com>, Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, "David S. Miller" <davem@dave>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 13, 2017 at 3:14 PM, Till Smejkal
<till.smejkal@googlemail.com> wrote:
> This patchset extends the kernel memory management subsystem with a new
> type of address spaces (called VAS) which can be created and destroyed
> independently of processes by a user in the system. During its lifetime
> such a VAS can be attached to processes by the user which allows a process
> to have multiple address spaces and thereby multiple, potentially
> different, views on the system's main memory. During its execution the
> threads belonging to the process are able to switch freely between the
> different attached VAS and the process' original AS enabling them to
> utilize the different available views on the memory.

Sounds like the old SKAS feature for UML.

> In addition to the concept of first class virtual address spaces, this
> patchset introduces yet another feature called VAS segments. VAS segments
> are memory regions which have a fixed size and position in the virtual
> address space and can be shared between multiple first class virtual
> address spaces. Such shareable memory regions are especially useful for
> in-memory pointer-based data structures or other pure in-memory data.

This sounds rather complicated.  Getting TLB flushing right seems
tricky.  Why not just map the same thing into multiple mms?

>
>             |     VAS     |  processes  |
>     -------------------------------------
>     switch  |       468ns |      1944ns |

The solution here is IMO to fix the scheduler.

Also, FWIW, I have patches (that need a little work) that will make
switch_mm() waaaay faster on x86.

> At the current state of the development, first class virtual address spaces
> have one limitation, that we haven't been able to solve so far. The feature
> allows, that different threads of the same process can execute in different
> AS at the same time. This is possible, because the VAS-switch operation
> only changes the active mm_struct for the task_struct of the calling
> thread. However, when a thread switches into a first class virtual address
> space, some parts of its original AS are duplicated into the new one to
> allow the thread to continue its execution at its current state.

Ick.  Please don't do this.  Can we please keep an mm as just an mm
and not make it look magically different depending on which process
maps it?  If you need a trampoline (which you do, of course), just
write a trampoline in regular user code and map it manually.

--Andy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
