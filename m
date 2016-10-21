From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] ARM: convert to generated system call tables
Date: Fri, 21 Oct 2016 15:06:45 +0200
Message-ID: <3851270.xZRcP9hae0@wuerfel>
References: <E1bwa6s-0004ZY-4k@rmk-PC.armlinux.org.uk> <13702107.LdHY4HTXyY@wuerfel> <20161019155325.GR1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20161019155325.GR1041@n2100.armlinux.org.uk>
Sender: linux-arch-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch <linux-arch@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wednesday, October 19, 2016 4:53:25 PM CEST Russell King - ARM Linux wrote:
> On Wed, Oct 19, 2016 at 05:30:49PM +0200, Arnd Bergmann wrote:
> > On Tuesday, October 18, 2016 8:31:38 PM CEST Russell King wrote:
> > > Convert ARM to use a similar mechanism to x86 to generate the unistd.h
> > > system call numbers and the various kernel system call tables.  This
> > > means that rather than having to edit three places (asm/unistd.h for
> > > the total number of system calls, uapi/asm/unistd.h for the system call
> > > numbers, and arch/arm/kernel/calls.S for the call table) we have only
> > > one place to edit, making the process much more simple.
> > > 
> > > The scripts have knowledge of the table padding requirements, so there's
> > > no need to worry about __NR_syscalls not fitting within the immediate
> > > constant field of ALU instructions anymore.
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > 
> > Ah, very nice!
> > 
> > I have some vague plans to do something like this for all architectures,
> > so having it done for one of the more complex examples (there are very
> > few architectures with more than one table) simplifies it a lot.
> > 
> > The next step is probably to do it for asm-generic/unistd.h, which
> > covers a lot of architectures, and then we can introduce a shared
> > table for all future additions so we only have to add the new calls
> > in one place, and change the scripts so they can merge two input
> > files into one.
> 
> Architecture maintainers like to verify that the system call works on
> their architecture before they push it out into the wild; your idea
> effectively bypasses architecture maintainer review and testing, so
> is bad.  For something as critical as system call interfaces, that
> step is critical: introducing a new system call across all architectures
> that then fails to work correctly on a particular architecture invites
> userspace to work around the problem, and the brokenness then becomes
> user API which can't be fixed.

I see your point, but I think there are serious issues with the current
approach as well:

- a lot of the less common architectures just don't get updated
  in time, out of 22 architectures that don't use asm-generic/unistd.h,
  only 12 have pwritev2 in linux-next, and only three have pkey_mprotect

- some architectures that add all syscalls sometimes make a mistake
  and forget one, e.g. alpha apparently never added __NR_bpf, but it
  did add the later __NR_execveat.

- when glibc updates their minimum supported kernel version, they
  would like to drop obsolete syscalls, but when each architecture
  adds the calls at a different time, it's hard to tell when a
  replacement syscall is guaranteed to be available

- linux-next produces warnings about missing syscalls on most
  architectures half of the time since it's impossible for an
  arch maintainer to hook up the number before the implementation
  is merged 

Regarding the review process, I'd really hope we've improved enough
that we can rely on the review on linux-arch/linux-api to catch
all serious issues like system call that cannot be defined the same
way on all architectures. If we fail at this, there is a more
serious issue with the review process.

Since all syscalls now go through SYSCALL_DEFINEx(), we have
covered the hardest part (sign/zero extending short arguments),
and a lot more people are aware of problems with struct alignment
since it differs between i386 and x86_64 and also affects all
ioctl interfaces. I think the last time a syscall made it in that
didn't just work on all architectures was sync_file_range, and
that was nine years ago.

> > > +# Where abi is:
> > > +#  common - for system calls shared between oabi and eabi
> > > +#  oabi   - for oabi-only system calls (may have compat)
> > > +#  eabi   - for eabi-only system calls
> > 
> > Why do we need all three? I would have guessed that these two are
> > sufficient to cover all cases:
> > 
> > arm	- one entry for eabi, optional second entry for oabi if different
> > oabi	- only one entry for oabi, syscall is not used on eabi
> 
> You haven't quite understood if you think the second entry gets used
> for OABI - but that's not surprising because the issues here are
> quite complex.
> 
> For OABI-only, all the oabi and first entry in common gets used.
> For EABI-only, all the eabi and first entry in common gets used.
> For EABI with OABI compat, EABI uses eabi and the first entry in common,
> but the OABI compat table uses the oabi and common entries, prefering
> the second entry where present.

Got it, I missed the fact that we support native OABI kernels.

> Yes, for the cases where we list the oabi and eabi together like you
> quoted, currently there are no differences between the system calls,
> and in my latest version, they've already been modified down to just
> a single "common" entry, leaving us without any eabi entries.
>
> However, I want to retain the ability to have separate eabi entries
> if needs be.  Such a case would be a system call which needs a helper
> for arguments passed in >4 registers on EABI but not OABI (eg, because
> of an non-naturally aligned 64-bit quantity passed in r1/r2 on OABI
> but r2/r3 in EABI.)

If we hit this case, why not just use the wrapper on both EABI
and OABI for simplicity? It's not like we care a lot about
micro-optimizing OABI any more.

> You'll find the latest version in the next linux-next, or my current
> for-next branch.

Ok. After rebasing my randconfig tree on today's linux-next, I needed
this hunk to avoid a warning:

<stdin>:1143:2: error: #warning syscall sync_file_range not implemented [-Werror=cpp]

diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 70558e4459fd..7da1bbe69e56 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -355,7 +355,8 @@
 338	common	set_robust_list		sys_set_robust_list
 339	common	get_robust_list		sys_get_robust_list
 340	common	splice			sys_splice
-341	common	arm_sync_file_range	sys_sync_file_range2
+341	common	sync_file_range2		sys_sync_file_range2
+341	common	arm_sync_file_range
 342	common	tee			sys_tee
 343	common	vmsplice		sys_vmsplice
 344	common	move_pages		sys_move_pages

(or alternatively, add "#define sync_file_range2 arm_sync_file_range"
to uapi/asm/unistd.h).

> > > diff --git a/arch/arm/tools/syscallhdr.sh b/arch/arm/tools/syscallhdr.sh
> > > new file mode 100644
> > > index 000000000000..72d4b2e3bdec
> > > --- /dev/null
> > > +++ b/arch/arm/tools/syscallhdr.sh
> > 
> > The scripts are still very similar to the x86 version. Any chance
> > we can move them to a top-level scripts/syscall/ directory and make
> > them work for both architectures? It would be good to avoid duplicating
> > them for all the other architectures too, so starting out with a common
> > version could make that easier.
> 
> The fileguard prefix would have to be specified as an additional
> argument to achieve that, but I don't see that as a big problem.

Agreed, I saw the same thing there.

> The syscalltbl.sh script is particularly architecture specific, as
> our "compat" isn't the same as x86's "compat" requirements.

That brings up an interesting issue: it would be nice to use the
same input file for arch/arm/ and the compat mode of arch/arm64,
like x86 does. If we handle both oabi and arm64-compat in the same
file, we end up with a superset of what x86 does, and we could
use a single script again, and generate all four tables for
ARM (native OABI, OABI-on-EABI, native EABI, EABI-on-arm64).

Another related case in asm-generic, which defines three tables:
native 32-bit, native 64-bit and compat 32-bit. This one not only
needs to have three different function pointers (e.g. sys_fcntl64,
sys_fcntl and compat_sys_fcntl64) but also different macros (e.g.
__NR_fcntl64 and __NR_fcntl).

Anything wrong with this approach:?

/* ARM */
221  oabi  fcntl64                 sys_fcntl64             sys_oabi_fcntl64
221  eabi  fcntl64                 sys_fcntl64             compat_sys_fcntl64

/* asm-generic */
25   32    fcntl64                 sys_fcntl64             compat_sys_fcntl64
25   64    fcntl                   sys_fcntl

> The syscallnr.sh script kind-of looks like a candidate, but it has
> ARM arch specifics to it (knowing that the number of system calls
> needs to fit within the 8-bit value plus 4-bit shift constant
> representation of ARM ALU instructions.)  Maybe a generic version
> without that knowledge would work, provided architectures can
> override it.

syscallnr.sh isn't used on x86, and probably won't be needed on
most (or all) others, right? 

Generally speaking I'd think that having a check for the ${ARCH}
variable and doing this conditionally in that one script is fine
here, if we need other architecture specific versions, they we can
use case/esac.

Similar checks exist in scripts/recordmcount.pl,
scripts/package/builddeb, scripts/tags.sh etc.

	Arnd
