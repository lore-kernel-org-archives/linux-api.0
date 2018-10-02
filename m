From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 02/27] x86/fpu/xstate: Change some names to
 separate XSAVES system and user states
Date: Tue, 2 Oct 2018 09:39:31 -0700
Message-ID: <6859a180-8973-e794-7ac4-1ac8f0e1c709@linux.intel.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
 <20180921150351.20898-3-yu-cheng.yu@intel.com>
 <20181002152903.GB29601@zn.tnic>
 <ba13d643c21de8e1e01a8d528457fb5dd82c42aa.camel@intel.com>
 <498c8824-9255-96be-71c2-3ebfa684a9d3@linux.intel.com>
 <20181002163736.GD29601@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002163736.GD29601@zn.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>, Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdu>
List-Id: linux-api@vger.kernel.org

On 10/02/2018 09:37 AM, Borislav Petkov wrote:
> This patch's commit message is not even close. So I'd very much
> appreciate a more verbose explanation, even if it repeats itself at
> places.

Yep, totally agree.
