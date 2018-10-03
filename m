From: Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH v4 20/27] x86/cet/shstk: Signal handling for shadow stack
Date: Wed, 3 Oct 2018 18:46:46 +0200
Message-ID: <CAG48ez32qC1wfXGROpXxdxD84Ktj6QXNAC=Y0A6TQu=mHF-ekQ@mail.gmail.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com> <20180921150351.20898-21-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921150351.20898-21-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yu-cheng.yu@intel.com
Cc: the arch/x86 maintainers <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, hjl.tools@gmail.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.co>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 21, 2018 at 5:09 PM Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
> When setting up a signal, the kernel creates a shadow stack
> restore token at the current SHSTK address and then stores the
> token's address in the signal frame, right after the FPU state.
> Before restoring a signal, the kernel verifies and then uses the
> restore token to set the SHSTK pointer.
[...]
> +#ifdef CONFIG_X86_64
> +static int copy_ext_from_user(struct sc_ext *ext, void __user *fpu)
> +{
> +       void __user *p;
> +
> +       if (!fpu)
> +               return -EINVAL;
> +
> +       p = fpu + fpu_user_xstate_size + FP_XSTATE_MAGIC2_SIZE;
> +       p = (void __user *)ALIGN((unsigned long)p, 8);
> +
> +       if (!access_ok(VERIFY_READ, p, sizeof(*ext)))
> +               return -EFAULT;
> +
> +       if (__copy_from_user(ext, p, sizeof(*ext)))
> +               return -EFAULT;

Why do you first manually call access_ok(), then call
__copy_from_user() with the same size? Just use "if
(copy_from_user(ext, p, sizeof(*ext)))" (without underscores) and get
rid of the access_ok().

> +       if (ext->total_size != sizeof(*ext))
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int copy_ext_to_user(void __user *fpu, struct sc_ext *ext)
> +{
> +       void __user *p;
> +
> +       if (!fpu)
> +               return -EINVAL;
> +
> +       if (ext->total_size != sizeof(*ext))
> +               return -EINVAL;
> +
> +       p = fpu + fpu_user_xstate_size + FP_XSTATE_MAGIC2_SIZE;
> +       p = (void __user *)ALIGN((unsigned long)p, 8);
> +
> +       if (!access_ok(VERIFY_WRITE, p, sizeof(*ext)))
> +               return -EFAULT;
> +
> +       if (__copy_to_user(p, ext, sizeof(*ext)))
> +               return -EFAULT;

Same as above.

> +       return 0;
> +}
