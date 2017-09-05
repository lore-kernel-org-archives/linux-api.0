From: Leonard Crestez <leonard.crestez@nxp.com>
Subject: Re: [PATCH v3 3/4] arm/syscalls: Optimize address limit check
Date: Tue, 5 Sep 2017 13:46:24 +0300
Message-ID: <1504608384.22554.17.camel@nxp.com>
References: <20170814213732.104301-1-thgarnie@google.com>
         <20170814213732.104301-3-thgarnie@google.com>
         <CAJcbSZG1b7ObJAv6Kmp-fR3vZRg7AdbcgqDceGB95r-72Yv0yg@mail.gmail.com>
         <CAJcbSZEd10fMp6OSgSYv_Wmt=wX5fw_Gu-_N=fM_QmP==wUMew@mail.gmail.com>
         <CAGXu5jKuk9589qap=74kPtefm=xKY0ORDH37W_3iZPd_7yc8VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKuk9589qap=74kPtefm=xKY0ORDH37W_3iZPd_7yc8VQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Thomas Garnier <thgarnie@google.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>
Cc: Will Drewry <wad@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Yonghong Song <yhs@fb.com>, Dave Martin <Dave.Martin@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@karo-electronics.de>
List-Id: linux-api@vger.kernel.org

On Tue, 2017-08-29 at 12:54 -0700, Kees Cook wrote:
> On Tue, Aug 29, 2017 at 7:32 AM, Thomas Garnier <thgarnie@google.com> wrote:
> > On Tue, Aug 22, 2017 at 9:42 AM, Thomas Garnier <thgarnie@google.com> wrote:
> > > On Mon, Aug 14, 2017 at 2:37 PM, Thomas Garnier <thgarnie@google.com> wrote:
> > > > 
> > > > Disable the generic address limit check in favor of an architecture
> > > > specific optimized implementation. The generic implementation using
> > > > pending work flags did not work well with ARM and alignment faults.
> > > > 
> > > > The address limit is checked on each syscall return path to user-mode
> > > > path as well as the irq user-mode return function. If the address limit
> > > > was changed, a function is called to report data corruption (stopping
> > > > the kernel or process based on configuration).
> > > > 
> > > > The address limit check has to be done before any pending work because
> > > > they can reset the address limit and the process is killed using a
> > > > SIGKILL signal. For example the lkdtm address limit check does not work
> > > > because the signal to kill the process will reset the user-mode address
> > > > limit.
> > > > 
> > > > Signed-off-by: Thomas Garnier <thgarnie@google.com>

> > > Any feedback?

> > CCing LW@karo-electronics.de who experienced the same issue this patch
> > proposal fix.
> > 
> > Russell: Any feedback?

> These implement Russell's suggestion. An Ack here would be nice. :) I
> can't throw these into the ARM patch tracker because they depend on
> stuff in -next (and the commit that needs to be reverted is in tglx's
> tree).
> 
> Regardless, these all test out correctly for me, so:
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Tested-by: Kees Cook <keescook@chromium.org>
> 
> In a perfect world, these 4 patches should go together with the other
> address limit check patches in tglx's tree. Thomas (Gleixner), can you
> update your tree for the merge window? At the very least, we need to
> revert 73ac5d6a2b6ac ("arm/syscalls: Check address limit on user-mode
> return"), which has caused infinite loops in some cases. Better to
> take all 4 patches in this series, though.

I also reported this infinite loop issue, several weeks ago:

https://lkml.org/lkml/2017/7/18/702

It seems that no fix was committed since then and the buggy patch made
it's way into Linus's tree after the 4.13 release.

Perhaps when there is long debate about the "proper" fix the original
patch should be reverted first, separately? In this particular case the
series fixing the bug actually includes the revert.

Anyway, I check that this v3 works on my board which was reproducing
the issue while booting from nfs (imx6sl-evk). The most likely reason
it's easy to reproduce here is a network driver issue where headers are
not correctly aligned to 4. This causes lots of alignment faults.

Tested-by: Leonard Crestez <leonard.crestez@nxp.com>

--
Regards,
Leonard
