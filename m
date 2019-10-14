From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] pidfd: add NSpid entries to fdinfo
Date: Mon, 14 Oct 2019 17:10:01 +0200
Message-ID: <CAG48ez1Yf05j2irdZxT2TA=2n3xo25KN48nRQdp_F8j14K36rA@mail.gmail.com>
References: <CAG48ez1hk9d-qAPcRy9QOgNuO8u3Y_hu_3=GZoFYLY+oMdo8xg@mail.gmail.com>
 <20191012101922.24168-1-christian.brauner@ubuntu.com> <20191012102119.qq2adlnxjxrkslca@wittgenstein>
 <abc477fb3bd8fbf7b4d7e53d079dd1d8902e54af.camel@kellner.me> <20191014103157.h2wph2ujjidsrhyw@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191014103157.h2wph2ujjidsrhyw@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Christian Kellner <christian@kellner.me>, Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Elena Reshetova <elena.reshetova@intel.com>, Roman Gushchin <guro@fb.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 14, 2019 at 12:32 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> On Mon, Oct 14, 2019 at 11:43:01AM +0200, Christian Kellner wrote:
> > On Sat, 2019-10-12 at 12:21 +0200, Christian Brauner wrote:
> > > I tried to think of cases where the first entry of Pid is not
> > > identical
> > > to the first entry of NSpid but I came up with none. Maybe you do,
> > > Jann?
> > Yeah, I don't think that can be the case. By looking at the source of
> > 'pid_nr_ns(pid, ns)' a non-zero return means that a) 'pid' valid, ie.
> > non-null and b) 'ns' is in the pid namespace hierarchy of 'pid' (at
> > pid->level, i.e. "pid->numbers[ns->level].ns == ns").

Agreed.

> You could probably do:
>
> #ifdef CONFIG_PID_NS
> seq_put_decimal_ull(m, "\nNSpid:\t", nr);
> for (i = ns->level + 1; i <= pid->level && nr; i++)
>         seq_put_decimal_ull(m, "\t", pid->numbers[i].nr);
> #endif

Personally, I dislike hiding the precondition for running the loop in
the loop statement like that. While it makes the code more concise, it
somewhat obfuscates the high-level logic at a first glance.
