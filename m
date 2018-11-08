From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 04/27] x86/fpu/xstate: Add XSAVES system states for
 shadow stack
Date: Thu, 8 Nov 2018 14:00:54 -0800
Message-ID: <20181108220054.GP3074@bombadil.infradead.org>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com>
 <20181011151523.27101-5-yu-cheng.yu@intel.com>
 <CALCETrVAe8R=crVHoD5QmbN-gAW+V-Rwkwe4kQP7V7zQm9TM=Q@mail.gmail.com>
 <4295b8f786c10c469870a6d9725749ce75dcdaa2.camel@intel.com>
 <CALCETrUKzXYzRrWRdi8Z7AdAF0uZW5Gs7J4s=55dszoyzc29rw@mail.gmail.com>
 <043a17ef-dc9f-56d2-5fba-1a58b7b0fd4d@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <043a17ef-dc9f-56d2-5fba-1a58b7b0fd4d@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Yu-cheng Yu <yu-cheng.yu@intel.com>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H. J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 08, 2018 at 01:48:54PM -0800, Dave Hansen wrote:
> On 11/8/18 1:22 PM, Andy Lutomirski wrote:
> >> +struct cet_kernel_state {
> >> +       u64 kernel_ssp; /* kernel shadow stack */
> >> +       u64 pl1_ssp;    /* ring-1 shadow stack */
> >> +       u64 pl2_ssp;    /* ring-2 shadow stack */
> >> +} __packed;
> >> +
> > Why are these __packed?  It seems like it'll generate bad code for no
> > obvious purpose.
> 
> It's a hardware-defined in-memory structure.  Granted, we'd need a
> really wonky compiler to make that anything *other* than a nicely-packed
> 24-byte structure, but the __packed makes it explicit.
> 
> It is probably a really useful long-term thing to stop using __packed
> and start using "__hw_defined" or something that #defines down to __packed.

packed doesn't mean "don't leave gaps".  It means:

'packed'
     The 'packed' attribute specifies that a variable or structure field
     should have the smallest possible alignment--one byte for a
     variable, and one bit for a field, unless you specify a larger
     value with the 'aligned' attribute.

So Andy's right.  It tells the compiler, "this struct will not be naturally aligned, it will be aligned to a 1-byte boundary".  Which is silly.  If we have

struct b {
	unsigned long x;
} __packed;

struct a {
	char c;
	struct b b;
};

we want struct b to start at offset 8, but with __packed, it will start
at offset 1.

Delete __packed.  It doesn't do what you think it does.
