From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 2/3] ARM: convert to generated system call tables
Date: Fri, 21 Oct 2016 17:18:30 +0200
Message-ID: <4337157.Eff9E2riVH@wuerfel>
References: <E1bwa6s-0004ZY-4k@rmk-PC.armlinux.org.uk> <3851270.xZRcP9hae0@wuerfel> <20161021133708.GA1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161021133708.GA1041-l+eeeJia6m9URfEZ8mYm6t73F7V6hmMc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Friday, October 21, 2016 2:37:08 PM CEST Russell King - ARM Linux wrote:
> On Fri, Oct 21, 2016 at 03:06:45PM +0200, Arnd Bergmann wrote:

> > If we hit this case, why not just use the wrapper on both EABI
> > and OABI for simplicity? It's not like we care a lot about
> > micro-optimizing OABI any more.
> 
> I'd still like to retain the ability to only add to EABI in the future.

Do you mean to add an EABI specific workaround for a specific syscall
if necessary, or to stop adding OABI syscalls altogether?

For the first one, the way that the asm-generic unistd.h handles this is
to have a range of syscall numbers reserved for architecture specific
additions. I was planning to do the same here and have a number of
reserved numbers after the last architecture specific call before
the start of the newly added generic numbers.

> > (or alternatively, add "#define sync_file_range2 arm_sync_file_range"
> > to uapi/asm/unistd.h).
> 
> Well, I think you have a mis-merge somewhere, beacuse uapi/asm/unistd.h
> does have:
> 
> #define __NR_sync_file_range2           __NR_arm_sync_file_range
> 
> in it, which triggers this in scripts/checksyscalls.sh:

That was it, I had merged in my y2038 syscall series for testing and
accidentally dropped that line while rebasing the newly added
syscalls.

> > That brings up an interesting issue: it would be nice to use the
> > same input file for arch/arm/ and the compat mode of arch/arm64,
> > like x86 does. If we handle both oabi and arm64-compat in the same
> > file, we end up with a superset of what x86 does, and we could
> > use a single script again, and generate all four tables for
> > ARM (native OABI, OABI-on-EABI, native EABI, EABI-on-arm64).
> 
> OABI-compat != ARM64-EABI-compat though.  They're two completely
> different things.

For the purpose of generating the tables, I don't see much
difference: we either use the fourth column only in native
mode, or we use the fifth column to override values from
the fourth one when emulating the ABI on the "other" kernel.

> Moreover, the syscall numbers ARM64 uses natively are completely
> different from the syscall numbers 32-bit ARM uses, either for EABI
> or OABI.  So I really don't see this working.

That's similar to x86, 32-bit syscalls use the traditional numbers
with an optionally different entry point for compat mode, while
64-bit syscalls use a somewhat reduced table that now has support
for both native 64-bit and "x32" mode. x86-64 and x32 share a
syscall table but not the unistd.h list, all three generated
from syscall_64.tbl.

> I've no idea how ARM64 deals with 32-bit binaries, so I can't comment
> on how it deals with those syscalls, sorry.

ARM64 has a separate list of syscalls for compat mode in 
arch/arm64/include/asm/unistd32.h, this list has the same format
as include/asm-generic/uapi/unistd.h and must be updated manually
to match the arch/arm/ table today.

ARM64 will also likely gain native (A64 instruction set) ILP32
support soon, which will use the same numbers as the 64-bit
mode but point to the compat syscalls. This is similar to
how ARM OABI emulation works.

> > Another related case in asm-generic, which defines three tables:
> > native 32-bit, native 64-bit and compat 32-bit. This one not only
> > needs to have three different function pointers (e.g. sys_fcntl64,
> > sys_fcntl and compat_sys_fcntl64) but also different macros (e.g.
> > __NR_fcntl64 and __NR_fcntl).
> > 
> > Anything wrong with this approach:?
> > 
> > /* ARM */
> > 221  oabi  fcntl64                 sys_fcntl64             sys_oabi_fcntl64
> > 221  eabi  fcntl64                 sys_fcntl64             compat_sys_fcntl64
> > 
> > /* asm-generic */
> > 25   32    fcntl64                 sys_fcntl64             compat_sys_fcntl64
> > 25   64    fcntl                   sys_fcntl
> 
> Don't know, sorry.  I know virtually nothing about the differences
> between the 64-bit and 32-bit ABIs, so I can't comment on anything
> to do with the compat_* interfaces.

The only important factor here is that the first three columns are used
to generate unistd.h, which is the same for both native and emulated
mode, while the last two columns are used to generate two sets of
syscall tables using the same numbers. This is a common requirement
for OABI mode (native or emulated), EABI (on 32-bit or 64-bit kernels)
and the generic ABI (native 32-bit or emulated 32-bit). 

The 64-bit unistd.h is differs only in those syscalls that got replaced
with when loff_t support was added:

#define __NR_fcntl __NR3264_fcntl
#define __NR_statfs __NR3264_statfs
#define __NR_fstatfs __NR3264_fstatfs
#define __NR_truncate __NR3264_truncate
#define __NR_ftruncate __NR3264_ftruncate
#define __NR_lseek __NR3264_lseek
#define __NR_sendfile __NR3264_sendfile
#define __NR_newfstatat __NR3264_fstatat
#define __NR_fstat __NR3264_fstat
#define __NR_mmap __NR3264_mmap
#define __NR_fadvise64 __NR3264_fadvise64
#define __NR_stat __NR3264_stat
#define __NR_lstat __NR3264_lstat

64-bit architectures still use __NR_fcntl, while 32-bit architectures
use __NR_fcntl64 etc.

> > > The syscallnr.sh script kind-of looks like a candidate, but it has
> > > ARM arch specifics to it (knowing that the number of system calls
> > > needs to fit within the 8-bit value plus 4-bit shift constant
> > > representation of ARM ALU instructions.)  Maybe a generic version
> > > without that knowledge would work, provided architectures can
> > > override it.
> > 
> > syscallnr.sh isn't used on x86, and probably won't be needed on
> > most (or all) others, right? 
> 
> Why not - the point of syscallnr.sh is to remove the need to manually
> update the __NR_syscalls definition, which is a generic kernel thing.
> Unless other architectures just define a fixed-size table with plenty
> of extra space, they'd need to adjust __NR_syscalls when adding new
> calls.

Ah, makes sense. I see that x86 does this in
arch/x86/kernel/asm-offsets_64.c in a way that would also work on
other architectures, but being able to share a single script across
all architectures would also help avoid duplicating that code.

	Arnd
