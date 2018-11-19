From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v6 09/11] x86/vsyscall/32: Add ENDBR32 to vsyscall
 entry point
Date: Mon, 19 Nov 2018 14:40:00 -0800
Message-ID: <6bb299d4a59540727cd27bf015b2b2ff5014aab4.camel@intel.com>
References: <20181119214934.6174-1-yu-cheng.yu@intel.com>
         <20181119214934.6174-10-yu-cheng.yu@intel.com>
         <CALCETrUkXMHcwX8u+mGDD9Vj+iQE7CRMHL7jQnfAT6WXV8SBEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUkXMHcwX8u+mGDD9Vj+iQE7CRMHL7jQnfAT6WXV8SBEQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H. J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.am>
List-Id: linux-api@vger.kernel.org

On Mon, 2018-11-19 at 14:23 -0800, Andy Lutomirski wrote:
> On Mon, Nov 19, 2018 at 1:55 PM Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
> > 
> > From: "H.J. Lu" <hjl.tools@gmail.com>
> > 
> > Add ENDBR32 to vsyscall entry point.
> 
> $SUBJECT should be "x86/vdso/32: Add ENDBR32 to __kernel_vsyscall entry
> point".

I will fix it.

Yu-cheng
