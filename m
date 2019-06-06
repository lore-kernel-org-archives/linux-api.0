From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v7 10/14] x86/vdso/32: Add ENDBR32 to __kernel_vsyscall
 entry point
Date: Thu, 6 Jun 2019 13:25:23 -0700
Message-ID: <CALCETrUZ9vu8+9WrMcMdV6DvmB3nRQmLjd5_uDk8x1NMQUtPpg@mail.gmail.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com> <20190606200926.4029-11-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606200926.4029-11-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@or>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 6, 2019 at 1:17 PM Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
>
> From: "H.J. Lu" <hjl.tools@gmail.com>
>
> Add ENDBR32 to __kernel_vsyscall entry point.
>

Acked-by: Andy Lutomirski <luto@kernel.org>

However, you forgot your own Signed-off-by.

> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>


--Andy
