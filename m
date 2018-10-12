From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH v5 07/27] mm/mmap: Create a guard area between VMAs
Date: Fri, 12 Oct 2018 12:24:25 +0200
Message-ID: <87va67799i.fsf@mid.deneb.enyo.de>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com>
        <20181011151523.27101-8-yu-cheng.yu@intel.com>
        <20167c74-9b98-6fa1-972e-bcd2c9c4a1c8@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20167c74-9b98-6fa1-972e-bcd2c9c4a1c8@linux.intel.com> (Dave
        Hansen's message of "Thu, 11 Oct 2018 13:49:09 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel
List-Id: linux-api@vger.kernel.org

* Dave Hansen:

> On 10/11/2018 08:15 AM, Yu-cheng Yu wrote:
>> Create a guard area between VMAs to detect memory corruption.
>
> This is a pretty major change that has a bunch of end-user implications.
>  It's not dependent on any debugging options and can't be turned on/off
> by individual apps, at runtime, or even at boot.
>
> Its connection to this series is also tenuous and not spelled out in the
> exceptionally terse changelog.

I agree.  We did have application failures due to the introduction of
the stack gap, so this change is likely to cause failures when applied
to existing mappings as well.
