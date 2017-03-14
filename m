From: Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC PATCH 00/13] Introduce first class virtual address spaces
Date: Tue, 14 Mar 2017 10:18:56 +1000
Message-ID: <73f62aca-d442-9e4b-3e2c-6269e2632e68@twiddle.net>
References: <20170313221415.9375-1-till.smejkal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <20170313221415.9375-1-till.smejkal@gmail.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Till Smejkal <till.smejkal@googlemail.com>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Miao <realmz6@gmail.com>, Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, adi-buildroot-devel@lists.sourceforge.net, linux-hexagon@vger.kernel.org, linux-ia64@vger.kernel.org, linux-metag@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-media@vger.kernel.org, linux-mtd@lists.infradead.org, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-mm@kvack.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, alsa-devel@alsa-project.org
List-Id: linux-api@vger.kernel.org

On 03/14/2017 08:14 AM, Till Smejkal wrote:
> At the current state of the development, first class virtual address spaces
> have one limitation, that we haven't been able to solve so far. The feature
> allows, that different threads of the same process can execute in different
> AS at the same time. This is possible, because the VAS-switch operation
> only changes the active mm_struct for the task_struct of the calling
> thread. However, when a thread switches into a first class virtual address
> space, some parts of its original AS are duplicated into the new one to
> allow the thread to continue its execution at its current state.
> Accordingly, parts of the processes AS (e.g. the code section, data
> section, heap section and stack sections) exist in multiple AS if the
> process has a VAS attached to it. Changes to these shared memory regions
> are synchronized between the address spaces whenever a thread switches
> between two of them. Unfortunately, in some scenarios the kernel is not
> able to properly synchronize all these shared memory regions because of
> conflicting changes. One such example happens if there are two threads, one
> executing in an attached first class virtual address space, the other in
> the tasks original address space. If both threads make changes to the heap
> section that cause expansion of the underlying vm_area_struct, the kernel
> cannot correctly synchronize these changes, because that would cause parts
> of the virtual address space to be overwritten with unrelated data. In the
> current implementation such conflicts are only detected but not resolved
> and result in an error code being returned by the kernel during the VAS
> switch operation. Unfortunately, that means for the particular thread that
> tried to make the switch, that it cannot do this anymore in the future and
> accordingly has to be killed.

This sounds like a fairly fundamental problem to me.

Is this an indication that full virtual address spaces are useless?  It would 
seem like if you only use virtual address segments then you avoid all of the 
problems with executing code, active stacks, and brk.


r~
