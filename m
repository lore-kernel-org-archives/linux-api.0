From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v7 22/27] binfmt_elf: Extract .note.gnu.property from an
 ELF file
Date: Tue, 18 Jun 2019 09:00:35 -0700
Message-ID: <b0491cb517ba377da6496fe91a98fdbfca4609a9.camel@intel.com>
References: <87lfy9cq04.fsf@oldenburg2.str.redhat.com>
         <20190611114109.GN28398@e103592.cambridge.arm.com>
         <031bc55d8dcdcf4f031e6ff27c33fd52c61d33a5.camel@intel.com>
         <20190612093238.GQ28398@e103592.cambridge.arm.com>
         <87imt4jwpt.fsf@oldenburg2.str.redhat.com>
         <alpine.DEB.2.21.1906171418220.1854@nanos.tec.linutronix.de>
         <20190618091248.GB2790@e103592.cambridge.arm.com>
         <20190618124122.GH3419@hirez.programming.kicks-ass.net>
         <87ef3r9i2j.fsf@oldenburg2.str.redhat.com>
         <20190618125512.GJ3419@hirez.programming.kicks-ass.net>
         <20190618133223.GD2790@e103592.cambridge.arm.com>
         <d54fe81be77b9edd8578a6d208c72cd7c0b8c1dd.camel@intel.com>
         <87pnna7v1d.fsf@oldenburg2.str.redhat.com>
         <1ca57aaae8a2121731f2dcb1a137b92eed39a0d2.camel@intel.com>
         <87blyu7ubf.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87blyu7ubf.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, N
List-Id: linux-api@vger.kernel.org

On Tue, 2019-06-18 at 18:05 +0200, Florian Weimer wrote:
> * Yu-cheng Yu:
> 
> > > I assumed that it would also parse the main executable and make
> > > adjustments based on that.
> > 
> > Yes, Linux also looks at the main executable's header, but not its
> > NT_GNU_PROPERTY_TYPE_0 if there is a loader.
> > 
> > > 
> > > ld.so can certainly provide whatever the kernel needs.  We need to tweak
> > > the existing loader anyway.
> > > 
> > > No valid statically-linked binaries exist today, so this is not a
> > > consideration at this point.
> > 
> > So from kernel, we look at only PT_GNU_PROPERTY?
> 
> If you don't parse notes/segments in the executable for CET, then yes.
> We can put PT_GNU_PROPERTY into the loader.

Thanks!
