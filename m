From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v6 01/26] Documentation/x86: Add CET description
Date: Tue, 20 Nov 2018 12:36:38 -0800
Message-ID: <16a0261fbe4b31e2f42b552d6a991a1116d398c2.camel@intel.com>
References: <20181119214809.6086-1-yu-cheng.yu@intel.com>
         <20181119214809.6086-2-yu-cheng.yu@intel.com>
         <20181120095253.GA119911@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181120095253.GA119911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Tue, 2018-11-20 at 10:52 +0100, Ingo Molnar wrote:
> * Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
> 
> > +X86 Documentation
> > [...]
> > +
> > +At run time, /proc/cpuinfo shows the availability of SHSTK and IBT.
> 
> What is the rough expected performance impact of CET on average function 
> call frequency user applications and the kernel itself?

I don't have any conclusive numbers yet; but since currently only user-mode
protection is implemented, I suspect any impact would be most likely to the
application.  The kernel would spend some small amount of time on the setup of
CET.

Yu-cheng
