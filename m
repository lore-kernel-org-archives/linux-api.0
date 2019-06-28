From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH 1/3] mm: Introduce VM_IBT for CET legacy code bitmap
Date: Fri, 28 Jun 2019 14:49:32 -0700
Message-ID: <CBB8C19E-7F65-4D43-9783-6383478700A1@amacapital.net>
References: <20190628194158.2431-1-yu-cheng.yu@intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190628194158.2431-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel
List-Id: linux-api@vger.kernel.org



> On Jun 28, 2019, at 12:41 PM, Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
>=20
> The previous discussion of the IBT legacy code bitmap is here:
>=20
>    https://lkml.org/lkml/2019/6/6/1032
>=20
> When CET Indirect Branch Tracking (IBT) is enabled, the processor expects
> every branch target is an ENDBR instruction, or the target's address is
> marked as legacy in the legacy code bitmap.  The bitmap covers the whole
> user-mode address space (TASK_SIZE_MAX for 64-bit, TASK_SIZE for IA32),
> and each bit represents one page of linear address range.
>=20
> This patch introduces VM_IBT for the bitmap.

There=E2=80=99s no need to allocate a bit for this and to clutter up the fau=
lt code with special cases. Use _install_special_mapping(), please.  If you n=
eed to make it more flexible to cover your use case, please do so.
