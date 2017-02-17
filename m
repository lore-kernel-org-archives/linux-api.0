From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHv3 33/33] mm, x86: introduce PR_SET_MAX_VADDR and PR_GET_MAX_VADDR
Date: Fri, 17 Feb 2017 08:50:31 -0800
Message-ID: <CALCETrVKKU_eJVH3scF=89z98dba8iHwuNfdUPE9Hx=-3b_+Pg@mail.gmail.com>
References: <20170217141328.164563-1-kirill.shutemov@linux.intel.com> <20170217141328.164563-34-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170217141328.164563-34-kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 17, 2017 at 6:13 AM, Kirill A. Shutemov
<kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> This patch introduces two new prctl(2) handles to manage maximum virtual
> address available to userspace to map.
>
> On x86, 5-level paging enables 56-bit userspace virtual address space.
> Not all user space is ready to handle wide addresses. It's known that
> at least some JIT compilers use higher bits in pointers to encode their
> information. It collides with valid pointers with 5-level paging and
> leads to crashes.
>
> The patch aims to address this compatibility issue.
>
> MM would use the address as upper limit of virtual address available to
> map by userspace, instead of TASK_SIZE.
>
> The limit will be equal to TASK_SIZE everywhere, but the machine
> with 5-level paging enabled. In this case, the default limit would be
> (1UL << 47) - PAGE_SIZE. It=E2=80=99s current x86-64 TASK_SIZE_MAX with 4=
-level
> paging which known to be safe.


I think this patch need to be split up.  In particular, the addition
and use of mmap_max_addr() should be its own patch that doesn't change
any semantics.

> diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mm=
u_context.h
> index 306c7e12af55..50bdfd6ab866 100644
> --- a/arch/x86/include/asm/mmu_context.h
> +++ b/arch/x86/include/asm/mmu_context.h
> @@ -117,6 +117,7 @@ static inline int init_new_context(struct task_struct=
 *tsk,
>         }
>         #endif
>         init_new_context_ldt(tsk, mm);
> +       mm->context.max_vaddr =3D MAX_VADDR_DEFAULT;

Is this actually correct for 32-bit binaries?  Although, given the
stuff Dmitry is working on, it might pay to separately track the
32-bit and 64-bit limits per mm.  If you haven't been following it,
Dmitry is trying to fix a bug in which an explicit 32-bit syscall
(int80 or similar) in an otherwise 64-bit process can allocate a VMA
above 4GB that gets truncated.

Also, why the macro?  Why not just put the number in here?

> -#define TASK_SIZE_MAX  ((1UL << 47) - PAGE_SIZE)
> +#define TASK_SIZE_MAX  ((1UL << __VIRTUAL_MASK_SHIFT) - PAGE_SIZE)

This should be in the

> -#define STACK_TOP              TASK_SIZE
> +#define STACK_TOP              mmap_max_addr()

Off the top of my head, this looks wrong.  The 32-bit check got lost, I thi=
nk.

> +unsigned long set_max_vaddr(unsigned long addr)
> +{

Perhaps this function could set a different field depending on
is_compat_syscall().


Anyway, can you and Dmitry try to reconcile your patches?
