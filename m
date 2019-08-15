From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 28/36] posix-clocks: Add align for timens_offsets
Date: Thu, 15 Aug 2019 21:22:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1908152010230.1908@nanos.tec.linutronix.de>
References: <20190815163836.2927-1-dima@arista.com> <20190815163836.2927-29-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190815163836.2927-29-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 15 Aug 2019, Dmitry Safonov wrote:

> Align offsets so that time namespace will work for ia32 applications on
> x86_64 host.

That's true for any 64 bit arch which supports 32bit user space and should
be folded into the patch which introduces the offset store.

> +/*
> + * Time offsets need align as they're placed on VVAR page,
> + * which is used by x86_64 and ia32 VDSO code.
> + * On ia32 offset::tv_sec (u64) has align(4), so re-align offsets
> + * to the same positions as 64-bit offsets.

This is generic code. Please do not add x86'isms here. The alignement
problem is more or less the same for any 64bit arch which supports 32bit
user space. And it's even worse on BE.

> + * On 64-bit big-endian systems VDSO should convert to timespec64
> + * to timespec ...

What?

> ... because of a padding occurring between the fields.

There is no padding between the fields.

32bit BE (powerpc)

struct timespec64 {
	time64_t                   tv_sec;               /*     0     8 */
	long int                   tv_nsec;              /*     8     4 */

tv_nsec is directly after tv_sec

};

64bit LE and BE (x86, powerpc64)

struct timespec64 {
	time64_t                   tv_sec;               /*     0     8 */
	long int                   tv_nsec;              /*     8     8 */
};

The problem for BE is that the 64bit host uses long int to store
tv_nsec. So the 32bit userspace will always read 0 because it reads byte
2/3 as seen from the 64 host side.

So using struct timespec64 for the offset is wrong. You really need to open
code that offset storage if you don't want to end up with weird workarounds
for BE.

Something like this:

struct timens_offs {
	  time64_t	tv_sec;
	  s64		tv_nsec;
};

Then your offset store becomes:

struct timens_offsets {
	struct timens_offs	monotonic;
	struct timens_offs	boottime;
};

which needs tweaks to your conversion functions:

static inline void timens_add_monotonic(struct timespec64 *ts)
{
	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
	struct timens_offs *mo = &ns_offsets->monotonic;

	if (ns_offsets) {
		set_normalized_timespec64(ts, ts->tv_sec + mo->tv_sec,
                                	  ts->tv_nsec + mo->tv_nsec);
	}
}

And for your to host conversion you need:

	case CLOCK_MONOTONIC:
		mo = &ns_offsets->monotonic;
		offset = ktime_set(mo->tv_sec, mo->tv_nsec);
		break;

Similar changes are needed in the VDSO and the proc interface
obviously. Then this works for any arch without magic BE fixups. You get
the idea.

And ideally you change that storage to:

struct timens_offs {
	  time64_t	tv_sec;
	  s64		tv_nsec;
	  ktime_t	nsecs;
};

and do the conversion once in the proc write. Then your to host conversion
can use 'nsecs' and spare the multiplication on every invocation.

	case CLOCK_MONOTONIC:
    		offset = ns_offsets.monotonic.nsecs;

Thanks,

	tglx
