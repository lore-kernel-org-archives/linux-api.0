From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC filtering
Date: Fri, 3 Oct 2014 13:27:52 -0700
Message-ID: <CALCETrWfrWpdMCAYySMAMGCHU3XRkNGmeMTECTE=PXQUfjGPZA@mail.gmail.com>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
 <20141003201409.GM10583@worktop.programming.kicks-ass.net> <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 3, 2014 at 1:22 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> We could make the rule be that RDPMC is enabled if a perf event is
> mmapped or TIF_SECCOMP is clear, but I'd prefer to be convinced that
> there's an actual performance issue first.  Ideally we can get this
> all working with no API or ABI change at all.

No, we can't use that rule.  But we could say that RDPMC is enabled if
a perf event is mmapped and no thread in the mm uses seccomp.  I'll
grumble a little bit about adding yet another piece of seccomp state.

--Andy
