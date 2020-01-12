From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCHv8 20/34] lib/vdso: Prepare for time namespace support
Date: Sun, 12 Jan 2020 11:32:12 +0100
Message-ID: <8736clrmmr.fsf@nanos.tec.linutronix.de>
References: <20191112012724.250792-1-dima@arista.com> <20191112012724.250792-21-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20191112012724.250792-21-dima-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Safonov <dima-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>, Adrian Reber <adrian-5+Cda9B46AM@public.gmane.org>, Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Dmitry Safonov <dima-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org> writes:
> From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> +#ifdef CONFIG_TIME_NS
> +static int do_hres_timens(const struct vdso_data *vdns, clockid_t clk,
> +		      struct __kernel_timespec *ts)
> +{
> +	const struct vdso_data *vd = __arch_get_timens_vdso_data();
> +	const struct vdso_timestamp *vdso_ts;
> +	const struct timens_offset *offs = &vdns->offset[clk];
> +	u64 cycles, last, ns;
> +	u32 seq, msk;
> +	s64 sec;
> +
> +	msk = 1U << clk;
> +	if (msk & VDSO_HRES)
> +		vd = &vd[CS_HRES_COARSE];
> +	else if (msk & VDSO_RAW)
> +		vd = &vd[CS_RAW];
> +	else
> +		return -1;

This part is redundant. The initial call site already made sure that
this is only called for clocks matching VDSO_HRES or VDSO_RAW. I just
drop it.

Thanks,

        tglx
