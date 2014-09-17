From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Tue, 16 Sep 2014 17:27:42 -0700
Message-ID: <CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410912351-31273-1-git-send-email-rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 16, 2014 at 5:05 PM, Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Adds new prctl calls to enable or disable VDSO loading for a process
> and its children.
>
> The PR_SET_DISABLE_VDSO call takes one argument, which is interpreted as
> a boolean value.  If true, it disables the loading of the VDSO on exec()
> for this process and any children created after this call.  A false
> value unsets the flag.
>
> The PR_GET_DISABLE_VDSO option returns a non-negative true value if VDSO
> loading has been disabled for this process, zero if it has not been
> disabled, and a negative value in case of error.
>
> These prctl calls are hidden behind a new Kconfig,
> CONFIG_VDSO_DISABLE_PRCTL.  This feature is available only on x86.
>
> The command line option vdso=0 overrides the behavior of
> PR_SET_DISABLE_VDSO, however, PR_GET_DISABLE_VDSO will coninue to return
> whetever setting was last set with PR_SET_DISABLE_VDSO.
>
> Signed-off-by: Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> This patch is part of some work to better handle times and CRIU migration.
> I suspect that there are other use cases out there, so I'm offering this
> patch separately.
>
> When considering CRIU migration and times, we put some thought into how
> to handle the rdtsc instruction.  If we migrate between machines or across
> reboots, the migrated process will see values that could break its assumptions
> about how rdtsc is supposed to work.

I don't get it.

If __vdso_clock_gettime returns the wrong value in any scenario, we
should fix that.  Simiarly, CRIU *already works*, unless there's
something I don't know of.

That being said, I would like an option to gate off RDTSC for a
process and its children in order to make PR_TSC_SIGSEGV more useful.
All the prerequisites are there now.

What problem are you trying to solve exactly?

--Andy
