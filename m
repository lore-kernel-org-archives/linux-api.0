From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v7 22/27] binfmt_elf: Extract .note.gnu.property from an ELF file
Date: Mon, 10 Jun 2019 19:24:43 +0200
Message-ID: <87lfy9cq04.fsf@oldenburg2.str.redhat.com>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
        <20190606200646.3951-23-yu-cheng.yu@intel.com>
        <20190607180115.GJ28398@e103592.cambridge.arm.com>
        <94b9c55b3b874825fda485af40ab2a6bc3dad171.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94b9c55b3b874825fda485af40ab2a6bc3dad171.camel@intel.com>
        (Yu-cheng Yu's message of "Mon, 10 Jun 2019 09:29:04 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: Dave Martin <Dave.Martin@arm.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

* Yu-cheng Yu:

> To me, looking at PT_GNU_PROPERTY and not trying to support anything is a
> logical choice.  And it breaks only a limited set of toolchains.
>
> I will simplify the parser and leave this patch as-is for anyone who wants to
> back-port.  Are there any objections or concerns?

Red Hat Enterprise Linux 8 does not use PT_GNU_PROPERTY and is probably
the largest collection of CET-enabled binaries that exists today.

My hope was that we would backport the upstream kernel patches for CET,
port the glibc dynamic loader to the new kernel interface, and be ready
to run with CET enabled in principle (except that porting userspace
libraries such as OpenSSL has not really started upstream, so many
processes where CET is particularly desirable will still run without
it).

I'm not sure if it is a good idea to port the legacy support if it's not
part of the mainline kernel because it comes awfully close to creating
our own private ABI.

Thanks,
Florian
