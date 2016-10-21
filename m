From: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH 2/3] ARM: convert to generated system call tables
Date: Fri, 21 Oct 2016 14:37:08 +0100
Message-ID: <20161021133708.GA1041@n2100.armlinux.org.uk>
References: <E1bwa6s-0004ZY-4k@rmk-PC.armlinux.org.uk>
 <13702107.LdHY4HTXyY@wuerfel>
 <20161019155325.GR1041@n2100.armlinux.org.uk>
 <3851270.xZRcP9hae0@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3851270.xZRcP9hae0@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 21, 2016 at 03:06:45PM +0200, Arnd Bergmann wrote:
> Regarding the review process, I'd really hope we've improved enough
> that we can rely on the review on linux-arch/linux-api to catch
> all serious issues like system call that cannot be defined the same
> way on all architectures. If we fail at this, there is a more
> serious issue with the review process.

Well, forget linux-arch, that's hopeless because that became a very
x86-centric linux-kernel-v2, and as such I refuse to subscribe to it -
it would be a total waste of my network bandwidth because I wouldn't
have time to read it.

I somehow suspect that linux-api isn't that much better either.  What
I want from any "arch" specific thing is a heads-up to alert me to
something so that I can then choose whether to look deeper at the
subject or just ignore it completely.  I don't want to be buried under
lots of x86 specific drivel about a new feature.

So, the reality is, that I don't see any of the new syscall discussions
anymore.  The first that I'm aware of them is when they hit in some way
that becomes visible to me - which is normally sometime during the merge
window.

> Since all syscalls now go through SYSCALL_DEFINEx(), we have
> covered the hardest part (sign/zero extending short arguments),
> and a lot more people are aware of problems with struct alignment
> since it differs between i386 and x86_64 and also affects all
> ioctl interfaces. I think the last time a syscall made it in that
> didn't just work on all architectures was sync_file_range, and
> that was nine years ago.

It's not really about struct alignment, although that is a concern.
For ARM, it's more about argument alignment, and whether a 64-bit
argument gets passed in (eg) r1/r2 or r2/r3, and whether we run out
of registers to pass the arguments.

> If we hit this case, why not just use the wrapper on both EABI
> and OABI for simplicity? It's not like we care a lot about
> micro-optimizing OABI any more.

I'd still like to retain the ability to only add to EABI in the future.

> > You'll find the latest version in the next linux-next, or my current
> > for-next branch.
> 
> Ok. After rebasing my randconfig tree on today's linux-next, I needed
> this hunk to avoid a warning:
> 
> <stdin>:1143:2: error: #warning syscall sync_file_range not implemented [-Werror=cpp]

I don't get that on my builds, for EABI or OABI - for EABI:

  CHK     include/generated/bounds.h
  CC      arch/arm/kernel/asm-offsets.s
  CHK     include/generated/asm-offsets.h
  CALL    /home/rmk/git/linux-rmk/scripts/checksyscalls.sh
make[1]: Leaving directory '/home/rmk/git/build/hdrtst'

and for OABI:

  CHK     include/generated/bounds.h
  CC      arch/arm/kernel/asm-offsets.s
  CHK     include/generated/asm-offsets.h
  CALL    /home/rmk/git/linux-rmk/scripts/checksyscalls.sh
make[1]: Leaving directory '/home/rmk/git/build/hdrtst-oabi'

So, I'd like to know how you're seeing that warning.  We have never
provided sync_file_range on ARM, and we must never define it, because
the user API for it is broken.

> diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
> index 70558e4459fd..7da1bbe69e56 100644
> --- a/arch/arm/tools/syscall.tbl
> +++ b/arch/arm/tools/syscall.tbl
> @@ -355,7 +355,8 @@
>  338	common	set_robust_list		sys_set_robust_list
>  339	common	get_robust_list		sys_get_robust_list
>  340	common	splice			sys_splice
> -341	common	arm_sync_file_range	sys_sync_file_range2
> +341	common	sync_file_range2		sys_sync_file_range2
> +341	common	arm_sync_file_range
>  342	common	tee			sys_tee
>  343	common	vmsplice		sys_vmsplice
>  344	common	move_pages		sys_move_pages
> 
> (or alternatively, add "#define sync_file_range2 arm_sync_file_range"
> to uapi/asm/unistd.h).

Well, I think you have a mis-merge somewhere, beacuse uapi/asm/unistd.h
does have:

#define __NR_sync_file_range2           __NR_arm_sync_file_range

in it, which triggers this in scripts/checksyscalls.sh:

/* sync_file_range had a stupid ABI. Allow sync_file_range2 instead */
#ifdef __NR_sync_file_range2
#define __IGNORE_sync_file_range
#endif

Hence why I don't see the warning you're seeing.

> That brings up an interesting issue: it would be nice to use the
> same input file for arch/arm/ and the compat mode of arch/arm64,
> like x86 does. If we handle both oabi and arm64-compat in the same
> file, we end up with a superset of what x86 does, and we could
> use a single script again, and generate all four tables for
> ARM (native OABI, OABI-on-EABI, native EABI, EABI-on-arm64).

OABI-compat != ARM64-EABI-compat though.  They're two completely
different things.

Moreover, the syscall numbers ARM64 uses natively are completely
different from the syscall numbers 32-bit ARM uses, either for EABI
or OABI.  So I really don't see this working.

I've no idea how ARM64 deals with 32-bit binaries, so I can't comment
on how it deals with those syscalls, sorry.

> Another related case in asm-generic, which defines three tables:
> native 32-bit, native 64-bit and compat 32-bit. This one not only
> needs to have three different function pointers (e.g. sys_fcntl64,
> sys_fcntl and compat_sys_fcntl64) but also different macros (e.g.
> __NR_fcntl64 and __NR_fcntl).
> 
> Anything wrong with this approach:?
> 
> /* ARM */
> 221  oabi  fcntl64                 sys_fcntl64             sys_oabi_fcntl64
> 221  eabi  fcntl64                 sys_fcntl64             compat_sys_fcntl64
> 
> /* asm-generic */
> 25   32    fcntl64                 sys_fcntl64             compat_sys_fcntl64
> 25   64    fcntl                   sys_fcntl

Don't know, sorry.  I know virtually nothing about the differences
between the 64-bit and 32-bit ABIs, so I can't comment on anything
to do with the compat_* interfaces.

> > The syscallnr.sh script kind-of looks like a candidate, but it has
> > ARM arch specifics to it (knowing that the number of system calls
> > needs to fit within the 8-bit value plus 4-bit shift constant
> > representation of ARM ALU instructions.)  Maybe a generic version
> > without that knowledge would work, provided architectures can
> > override it.
> 
> syscallnr.sh isn't used on x86, and probably won't be needed on
> most (or all) others, right? 

Why not - the point of syscallnr.sh is to remove the need to manually
update the __NR_syscalls definition, which is a generic kernel thing.
Unless other architectures just define a fixed-size table with plenty
of extra space, they'd need to adjust __NR_syscalls when adding new
calls.


-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
