From: Till Smejkal <till.smejkal@googlemail.com>
Subject: Re: [RFC PATCH 00/13] Introduce first class virtual address spaces
Date: Wed, 15 Mar 2017 12:44:47 -0700
Message-ID: <20170315194447.scsf3fiwvf7z5gzc@arch-dev>
References: <CALCETrX5gv+zdhOYro4-u3wGWjVCab28DFHPSm5=BVG_hKxy3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <CALCETrX5gv+zdhOYro4-u3wGWjVCab28DFHPSm5=BVG_hKxy3A@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Till Smejkal <till.smejkal@googlemail.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Miao <realmz6@gmail.com>, Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Yoshinori Sato <ysato@users.>
List-Id: linux-api@vger.kernel.org

On Wed, 15 Mar 2017, Andy Lutomirski wrote:
> > One advantage of VAS segments is that they can be globally queried by user programs
> > which means that VAS segments can be shared by applications that not necessarily have
> > to be related. If I am not mistaken, MAP_SHARED of pure in memory data will only work
> > if the tasks that share the memory region are related (aka. have a common parent that
> > initialized the shared mapping). Otherwise, the shared mapping have to be backed by a
> > file.
> 
> What's wrong with memfd_create()?
> 
> > VAS segments on the other side allow sharing of pure in memory data by
> > arbitrary related tasks without the need of a file. This becomes especially
> > interesting if one combines VAS segments with non-volatile memory since one can keep
> > data structures in the NVM and still be able to share them between multiple tasks.
> 
> What's wrong with regular mmap?

I never wanted to say that there is something wrong with regular mmap. We just
figured that with VAS segments you could remove the need to mmap your shared data but
instead can keep everything purely in memory.

Unfortunately, I am not at full speed with memfds. Is my understanding correct that
if the last user of such a file descriptor closes it, the corresponding memory is
freed? Accordingly, memfd cannot be used to keep data in memory while no program is
currently using it, can it? To be able to do this you need again some representation
of the data in a file? Yes, you can use a tmpfs to keep the file content in memory as
well, or some DAX filesystem to keep the file content in NVM, but this always
requires that such filesystems are mounted in the system that the application is
currently running on. VAS segments on the other side would provide a functionality to
achieve the same without the need of any mounted filesystem. However, I agree, that
this is just a small advantage compared to what can already be achieved with the
existing functionality provided by the Linux kernel. I probably need to revisit the
whole idea of first class virtual address space segments before continuing with this
pacthset. Thank you very much for the great feedback.

> >> >> Ick.  Please don't do this.  Can we please keep an mm as just an mm
> >> >> and not make it look magically different depending on which process
> >> >> maps it?  If you need a trampoline (which you do, of course), just
> >> >> write a trampoline in regular user code and map it manually.
> >> >
> >> > Did I understand you correctly that you are proposing that the switching thread
> >> > should make sure by itself that its code, stack, … memory regions are properly setup
> >> > in the new AS before/after switching into it? I think, this would make using first
> >> > class virtual address spaces much more difficult for user applications to the extend
> >> > that I am not even sure if they can be used at all. At the moment, switching into a
> >> > VAS is a very simple operation for an application because the kernel will just simply
> >> > do the right thing.
> >>
> >> Yes.  I think that having the same mm_struct look different from
> >> different tasks is problematic.  Getting it right in the arch code is
> >> going to be nasty.  The heuristics of what to share are also tough --
> >> why would text + data + stack or whatever you're doing be adequate?
> >> What if you're in a thread?  What if two tasks have their stacks in
> >> the same place?
> >
> > The different ASes that a task now can have when it uses first class virtual address
> > spaces are not realized in the kernel by using only one mm_struct per task that just
> > looks differently but by using multiple mm_structs - one for each AS that the task
> > can execute in. When a task attaches a first class virtual address space to itself to
> > be able to use another AS, the kernel adds a temporary mm_struct to this task that
> > contains the mappings of the first class virtual address space and the one shared
> > with the task's original AS. If a thread now wants to switch into this attached first
> > class virtual address space the kernel only changes the 'mm' and 'active_mm' pointers
> > in the task_struct of the thread to the temporary mm_struct and performs the
> > corresponding mm_switch operation. The original mm_struct of the thread will not be
> > changed.
> >
> > Accordingly, I do not magically make mm_structs look differently depending on the
> > task that uses it, but create temporary mm_structs that only contain mappings to the
> > same memory regions.
> 
> This sounds complicated and fragile.  What happens if a heuristically
> shared region coincides with a region in the "first class address
> space" being selected?

If such a conflict happens, the task cannot use the first class address space and the
corresponding system call will return an error. However, with the current available
virtual address space size that programs can use, such conflicts are probably rare. I
could also image some additional functionality that allows a user to mark parts of
its AS to not to be shared/to be shared when switching into a VAS. With this
functionality in place, there would be no need for a heuristic in the kernel but the
user decides what to share. The kernel would by default only share code, data, and
stack and the application/libraries have to mark all the other memory regions as
shared if they need to be also available in the VAS.

> I think the right solution is "you're a user program playing virtual
> address games -- make sure you do it right".

Hm, in general I agree, that the easier and more robust solution from the kernel
perspective is to let the user do the AS setup and only provide the functionality to
create new empty ASes. Though, I think that such an interface would be much more
difficult to use than my current design. Letting the user program setup the AS has
also another implication that I currently don't have. Since I share the code and
stack regions between all ASes that are available to a process, I don't need to
save/restore stack pointers or instruction pointers when threads switch between ASes.
However, when the user will setup the AS, the kernel cannot be sure that the code and
stack will be mapped at the same virtual address and hence has to save and restore
these registers (and also potentially others since we can now basically jump between
different execution contexts).

When we first designed first class virtual address spaces, we had one special
use-case in mind, namely that one application wants to use different data sets that
it does not want/can keep in the same AS. Hence, sharing code and stack between the
different ASes that the application uses was a logic step for us because the code
memory region for example has to be available at all AS anyways since all of them
execute the same application. Sharing the stack memory region enabled the application
to keep volatile information that might be needed in the new AS on the stack which
allows easy information flow between the different ASes. 

For this patch, I extended the initial sharing of stack and code memory regions to
all memory regions that are available in the tasks original AS to also allow
dynamically linked applications and multi-threaded applications to flawlessly use
first class virtual address spaces.

To put it in a nutshell, we envisioned first class virtual address spaces to be
rather used as shareable/reusable data containers which made sharing various memory
regions that are crucial for the execution of the application a feasible
implementation decision.

Thank you all very much for the feedback. I really appreciate it.

Till

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
