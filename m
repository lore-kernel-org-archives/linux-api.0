From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH 2/3] Introduce arch_prctl(ARCH_X86_CET_MARK_LEGACY_CODE)
Date: Sat, 29 Jun 2019 16:43:18 -0700
Message-ID: <CALCETrVvbbCWMPo7v5eYgTocaxRQPHerJ=CRjWscGxgb6QjOFA@mail.gmail.com>
References: <20190628194158.2431-1-yu-cheng.yu@intel.com> <20190628194158.2431-2-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190628194158.2431-2-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@or>
List-Id: linux-api@vger.kernel.org

> On Jun 28, 2019, at 12:41 PM, Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
>
> The CET legacy code bitmap covers the whole user-mode address space and i=
s
> located at the top of the user-mode address space.  It is allocated only
> when the first time arch_prctl(ARCH_X86_MARK_LEGACY_CODE) is called from
> an application.
>
> Introduce:
>
> arch_prctl(ARCH_X86_MARK_LEGACY_CODE, unsigned long *buf)
>    Mark an address range as IBT legacy code.

How about defining a struct for this?

The change log should discuss where the bitmap goes and how it=E2=80=99s al=
located.

> +static int alloc_bitmap(void)
> +{
> +    unsigned long addr;
> +    u64 msr_ia32_u_cet;
> +
> +    addr =3D do_mmap_locked(NULL, IBT_BITMAP_ADDR, IBT_BITMAP_SIZE,
> +                  PROT_READ | PROT_WRITE,
> +                  MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED_NOREPLACE,
> +                  VM_IBT | VM_NORESERVE, NULL);
> +
> +    if (IS_ERR((void *)addr))
> +        return addr;
> +
> +    current->thread.cet.ibt_bitmap_addr =3D addr;

addr is a constant. Why are you storing it?  If it ends up not being
constant, you should wire up mremap like the vDSO does.


> +static int set_user_bits(unsigned long __user *buf, unsigned long buf_si=
ze,
> +             unsigned long start_bit, unsigned long end_bit, unsigned lo=
ng set)
> +{
> +    unsigned long start_ul, end_ul, total_ul;
> +    int i, j, r;
> +
> +    if (round_up(end_bit, BITS_PER_BYTE) / BITS_PER_BYTE > buf_size)
> +        end_bit =3D buf_size * BITS_PER_BYTE - 1;
> +
> +    start_ul =3D start_bit / BITS_PER_LONG;
> +    end_ul =3D end_bit / BITS_PER_LONG;
> +    total_ul =3D (end_ul - start_ul + 1);
> +
> +    i =3D start_bit % BITS_PER_LONG;
> +    j =3D end_bit % BITS_PER_LONG;
> +
> +    r =3D 0;
> +    put_user_try {

put_user_try is obsolete.  Just use get_user(), etc.

Also, I must be missing something fundamental, because this series
claims that user code can't write directly to the bitmap.  This means
that this entire function shouldn't work at all.
