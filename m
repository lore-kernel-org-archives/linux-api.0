From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH 3/3] Prevent user from writing to IBT bitmap.
Date: Mon, 01 Jul 2019 12:48:56 -0700
Message-ID: <c99aa450d6cc9a0d23d24734a165e5ffbd9ecc7a.camel@intel.com>
References: <20190628194158.2431-1-yu-cheng.yu@intel.com>
         <20190628194158.2431-3-yu-cheng.yu@intel.com>
         <CALCETrXsXXJWTSJxUO8YxHUo=QJKmHyJa7iz+jOBjWMRhno4rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXsXXJWTSJxUO8YxHUo=QJKmHyJa7iz+jOBjWMRhno4rA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@or>
List-Id: linux-api@vger.kernel.org

On Sat, 2019-06-29 at 16:44 -0700, Andy Lutomirski wrote:
> On Fri, Jun 28, 2019 at 12:50 PM Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
> > 
> > The IBT bitmap is visiable from user-mode, but not writable.
> > 
> > Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> > 
> > ---
> >  arch/x86/mm/fault.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 59f4f66e4f2e..231196abb62e 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -1454,6 +1454,13 @@ void do_user_addr_fault(struct pt_regs *regs,
> >          * we can handle it..
> >          */
> >  good_area:
> > +#define USER_MODE_WRITE (FAULT_FLAG_WRITE | FAULT_FLAG_USER)
> > +       if (((flags & USER_MODE_WRITE)  == USER_MODE_WRITE) &&
> > +           (vma->vm_flags & VM_IBT)) {
> > +               bad_area_access_error(regs, hw_error_code, address, vma);
> > +               return;
> > +       }
> > +
> 
> Just make the VMA have VM_WRITE and VM_MAYWRITE clear.  No new code
> like this should be required.

Ok, I will work on that.

Thanks,
Yu-cheng
