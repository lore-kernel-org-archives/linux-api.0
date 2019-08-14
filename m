From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v8 01/27] Documentation/x86: Add CET description
Date: Wed, 14 Aug 2019 10:07:45 +0200
Message-ID: <87tvakgofi.fsf@oldenburg2.str.redhat.com>
References: <20190813205225.12032-1-yu-cheng.yu@intel.com>
        <20190813205225.12032-2-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190813205225.12032-2-yu-cheng.yu@intel.com> (Yu-cheng Yu's
        message of "Tue, 13 Aug 2019 13:51:59 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel
List-Id: linux-api@vger.kernel.org

* Yu-cheng Yu:

> +ENDBR
> +    The compiler inserts an ENDBR at all valid branch targets.  Any
> +    CALL/JMP to a target without an ENDBR triggers a control
> +    protection fault.

Is this really correct?  I think ENDBR is needed only for indirect
branch targets where the jump/call does not have a NOTRACK prefix.  In
general, for security hardening, it seems best to minimize the number of
ENDBR instructions, and use NOTRACK for indirect jumps which derive the
branch target address from information that cannot be modified.

Thanks,
Florian
