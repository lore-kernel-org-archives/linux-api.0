From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH] binfmt_elf: Extract .note.gnu.property from an ELF file
Date: Wed, 26 Jun 2019 10:30:24 -0700
Message-ID: <9f7787e255ef859a39ea87e70132a50572f4db65.camel@intel.com>
References: <20190501211217.5039-1-yu-cheng.yu@intel.com>
         <20190502111003.GO3567@e103592.cambridge.arm.com>
         <CALCETrVZCzh+KFCF6ijuf4QEPn=R2gJ8FHLpyFd=n+pNOMMMjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVZCzh+KFCF6ijuf4QEPn=R2gJ8FHLpyFd=n+pNOMMMjA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Dave Martin <Dave.Martin@arm.com>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.ami>
List-Id: linux-api@vger.kernel.org

On Wed, 2019-06-26 at 10:14 -0700, Andy Lutomirski wrote:
> On Thu, May 2, 2019 at 4:10 AM Dave Martin <Dave.Martin@arm.com> wrote:
> > 
> > On Wed, May 01, 2019 at 02:12:17PM -0700, Yu-cheng Yu wrote:
> > > An ELF file's .note.gnu.property indicates features the executable file
> > > can support.  For example, the property GNU_PROPERTY_X86_FEATURE_1_AND
> > > indicates the file supports GNU_PROPERTY_X86_FEATURE_1_IBT and/or
> > > GNU_PROPERTY_X86_FEATURE_1_SHSTK.
> > > 
[...]
> 
> Where did PT_GNU_PROPERTY come from?  Are there actual docs for it?
> Can someone here tell us what the actual semantics of this new ELF
> thingy are?  From some searching, it seems like it's kind of an ELF
> note but kind of not.  An actual description would be fantastic.
> 
> Also, I don't think there's any actual requirement that the upstream
> kernel recognize existing CET-enabled RHEL 8 binaries as being
> CET-enabled.  I tend to think that RHEL 8 jumped the gun here.  While
> the upstream kernel should make some reasonble effort to make sure
> that RHEL 8 binaries will continue to run, I don't see why we need to
> go out of our way to keep the full set of mitigations available for
> binaries that were developed against a non-upstream kernel.
> 
> In fact, if we handle the legacy bitmap differently from RHEL 8, we
> may *have* to make sure that we don't recognize existing RHEL 8
> binaries as CET-enabled.

We have worked out the issue.  Linux will look at only PT_GNU_PROPERTY, which is
a shortcut pointing directly to .note.gnu.property.  I have an updated patch,
and will send it out (although it is not yet perfect).

The Linux gABI extension draft is here: https://github.com/hjl-tools/linux-abi/w
iki/linux-abi-draft.pdf.

Yu-cheng
