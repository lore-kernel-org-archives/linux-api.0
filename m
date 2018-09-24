From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v4 00/27] Control Flow Enforcement: Shadow Stack
Date: Mon, 24 Sep 2018 08:25:51 -0700
Message-ID: <4e453720b77fd9c4dade6fcefc5b6f0eea396a1a.camel@intel.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
         <1ca5178d-60f3-ae70-ce95-7026ac0429b4@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1ca5178d-60f3-ae70-ce95-7026ac0429b4@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Fri, 2018-09-21 at 15:53 -0700, Dave Hansen wrote:
> On 09/21/2018 08:03 AM, Yu-cheng Yu wrote:
> > The previous version of CET patches can be found in the following
> > link:
> > 
> >   https://lkml.org/lkml/2018/8/30/608
> 
> So, this is an RFC, but there no mention of what you want comments *on*. :)
> 
> What do you want folks to review?  What needs to get settled before this
> is merged?

Thanks, Dave!

These patches passed GLIBC built-in tests and more tests HJ and I put together
at https://github.com/hjl-tools/cet-smoke-test.

I made some changes since V3 as outlined in the cover letter.
In particular there are two new patches for the VMA guard and preventing shadow
stack merging.  Does anyone have comments on those and the whole Shadow
Stack/IBT series in general?

Thanks,
Yu-cheng
