From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Mon, 14 Dec 2015 11:05:39 +0300
Message-ID: <20151214080538.GC4112@odin.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
 <20151124151811.GA16393@odin.com>
 <CALCETrUzOBybH0-rcgvzMNazjadZpuxkBZLkoUDY30X_-cqBzg@mail.gmail.com>
 <1583220.Fp5vNj67Du@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1583220.Fp5vNj67Du@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 04, 2015 at 12:43:29AM +0100, Arnd Bergmann wrote:
> On Thursday 03 December 2015 15:20:30 Andy Lutomirski wrote:
> > > * Netlink is designed for such type of workloads. It allows to expand
> > >   the interface and save backward compatibility. It allows to generates
> > >   packets with a different set of parameters.
> > > * If we use a file descriptor, we can create it and decrease
> > >   capabilities of the current process. It's a good feature which will be
> > >   unavailable if we decide to create a system call.
> > 
> > If this is actually a real goal and it matters, then I'd suggest doing
> > it right.  Make a way to create an fd that represents a pidns and,
> > specifically, the right to query non-secret properties of the
> > processes in the pidns.
> 
> My first thought about doing an interface here was to create a virtual
> file system that can be queried rather than using netlink, but then I
> realized that the idea was to avoid procfs ;-)

No, we doesn't have an idea to avoid using of procfs. The idea is to
create a new interace to get information about tasks, which will work
faster and will be more convenient for using from applications.

> 
> More seriously, maybe the answer is to have a transaction file in
> procfs itself. Procfs already knows about namespaces, so adding
> a /proc/task-diag file as the entry point into the kernel could
> get that out of the way.
> 
> The simple_transaction infrastructure that we have is limited to
> a little under a page for the total data size, but something similar
> could be used.

Thank you for the idea.
> 
> 	Arnd
