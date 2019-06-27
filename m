From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] binfmt_elf: Extract .note.gnu.property from an ELF file
Date: Thu, 27 Jun 2019 11:38:45 +0200
Message-ID: <87ef3fweoq.fsf@oldenburg2.str.redhat.com>
References: <20190501211217.5039-1-yu-cheng.yu@intel.com>
        <20190502111003.GO3567@e103592.cambridge.arm.com>
        <CALCETrVZCzh+KFCF6ijuf4QEPn=R2gJ8FHLpyFd=n+pNOMMMjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVZCzh+KFCF6ijuf4QEPn=R2gJ8FHLpyFd=n+pNOMMMjA@mail.gmail.com>
        (Andy Lutomirski's message of "Wed, 26 Jun 2019 10:14:07 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravet>
List-Id: linux-api@vger.kernel.org

* Andy Lutomirski:

> Also, I don't think there's any actual requirement that the upstream
> kernel recognize existing CET-enabled RHEL 8 binaries as being
> CET-enabled.  I tend to think that RHEL 8 jumped the gun here.

The ABI was supposed to be finalized and everyone involved thought it
had been reviewed by the GNU gABI community and other interested
parties.  It had been included in binutils for several releases.

>From my point of view, the kernel is just a consumer of the ABI.  The
kernel would not change an instruction encoding if it doesn't like it
for some reason, either.

> While the upstream kernel should make some reasonble effort to make
> sure that RHEL 8 binaries will continue to run, I don't see why we
> need to go out of our way to keep the full set of mitigations
> available for binaries that were developed against a non-upstream
> kernel.

They were developed against the ABI specification.

I do not have a strong opinion what the kernel should do going forward.
I just want to make clear what happened.

Thanks,
Florian
