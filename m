From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v8 01/27] Documentation/x86: Add CET description
Date: Wed, 14 Aug 2019 08:57:19 -0700
Message-ID: <84fc1b3bb2dbcf52ca79cb1141a431e087f082b5.camel@intel.com>
References: <20190813205225.12032-1-yu-cheng.yu@intel.com>
         <20190813205225.12032-2-yu-cheng.yu@intel.com>
         <87tvakgofi.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87tvakgofi.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel
List-Id: linux-api@vger.kernel.org

On Wed, 2019-08-14 at 10:07 +0200, Florian Weimer wrote:
> * Yu-cheng Yu:
> 
> > +ENDBR
> > +    The compiler inserts an ENDBR at all valid branch targets.  Any
> > +    CALL/JMP to a target without an ENDBR triggers a control
> > +    protection fault.
> 
> Is this really correct?  I think ENDBR is needed only for indirect
> branch targets where the jump/call does not have a NOTRACK prefix.

You are right.  I will fix the wording.

Yu-cheng
