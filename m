From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v5 00/27] Control Flow Enforcement: Shadow Stack
Date: Thu, 11 Oct 2018 12:29:03 -0700
Message-ID: <d068f923d45c26e4c0f91f4cf0eef8a02ae4a6b0.camel@intel.com>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com>
         <109d1600-340e-e3c2-ba11-1f6096212540@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <109d1600-340e-e3c2-ba11-1f6096212540@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Thu, 2018-10-11 at 12:21 -0700, Dave Hansen wrote:
> On 10/11/2018 08:14 AM, Yu-cheng Yu wrote:
> > The previous version of CET Shadow Stack patches is at the following
> > link:
> > 
> >   https://lkml.org/lkml/2018/9/21/776
> 
> Why are you posting these?  Do you want more review?  Do you simply want
> the series applied?

Thanks, Dave!


Hi Maintainers,

If there are no more major issues, can we get these applied?

Currently the IBT bitmap allocation (in the IBT series) works with GLIBC.
If GLIBC developers agree to mmap() the bitmap in dlopen(), I will submit an
additional patch to change how the kernel handles it.

Thanks,
Yu-cheng
