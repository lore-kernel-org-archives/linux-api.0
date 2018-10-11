From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v5 01/27] x86/cpufeatures: Add CPUIDs for Control Flow
 Enforcement Technology (CET)
Date: Thu, 11 Oct 2018 09:45:21 -0700
Message-ID: <c3d193c68e017230dea1398f2eac4d8a8615f75e.camel@intel.com>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com>
         <20181011151523.27101-2-yu-cheng.yu@intel.com>
         <20181011164329.GF25435@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181011164329.GF25435@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Thu, 2018-10-11 at 18:43 +0200, Borislav Petkov wrote:
> On Thu, Oct 11, 2018 at 08:14:57AM -0700, Yu-cheng Yu wrote:
> > Add CPUIDs for Control Flow Enforcement Technology (CET).
> 
> This is not "CPUIDs" but feature flags. Fix the subject too pls.

I will fix it.

Thanks,
Yu-cheng
