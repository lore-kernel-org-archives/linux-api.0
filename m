From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/2] kernel: Support compiling out the prctl syscall
Date: Tue, 8 Nov 2016 16:56:54 -0800
Message-ID: <CAGXu5jK-dh0DYGp=syrJb6NQ6x_FNBc-migCj4fvBHv4yvukpA@mail.gmail.com>
References: <cover.c693f10dfc19e12c214758e4b13ca9b4e4cf9668.1478650356.git-series.josh@joshtriplett.org>
 <b5c45594261252a486b891090eba8f10aa7ed329.1478650356.git-series.josh@joshtriplett.org>
 <CAGXu5j+V11oF0gcqBQTsBMgetsSdRqLQffobhyEbze82gbW2vA@mail.gmail.com> <20161109004757.lpbpsdgyzvld7ute@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161109004757.lpbpsdgyzvld7ute@x>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Nicolas Pitre <nicolas.pitre-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Li Bin <huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Zach Brown <zab@redha>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 8, 2016 at 4:47 PM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> On Tue, Nov 08, 2016 at 04:40:02PM -0800, Kees Cook wrote:
>> On Tue, Nov 8, 2016 at 4:18 PM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
>> > Some embedded systems can do without the prctl syscall, saving some
>> > space.
>> >
>> > This also avoids regular increases in tinyconfig size as people add more
>> > non-optional functionality to prctl (observed via the 0-day kernel
>> > infrastructure).
>> >
>> > bloat-o-meter results:
>> >
>> > add/remove: 0/3 grow/shrink: 0/1 up/down: 0/-2143 (-2143)
>> > function                                     old     new   delta
>> > offsets                                       23      12     -11
>> > prctl_set_auxv                                97       -     -97
>> > sys_prctl                                    794       -    -794
>> > prctl_set_mm                                1241       -   -1241
>> > Total: Before=1902583, After=1900440, chg -0.11%
>> >
>> > Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
>>
>> I'm absolutely a fan of doing this, but I wonder how this interacts
>> with the LSMs that define prctl hooks, etc. I wouldn't expect a system
>> that didn't want prctl to want an LSM, but maybe the LSMs all need to
>> depend on CONFIG_PRCTL now?
>
> I did think about that (as well as SECCOMP), but I did confirm that the
> kernel builds fine with allyesconfig minus CONFIG_PRCTL.  An LSM that
> wants to restrict access to some prctls should be fine with no process
> having any access to prctl. :)  Beyond that, anything wanting
> configuration via LSM (such as SECCOMP) still exists and functions, even
> if you can't access it from outside the kernel.

Okay, testing that is good, thanks.

Seccomp can use the seccomp() syscall, so missing prctl isn't a big deal there.

Things like Yama, though, are almost useless in the !PRCTL case. I
think a "depends on PRCTL" should be added at least to Yama. All the
other LSMs are configured in other ways, and they'll just have some
dead code around their prctl hooks; no big deal.

This does also beg the question about how to configure some process
behaviors by default if PRCTL is disabled, but if people want those
things, they can write patches, I would think. :)

-Kees

-- 
Kees Cook
Nexus Security
