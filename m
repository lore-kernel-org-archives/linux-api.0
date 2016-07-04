From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] Syscall arguments are unsigned long (full registers)
Date: Mon, 04 Jul 2016 16:59:35 +0200
Message-ID: <3421998.D1ABSO4c36@wuerfel>
References: <A9946D15-1553-417B-BD0C-6C65AA2122B3@amazon.com> <20160704142802.GL25121@tassilo.jf.intel.com> <ED0D99E6-1A18-4263-B227-7105313FA6AC@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ED0D99E6-1A18-4263-B227-7105313FA6AC-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tautschnig, Michael" <tautschn-vV1OtcyAfmbQXOPxS62xeg@public.gmane.org>
Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jaswinder Singh <jaswinder-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Monday, July 4, 2016 2:47:10 PM CEST Tautschnig, Michael wrote:
> Thanks a lot for the immediate feedback.
> 
> > On 4 Jul 2016, at 16:28, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > 
> > On Mon, Jul 04, 2016 at 01:52:58PM +0000, Tautschnig, Michael wrote:
> >> All syscall arguments are passed in as types of the same byte size as
> >> unsigned long (width of full registers). Using a smaller type without a
> >> cast may result in losing bits of information. In all other instances
> >> apart from the ones fixed by the patch the code explicitly introduces
> >> type casts (using, e.g., SYSCALL_DEFINE1).
> >> 
> >> While goto-cc reported these problems at build time, it is noteworthy
> >> that the calling conventions specified in the System V AMD64 ABI do
> >> ensure that parameters 1-6 are passed via registers, thus there is no
> >> implied risk of misaligned stack access.
> > 
> > Does this actually fix anything?
> > 
> 
> It will ensure the behaviour on 32 and 64-bit systems is consistent, i.e.,
> no truncation occurs. This is to ensure that future uses of these syscalls
> do not face surprises.
> 
> 

It looks to me like you are introducing a truncation, not removing
one as your comment suggests:

long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);

-long sys_arch_prctl(int code, unsigned long addr)
+long sys_arch_prctl(unsigned long code, unsigned long addr)
 {
        return do_arch_prctl(current, code, addr);
 }

This is the same truncation that we do with SYSCALL_DEFINE2(),
clearing the top 32 bits of the 'code' parameter to ensure that
user space doesn't pass data unexpectedly.

That change seems reasonable, but why not just use SYSCALL_DEFINE2()
directly for consistency with the other syscalls?

	Arnd
