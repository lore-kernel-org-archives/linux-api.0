From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Subject: Re: [PATCH] prctl: add PR_[GS]ET_KILLABLE
Date: Wed, 01 Aug 2018 09:43:57 +0200
Message-ID: <625ede00c618783eb610b7109c35c514e8faa793.camel@bitron.ch>
References: <20180730075241.24002-1-j@bitron.ch>
         <CAG48ez1izZ+W_cPdNp3SOUwb_8YzwAYdSA6d=eqvaF=5+GKemA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1izZ+W_cPdNp3SOUwb_8YzwAYdSA6d=eqvaF=5+GKemA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2018-07-31 at 18:26 +0200, Jann Horn wrote:
> On Mon, Jul 30, 2018 at 10:01 AM Jürg Billeter <j@bitron.ch> wrote:
> 
> [...]
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index 38509dc1f77b..264de630d548 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> 
> [...]
> > +       case PR_SET_KILLABLE:
> > +               if (arg2 != 1 || arg3 || arg4 || arg5)
> > +                       return -EINVAL;
> > +               me->signal->flags &= ~SIGNAL_UNKILLABLE;
> > +               break;
> 
> I don't have an opinion on this patchset otherwise, but should this
> prctl maybe block PR_SET_KILLABLE if you're actually the real init
> process? This seems like it could potentially lead to weird things.

While I don't expect global init to use this, I can't think of a good
reason to disallow it in the kernel. Do you have specific concerns or
is the code in kernel/fork.c the only reason? I prefer avoiding special
cases unless really required.

> This code in kernel/fork.c seems to rely on the fact that global init
> is SIGNAL_UNKILLABLE, and probably also leads to weirdness if
> container init is non-SIGNAL_UNKILLABLE:

Yes, Oleg has mentioned this as well. I have to change copy_process()
to directly check for the PID namespace root process instead of
checking for SIGNAL_UNKILLABLE.

Jürg
