From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v3 05/24] Documentation/x86: Add CET description
Date: Fri, 14 Sep 2018 14:17:12 -0700
Message-ID: <1536959832.12990.34.camel@intel.com>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com>
         <20180830143904.3168-6-yu-cheng.yu@intel.com> <20180830203948.GB1936@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830203948.GB1936@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2018-08-30 at 22:39 +0200, Pavel Machek wrote:
> Hi!
> 
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt
> > b/Documentation/admin-guide/kernel-parameters.txt
> > index 9871e649ffef..b090787188b4 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2764,6 +2764,12 @@
> >  			noexec=on: enable non-executable mappings (default)
> >  			noexec=off: disable non-executable mappings
> >  
> > +	no_cet_ibt	[X86-64] Disable indirect branch tracking for
> > user-mode
> > +			applications
> > +
> > +	no_cet_shstk	[X86-64] Disable shadow stack support for user-
> > mode
> > +			applications
> Hmm, not too consistent with "nosmap" below. Would it make sense to
> have cet=on/off/ibt/shstk instead?

We also have noxsave, noxsaveopt, noxsaves, etc.  This style is more decisive?
If "cet=" is preferred, we can change it later?

Yu-cheng
