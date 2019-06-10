From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v7 03/14] x86/cet/ibt: Add IBT legacy code bitmap setup
 function
Date: Mon, 10 Jun 2019 12:38:09 -0700
Message-ID: <5aa98999b1343f34828414b74261201886ec4591.camel@intel.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com>
         <20190606200926.4029-4-yu-cheng.yu@intel.com>
         <20190607080832.GT3419@hirez.programming.kicks-ass.net>
         <aa8a92ef231d512b5c9855ef416db050b5ab59a6.camel@intel.com>
         <20190607174336.GM3436@hirez.programming.kicks-ass.net>
         <b3de4110-5366-fdc7-a960-71dea543a42f@intel.com>
         <34E0D316-552A-401C-ABAA-5584B5BC98C5@amacapital.net>
         <7e0b97bf1fbe6ff20653a8e4e147c6285cc5552d.camel@intel.com>
         <25281DB3-FCE4-40C2-BADB-B3B05C5F8DD3@amacapital.net>
         <e26f7d09376740a5f7e8360fac4805488b2c0a4f.camel@intel.com>
         <3f19582d-78b1-5849-ffd0-53e8ca747c0d@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3f19582d-78b1-5849-ffd0-53e8ca747c0d@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, 2019-06-10 at 11:02 -0700, Dave Hansen wrote:
> On 6/10/19 8:22 AM, Yu-cheng Yu wrote:
> > > How does glibc know the linear address space size?  We don’t want LA64 to
> > > break old binaries because the address calculation changed.
> > 
> > When an application starts, its highest stack address is determined.
> > It uses that as the maximum the bitmap needs to cover.
> 
> Huh, I didn't think we ran code from the stack. ;)
> 
> Especially given the way that we implemented the new 5-level-paging
> address space, I don't think that expecting code to be below the stack
> is a good universal expectation.

Yes, you make a good point.  However, allowing the application manage the bitmap
is the most efficient and flexible.  If the loader finds a legacy lib is beyond
the bitmap can cover, it can deal with the problem by moving the lib to a lower
address; or re-allocate the bitmap.  If the loader cannot allocate a big bitmap
to cover all 5-level address space (the bitmap will be large), it can put all
legacy lib's at lower address.  We cannot do these easily in the kernel.

Yu-cheng
