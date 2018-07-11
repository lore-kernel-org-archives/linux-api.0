From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v2 27/27] x86/cet: Add arch_prctl functions for CET
Date: Wed, 11 Jul 2018 14:02:36 -0700
Message-ID: <1531342956.15351.38.camel@intel.com>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
         <20180710222639.8241-28-yu-cheng.yu@intel.com>
         <bbd9d3d7-a456-d161-6bc6-19e555edcd01@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bbd9d3d7-a456-d161-6bc6-19e555edcd01@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Wed, 2018-07-11 at 14:19 +0200, Florian Weimer wrote:
> On 07/11/2018 12:26 AM, Yu-cheng Yu wrote:
> > 
> > arch_prctl(ARCH_CET_DISABLE, unsigned long features)
> >      Disable SHSTK and/or IBT specified in 'features'.  Return
> > -EPERM
> >      if CET is locked out.
> > 
> > arch_prctl(ARCH_CET_LOCK)
> >      Lock out CET feature.
> Isn't it a “lock in” rather than a “lock out”?

Yes, that makes more sense.  I will fix it.
