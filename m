From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 22/27] binfmt_elf: Extract .note.gnu.property from an
 ELF file
Date: Tue, 11 Jun 2019 12:41:09 +0100
Message-ID: <20190611114109.GN28398@e103592.cambridge.arm.com>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
 <20190606200646.3951-23-yu-cheng.yu@intel.com>
 <20190607180115.GJ28398@e103592.cambridge.arm.com>
 <94b9c55b3b874825fda485af40ab2a6bc3dad171.camel@intel.com>
 <87lfy9cq04.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87lfy9cq04.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 10, 2019 at 07:24:43PM +0200, Florian Weimer wrote:
> * Yu-cheng Yu:
> 
> > To me, looking at PT_GNU_PROPERTY and not trying to support anything is a
> > logical choice.  And it breaks only a limited set of toolchains.
> >
> > I will simplify the parser and leave this patch as-is for anyone who wants to
> > back-port.  Are there any objections or concerns?
> 
> Red Hat Enterprise Linux 8 does not use PT_GNU_PROPERTY and is probably
> the largest collection of CET-enabled binaries that exists today.

For clarity, RHEL is actively parsing these properties today?

> My hope was that we would backport the upstream kernel patches for CET,
> port the glibc dynamic loader to the new kernel interface, and be ready
> to run with CET enabled in principle (except that porting userspace
> libraries such as OpenSSL has not really started upstream, so many
> processes where CET is particularly desirable will still run without
> it).
> 
> I'm not sure if it is a good idea to port the legacy support if it's not
> part of the mainline kernel because it comes awfully close to creating
> our own private ABI.

I guess we can aim to factor things so that PT_NOTE scanning is
available as a fallback on arches for which the absence of
PT_GNU_PROPERTY is not authoritative.

Can we argue that the lack of PT_GNU_PROPERTY is an ABI bug, fix it
for new binaries and hence limit the efforts we go to to support
theoretical binaries that lack the phdrs entry?

If we can make practical simplifications to the parsing, such as
limiting the maximum PT_NOTE size that we will search for the program
properties to 1K (say), or requiring NT_NOTE_GNU_PROPERTY_TYPE_0 to sit
by itself in a single PT_NOTE then that could help minimse the exec
overheads and the number of places for bugs to hide in the kernel.

What we can do here depends on what the tools currently do and what
binaries are out there.

Cheers
---Dave
