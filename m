From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v12 11/11] seccomp: add thread sync ability
Date: Fri, 18 Jul 2014 11:51:19 -0700
Message-ID: <CALCETrWj-NJeeKe6+qTZd3QsvLNMV_K=2swoNXza7Ef2xHkXoQ@mail.gmail.com>
References: <1405620518-18495-1-git-send-email-keescook@chromium.org>
 <alpine.LRH.2.11.1407181325200.15709@namei.org> <CALCETrUv3G+C3PTOD1FJGOG8AQCA30hNkUiusCnQDGq6Kt_Feg@mail.gmail.com>
 <CAGXu5jL9wQ4ZJ1kDRx_Y_cyGQEjO_Ugmcc--Q71x32_x1q9ScA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jL9wQ4ZJ1kDRx_Y_cyGQEjO_Ugmcc--Q71x32_x1q9ScA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, linux-arch <linux-arch@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 18, 2014 at 11:13 AM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Jul 18, 2014 at 10:17 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Thu, Jul 17, 2014 at 8:26 PM, James Morris <jmorris@namei.org> wrote:
>>> On Thu, 17 Jul 2014, Kees Cook wrote:
>>>
>>>> Twelfth time's the charm! :)
>>>
>>> Btw, there doesn't seem to be an official seccomp maintainer.  Kees, would
>>> you like to volunteer for this?  If so, send in a patch for MAINTAINERS,
>>> and set up a git tree for me to pull from.
>
> Sure thing, I'll get this set up now. I wonder if I should include the
> glob "arch/*/kernel/ptrace.c" in the MAINTAINERS entry. :P

You might want to convince some arch maintainers first, and that's
like herding cats.  Or Oleg, at least.  Also, do you really want to be
asked to deal with the never-ending stream of bugs that people find in
files matching that glob?

>
>> *snicker* :)
>>
>> Kees, if you take on this awesome responsibility, should I send you a
>> rebased version of the fastpath stuff?  If so, I think that the
>> arch-neutral part should go in through your shiny new tree (once it's
>> reviewed to your satisfaction), and I'll ask hpa to pick up the x86
>> part.
>
> Yeah, that sounds perfect.
>
>> I'd volunteer to be a "R:eviewer", but I don't think that the R tag
>> has made it into MAINTAINERS yet.
>
> I'd love to have you listed. :)

Feel free to pester me once "R" appears in case I forget.

You might be able to convince me to co-maintain some day.  Hmm.

--Andy

>
> -Kees
>
> --
> Kees Cook
> Chrome OS Security



-- 
Andy Lutomirski
AMA Capital Management, LLC
