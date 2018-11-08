From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH v5 04/27] x86/fpu/xstate: Add XSAVES system states for
 shadow stack
Date: Fri, 9 Nov 2018 01:18:04 +0300
Message-ID: <20181108221804.GE13195@uranus.lan>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com>
 <20181011151523.27101-5-yu-cheng.yu@intel.com>
 <CALCETrVAe8R=crVHoD5QmbN-gAW+V-Rwkwe4kQP7V7zQm9TM=Q@mail.gmail.com>
 <4295b8f786c10c469870a6d9725749ce75dcdaa2.camel@intel.com>
 <CALCETrUKzXYzRrWRdi8Z7AdAF0uZW5Gs7J4s=55dszoyzc29rw@mail.gmail.com>
 <20181108213126.GD13195@uranus.lan>
 <CALCETrXNt6nEMu9bbK7GizoeC+rphi8ZK0dDsHiVgOCQj1eQEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXNt6nEMu9bbK7GizoeC+rphi8ZK0dDsHiVgOCQj1eQEA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H. J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.ami>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 08, 2018 at 02:01:42PM -0800, Andy Lutomirski wrote:
> > >
> > > They both seem like bugs, perhaps.  As I understand it, __packed
> > > removes padding, but it also forces the compiler to expect the fields
> > > to be unaligned even if they are actually aligned.
> >
> > How is that? Andy, mind to point where you get that this
> > attribute forces compiler to make such assumption?
> 
> It's from memory.  But gcc seems to agree with me I compiled this:
> 

Indeed, thanks!
