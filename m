From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH] pidfd: add NSpid entries to fdinfo
Date: Mon, 14 Oct 2019 12:31:58 +0200
Message-ID: <20191014103157.h2wph2ujjidsrhyw@wittgenstein>
References: <CAG48ez1hk9d-qAPcRy9QOgNuO8u3Y_hu_3=GZoFYLY+oMdo8xg@mail.gmail.com>
 <20191012101922.24168-1-christian.brauner@ubuntu.com>
 <20191012102119.qq2adlnxjxrkslca@wittgenstein>
 <abc477fb3bd8fbf7b4d7e53d079dd1d8902e54af.camel@kellner.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <abc477fb3bd8fbf7b4d7e53d079dd1d8902e54af.camel@kellner.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Kellner <christian@kellner.me>
Cc: jannh@google.com, aarcange@redhat.com, akpm@linux-foundation.org, cyphar@cyphar.com, elena.reshetova@intel.com, guro@fb.com, ldv@altlinux.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, mhocko@suse.com, mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On Mon, Oct 14, 2019 at 11:43:01AM +0200, Christian Kellner wrote:
> On Sat, 2019-10-12 at 12:21 +0200, Christian Brauner wrote:
> > I think this might be more what we want.
> Yep, indeed.
> 
> > I tried to think of cases where the first entry of Pid is not
> > identical
> > to the first entry of NSpid but I came up with none. Maybe you do,
> > Jann?
> Yeah, I don't think that can be the case. By looking at the source of
> 'pid_nr_ns(pid, ns)' a non-zero return means that a) 'pid' valid, ie.
> non-null and b) 'ns' is in the pid namespace hierarchy of 'pid' (at
> pid->level, i.e. "pid->numbers[ns->level].ns == ns").
> 
> > Christian, this is just a quick stab I took. Feel free to pick this
> > up as a template.
> Thanks! I slightly re-worked it, with the reasoning above in mind, to
> get rid of one of the branches:

Thanks!

> 
> +#ifdef CONFIG_PID_NS
> +	seq_put_decimal_ull(m, "\nNSpid:\t", nr);
> +	if (nr) {
> +		int i;
> +
> +		/* If nr is non-zero it means that 'pid' is valid and that
> +		 * ns, i.e. the pid namespace associated with the procfs
> +		 * instance, is in the pid namespace hierarchy of pid.
> +		 * Start at one level below and print all descending pids.
> +		 */
> +		for (i = ns->level + 1; i <= pid->level; i++) {
> +			ns = pid->numbers[i].ns;

I'm not a fan of overriding the "ns" pointer. It's not a huge deal but
it's rather subtle.

> +			seq_put_decimal_ull(m, "\t", pid_nr_ns(pid, ns));
> +		}
> +	}
> +#endif
> 
> But I now just realized that with the very same reasoning, if nr is
> non-zero, we don't need to redo all the checks and can just do:
> 
> for (i = ns->level + 1; i <= pid->level; i++)
> 	seq_put_decimal_ull(m, "\t", pid->numbers[i].nr);
> 
> If this sounds good to you I resend the patches with the change above.

You could probably do:

#ifdef CONFIG_PID_NS
seq_put_decimal_ull(m, "\nNSpid:\t", nr);
for (i = ns->level + 1; i <= pid->level && nr; i++)
	seq_put_decimal_ull(m, "\t", pid->numbers[i].nr);
#endif

Christian
