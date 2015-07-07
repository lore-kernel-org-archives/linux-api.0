From: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Tue, 7 Jul 2015 13:25:52 -0300
Message-ID: <20150707162552.GM3326@kernel.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
 <CALCETrVg5AyeXW_AGguFoGCPK9_2zeobEgT9JJFsakH6PyQf_A@mail.gmail.com>
 <20150707154345.GA1593@odin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150707154345.GA1593-wo1vFcy6AUs@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-wo1vFcy6AUs@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Em Tue, Jul 07, 2015 at 06:43:46PM +0300, Andrew Vagin escreveu:
> On Mon, Jul 06, 2015 at 10:10:32AM -0700, Andy Lutomirski wrote:
> > On Mon, Jul 6, 2015 at 1:47 AM, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> > Would it make more sense to have a new syscall instead?  You could
> > even still use nlattr formatting for the syscall results.
> 
> Andy, thank you for the feedback. I got your points. I need time to
> think about them. I suppose that a new syscall can be more suitable in
> this case, and I need time to form a vision of it. If you have any ideas
> or thoughts, I would be glad to know about them.

If a new syscall would indeed be better for this, then using
sys_perf_event_open and on one of the perf_event_attr flip a bit to ask
for those PERF_RECORD_{COMM,FORK,PERF_RECORD_MMAP2, etc} to be generated
in the perf buffer could make it reuse all the userspace tooling, with
really minimal change: flip the bit, don't synthesize it from /proc.

- Arnaldo
