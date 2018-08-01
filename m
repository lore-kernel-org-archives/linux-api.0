From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] prctl: add PR_[GS]ET_KILLABLE
Date: Wed, 1 Aug 2018 09:56:41 +0200
Message-ID: <CAG48ez3uu9-QXOnAu0-3-3PcE=kn=uaWqv4A_uc666XqkisJrw@mail.gmail.com>
References: <20180730075241.24002-1-j@bitron.ch> <CAG48ez1izZ+W_cPdNp3SOUwb_8YzwAYdSA6d=eqvaF=5+GKemA@mail.gmail.com>
 <625ede00c618783eb610b7109c35c514e8faa793.camel@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <625ede00c618783eb610b7109c35c514e8faa793.camel@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: j@bitron.ch
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 1, 2018 at 9:44 AM J=C3=BCrg Billeter <j@bitron.ch> wrote:
>
> On Tue, 2018-07-31 at 18:26 +0200, Jann Horn wrote:
> > On Mon, Jul 30, 2018 at 10:01 AM J=C3=BCrg Billeter <j@bitron.ch> wrote=
:
> >
> > [...]
> > > diff --git a/kernel/sys.c b/kernel/sys.c
> > > index 38509dc1f77b..264de630d548 100644
> > > --- a/kernel/sys.c
> > > +++ b/kernel/sys.c
> >
> > [...]
> > > +       case PR_SET_KILLABLE:
> > > +               if (arg2 !=3D 1 || arg3 || arg4 || arg5)
> > > +                       return -EINVAL;
> > > +               me->signal->flags &=3D ~SIGNAL_UNKILLABLE;
> > > +               break;
> >
> > I don't have an opinion on this patchset otherwise, but should this
> > prctl maybe block PR_SET_KILLABLE if you're actually the real init
> > process? This seems like it could potentially lead to weird things.
>
> While I don't expect global init to use this, I can't think of a good
> reason to disallow it in the kernel. Do you have specific concerns or
> is the code in kernel/fork.c the only reason?

No, I don't have any other specific concerns.

> I prefer avoiding special cases unless really required.
