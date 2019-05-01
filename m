From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH] binfmt_elf: Extract .note.gnu.property from an ELF file
Date: Wed, 01 May 2019 14:54:23 -0700
Message-ID: <1c69263279be0b2f6582e58a0bf28bc213d94693.camel@intel.com>
References: <20190501211217.5039-1-yu-cheng.yu@intel.com>
         <20190501213709.GD28500@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190501213709.GD28500@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Wed, 2019-05-01 at 14:37 -0700, Matthew Wilcox wrote:
> On Wed, May 01, 2019 at 02:12:17PM -0700, Yu-cheng Yu wrote:
> > +++ b/fs/Kconfig.binfmt
> > @@ -35,6 +35,10 @@ config COMPAT_BINFMT_ELF
> >  config ARCH_BINFMT_ELF_STATE
> >  	bool
> >  
> > +config ARCH_USE_GNU_PROPERTY
> > +	bool
> > +	depends on 64BIT
> 
> I don't think this is right.  I think you should get rid of the depends line
> and instead select the symbol from each of argh64 and x86 Kconfig files.

That makes sense.  Thanks!

Yu-cheng
