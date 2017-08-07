From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/7] signal/mips: Document a conflict with SI_USER with SIGFPE
Date: Mon, 7 Aug 2017 10:41:39 -0700
Message-ID: <CA+55aFx3ss90b4x2bo4si80kQUjMVL1zUX3Oxvu04OE14nUtFw@mail.gmail.com>
References: <87o9shg7t7.fsf_-_@xmission.com> <20170718140651.15973-4-ebiederm@xmission.com>
 <alpine.DEB.2.00.1708071706290.17596@tp.orcam.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1708071706290.17596@tp.orcam.me.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Maciej W. Rozycki" <macro@imgtec.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge@hallyn.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Ralf Baechle <ralf@linux-mips.org>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 7, 2017 at 9:18 AM, Maciej W. Rozycki <macro@imgtec.com> wrote:
>
>  So what would be the right value of `si_code' to use here for such an
> unexpected exception condition?  I think `BUG()' would be too big a
> hammer here.  Or wouldn't it?

Hell no. NEVER EVER BUG().

The only case to use BUG() is if there is some core data structure
(say, kernel stack) that is so corrupted that you know you cannot
continue. That's the *only* valid use.

If this is a "this condition cannot happen" issue, then just remove
the damn conditional. It's pointless. Adding a BUG() to show "this
cannot happen" is not acceptable.

                        Linus
