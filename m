From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v7 22/27] binfmt_elf: Extract .note.gnu.property from an
 ELF file
Date: Mon, 17 Jun 2019 14:20:40 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1906171418220.1854@nanos.tec.linutronix.de>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>        <20190606200646.3951-23-yu-cheng.yu@intel.com>        <20190607180115.GJ28398@e103592.cambridge.arm.com>        <94b9c55b3b874825fda485af40ab2a6bc3dad171.camel@intel.com>       
 <87lfy9cq04.fsf@oldenburg2.str.redhat.com>        <20190611114109.GN28398@e103592.cambridge.arm.com>        <031bc55d8dcdcf4f031e6ff27c33fd52c61d33a5.camel@intel.com>        <20190612093238.GQ28398@e103592.cambridge.arm.com>
 <87imt4jwpt.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87imt4jwpt.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg
List-Id: linux-api@vger.kernel.org

On Mon, 17 Jun 2019, Florian Weimer wrote:
> * Dave Martin:
> > On Tue, Jun 11, 2019 at 12:31:34PM -0700, Yu-cheng Yu wrote:
> >> We can probably check PT_GNU_PROPERTY first, and fallback (based on ld-linux
> >> version?) to PT_NOTE scanning?
> >
> > For arm64, we can check for PT_GNU_PROPERTY and then give up
> > unconditionally.
> >
> > For x86, we would fall back to PT_NOTE scanning, but this will add a bit
> > of cost to binaries that don't have NT_GNU_PROPERTY_TYPE_0.  The ld.so
> > version doesn't tell you what ELF ABI a given executable conforms to.
> >
> > Since this sounds like it's largely a distro-specific issue, maybe there
> > could be a Kconfig option to turn the fallback PT_NOTE scanning on?
> 
> I'm worried that this causes interop issues similarly to what we see
> with VSYSCALL today.  If we need both and a way to disable it, it should
> be something like a personality flag which can be configured for each
> process tree separately.  Ideally, we'd settle on one correct approach
> (i.e., either always process both, or only process PT_GNU_PROPERTY) and
> enforce that.

Chose one and only the one which makes technically sense and is not some
horrible vehicle.

Everytime we did those 'oh we need to make x fly workarounds' we regretted
it sooner than later.

Thanks,

	tglx
