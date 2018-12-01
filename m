From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] prctl: add PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT
Date: Fri, 30 Nov 2018 20:28:50 -0800
Message-ID: <CAGXu5jKmz+zDH9nmYo=dwxWRNh=gYxb--Qy4x+KrFuBaT+L31w@mail.gmail.com>
References: <20181127225408.7553-1-j@bitron.ch> <20181127225408.7553-2-j@bitron.ch>
 <20181128144230.GG30395@redhat.com> <87r2f5gr9g.fsf@xmission.com>
 <20181129123409.GA10645@redhat.com> <f55261dbc41544363b4348820f67fb01c6d7aaec.camel@bitron.ch>
 <20181130103329.GB23670@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130103329.GB23670@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: j@bitron.ch, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 30, 2018 at 2:33 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> On 11/29, J=C3=BCrg Billeter wrote:
> >
> > On Thu, 2018-11-29 at 13:34 +0100, Oleg Nesterov wrote:
> > > So I think the patch is mostly fine, the only problem I can see is th=
at
> > > PR_SET_KILL_DESCENDANTS_ON_EXIT can race with PR_SET_CHILD_SUBREAPER,=
 they both
> > > need to update the bits in the same word.
> >
> > Good point. I'll make it a regular bool instead of a bitfield for v2,
>
> Agreed,

Is it worth doing something for singal_struct like we did for
task_struct with the TASK_PFA_* and atomic_flags?

--=20
Kees Cook
