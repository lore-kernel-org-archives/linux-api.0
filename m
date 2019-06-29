From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] binfmt_elf: Extract .note.gnu.property from an ELF file
Date: Sat, 29 Jun 2019 16:51:50 -0700
Message-ID: <CALCETrUPJXW7An9EBaRQLppB3vHEQFfYP1o8h-4PSFcZt5Pa2A@mail.gmail.com>
References: <20190501211217.5039-1-yu-cheng.yu@intel.com> <20190502111003.GO3567@e103592.cambridge.arm.com>
 <CALCETrVZCzh+KFCF6ijuf4QEPn=R2gJ8FHLpyFd=n+pNOMMMjA@mail.gmail.com> <87ef3fweoq.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87ef3fweoq.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Dave Martin <Dave.Martin@arm.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromi>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 27, 2019 at 2:39 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Andy Lutomirski:
>
> > Also, I don't think there's any actual requirement that the upstream
> > kernel recognize existing CET-enabled RHEL 8 binaries as being
> > CET-enabled.  I tend to think that RHEL 8 jumped the gun here.
>
> The ABI was supposed to be finalized and everyone involved thought it
> had been reviewed by the GNU gABI community and other interested
> parties.  It had been included in binutils for several releases.
>
> From my point of view, the kernel is just a consumer of the ABI.  The
> kernel would not change an instruction encoding if it doesn't like it
> for some reason, either.

I read the only relevant gABI thing I could find easily, and it seems
to document the "gnu property" thing.  I have no problem with that.

>
> > While the upstream kernel should make some reasonble effort to make
> > sure that RHEL 8 binaries will continue to run, I don't see why we
> > need to go out of our way to keep the full set of mitigations
> > available for binaries that were developed against a non-upstream
> > kernel.
>
> They were developed against the ABI specification.
>
> I do not have a strong opinion what the kernel should do going forward.
> I just want to make clear what happened.

I admit that I'm not really clear on exactly what RHEL 8 shipped.
Some of this stuff is very much an ELF ABI that belongs to the
toolchain, but some if it is kernel API.  For example, the IBT legacy
bitmap API is very much in flux, and I don't think anything credible
has been submitted for upstream inclusion.  Does RHEL 8's glibc
attempt to cope with the case where some libraries are CET-compatible
and some are not?  If so, how does this work?  What, if any, services
does the RHEL 8 kernel provide in this direction?
