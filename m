From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v7 22/27] binfmt_elf: Extract .note.gnu.property from an
 ELF file
Date: Tue, 18 Jun 2019 07:58:37 -0700
Message-ID: <d54fe81be77b9edd8578a6d208c72cd7c0b8c1dd.camel@intel.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190618133223.GD2790@e103592.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Florian Weimer <fweimer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Ole
List-Id: linux-api@vger.kernel.org

On Tue, 2019-06-18 at 14:32 +0100, Dave Martin wrote:
> On Tue, Jun 18, 2019 at 02:55:12PM +0200, Peter Zijlstra wrote:
> > On Tue, Jun 18, 2019 at 02:47:00PM +0200, Florian Weimer wrote:
> > > * Peter Zijlstra:
> > > 
> > > > I'm not sure I read Thomas' comment like that. In my reading keeping the
> > > > PT_NOTE fallback is exactly one of those 'fly workarounds'. By not
> > > > supporting PT_NOTE only the 'fine' people already shit^Hpping this out
> > > > of tree are affected, and we don't have to care about them at all.
> > > 
> > > Just to be clear here: There was an ABI document that required PT_NOTE
> > > parsing.
> > 
> > URGH.
> > 
> > > The Linux kernel does *not* define the x86-64 ABI, it only
> > > implements it.  The authoritative source should be the ABI document.
> > > 
> > > In this particularly case, so far anyone implementing this ABI extension
> > > tried to provide value by changing it, sometimes successfully.  Which
> > > makes me wonder why we even bother to mainatain ABI documentation.  The
> > > kernel is just very late to the party.
> > 
> > How can the kernel be late to the party if all of this is spinning
> > wheels without kernel support?
> 
> PT_GNU_PROPERTY is mentioned and allocated a p_type value in hjl's
> spec [1], but otherwise seems underspecified.
> 
> In particular, it's not clear whether a PT_GNU_PROPERTY phdr _must_ be
> emitted for NT_GNU_PROPERTY_TYPE_0.  While it seems a no-brainer to emit
> it, RHEL's linker already doesn't IIUC, and there are binaries in the
> wild.
> 
> Maybe this phdr type is a late addition -- I haven't attempted to dig
> through the history.
> 
> 
> For arm64 we don't have this out-of-tree legacy to support, so we can
> avoid exhausitvely searching for the note: no PT_GNU_PROPERTY ->
> no note.
> 
> So, can we do the same for x86, forcing RHEL to carry some code out of
> tree to support their legacy binaries?  Or do we accept that there is
> already a de facto ABI and try to be compatible with it?
> 
> 
> From my side, I want to avoid duplication between x86 and arm64, and
> keep unneeded complexity out of the ELF loader where possible.

Hi Florian,

The kernel looks at only ld-linux.  Other applications are loaded by ld-linux. 
So the issues are limited to three versions of ld-linux's.  Can we somehow
update those??

Thanks,
Yu-cheng
