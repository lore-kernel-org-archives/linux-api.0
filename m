From: Christian Kellner <christian@kellner.me>
Subject: Re: [PATCH] pidfd: add NSpid entries to fdinfo
Date: Mon, 14 Oct 2019 17:20:57 +0200
Message-ID: <3159d545105613416961ff50572f6686cdee03ee.camel@kellner.me>
References: <CAG48ez1hk9d-qAPcRy9QOgNuO8u3Y_hu_3=GZoFYLY+oMdo8xg@mail.gmail.com>
         <20191012101922.24168-1-christian.brauner@ubuntu.com>
         <20191012102119.qq2adlnxjxrkslca@wittgenstein>
         <abc477fb3bd8fbf7b4d7e53d079dd1d8902e54af.camel@kellner.me>
         <20191014103157.h2wph2ujjidsrhyw@wittgenstein>
         <CAG48ez1Yf05j2irdZxT2TA=2n3xo25KN48nRQdp_F8j14K36rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1Yf05j2irdZxT2TA=2n3xo25KN48nRQdp_F8j14K36rA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>, Christian Brauner <christian.brauner@ubuntu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Elena Reshetova <elena.reshetova@intel.com>, Roman Gushchin <guro@fb.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Mon, 2019-10-14 at 17:10 +0200, Jann Horn wrote:
> On Mon, Oct 14, 2019 at 12:32 PM Christian Brauner wrote:
> > On Mon, Oct 14, 2019 at 11:43:01AM +0200, Christian Kellner wrote:
> > You could probably do:
> > 
> > #ifdef CONFIG_PID_NS
> > seq_put_decimal_ull(m, "\nNSpid:\t", nr);
> > for (i = ns->level + 1; i <= pid->level && nr; i++)
> >         seq_put_decimal_ull(m, "\t", pid->numbers[i].nr);
> > #endif
> 
> Personally, I dislike hiding the precondition for running the loop in
> the loop statement like that. While it makes the code more concise,
> it somewhat obfuscates the high-level logic at a first glance.
I agree and it has the side-effect of needing another #ifdef at the end
of the variable block for "i". I think I will go with:

if (nr) {
	int i;

	/* If nr is non-zero it means that 'pid' is valid and that
	 * ns, i.e. the pid namespace associated with the procfs
	 * instance, is in the pid namespace hierarchy of pid.
	 * Start at one below the already printed level.
	 */
	for (i = ns->level + 1; i <= pid->level; i++)
		seq_put_decimal_ull(m, "\t", pid->numbers[i].nr);
}

I will re-work the comment block and then send a new version of
the patch.

Thanks,
Christian
