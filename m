From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [tytso-DPNOqEs/LNQ@public.gmane.org: [PATCH, RFC -v3] random: introduce getrandom(2) system call]
Date: Fri, 18 Jul 2014 15:16:18 +0200
Message-ID: <5293846.HEIrYe5Drj@wuerfel>
References: <20140718125606.GH1491@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140718125606.GH1491-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Friday 18 July 2014 08:56:06 Theodore Ts'o wrote:
> 
> The change in the v3 version of the commit was to eliminate potential
> short reads and EINTR returns when reading from urandom (once the
> urandom pool is initialized).  This was based on comments and requests
> from Theo de Raadt.  See the NOTES section in the suggested man page for
> a more in-depth discussion of the issues involved.

I think there is a problem with the completion:

> @@ -657,6 +661,7 @@ retry:
>                 r->entropy_total = 0;
>                 if (r == &nonblocking_pool) {
>                         prandom_reseed_late();
> +                       complete_all(&urandom_initialized);
>                         pr_notice("random: %s pool is initialized\n", r->name);
>                 }
>         }

complete_all() sets the 'done' part of the completion to 'UINT_MAX/2',
which is enough to ensure that everyone waiting for the completion
at a given time will wake up, but a completion should not
be reused without calling init_completion again after a call to
complete_all().

> +SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
> +               unsigned int, flags)
> +{
> +       int r;
> +
> +       if (flags & ~(GRND_NONBLOCK|GRND_RANDOM))
> +               return -EINVAL;
> +
> +       if (count > INT_MAX)
> +               count = INT_MAX;
> +
> +       if (flags & GRND_RANDOM)
> +               return _random_read(flags & GRND_NONBLOCK, buf, count);
> +       if (flags & GRND_NONBLOCK) {
> +               if (!completion_done(&urandom_initialized))
> +                       return -EAGAIN;
> +       } else {
> +               r = wait_for_completion_interruptible(&urandom_initialized);
> +               if (r)
> +                       return r;
> +       }
> +       return urandom_read(NULL, buf, count, NULL);
> +}
> +

However, here you can get called an arbitrary number of times.
It seems entirely possible than an attacker can manage to call
this function 2 billion times. Assuming a latency of 1 microsecond
per syscall, that would take about half an hour. After that, you
never again get any urandom data out of the syscall.

I think you are better off using a plain wait_event() here.

	Arnd
