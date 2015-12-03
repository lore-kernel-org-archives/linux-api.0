From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information about processes (v2)
Date: Fri, 04 Dec 2015 00:43:29 +0100
Message-ID: <1583220.Fp5vNj67Du@wuerfel>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org> <20151124151811.GA16393@odin.com> <CALCETrUzOBybH0-rcgvzMNazjadZpuxkBZLkoUDY30X_-cqBzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUzOBybH0-rcgvzMNazjadZpuxkBZLkoUDY30X_-cqBzg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Vagin <avagin@virtuozzo.com>, Andrey Vagin <avagin@openvz.org>, David Ahern <dsahern@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnaldo Carvalho de Melo <acme@kernel.org>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thursday 03 December 2015 15:20:30 Andy Lutomirski wrote:
> > * Netlink is designed for such type of workloads. It allows to expand
> >   the interface and save backward compatibility. It allows to generates
> >   packets with a different set of parameters.
> > * If we use a file descriptor, we can create it and decrease
> >   capabilities of the current process. It's a good feature which will be
> >   unavailable if we decide to create a system call.
> 
> If this is actually a real goal and it matters, then I'd suggest doing
> it right.  Make a way to create an fd that represents a pidns and,
> specifically, the right to query non-secret properties of the
> processes in the pidns.

My first thought about doing an interface here was to create a virtual
file system that can be queried rather than using netlink, but then I
realized that the idea was to avoid procfs ;-)

More seriously, maybe the answer is to have a transaction file in
procfs itself. Procfs already knows about namespaces, so adding
a /proc/task-diag file as the entry point into the kernel could
get that out of the way.

The simple_transaction infrastructure that we have is limited to
a little under a page for the total data size, but something similar
could be used.

	Arnd
