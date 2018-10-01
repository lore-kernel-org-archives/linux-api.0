From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Setting monotonic time?
Date: Mon, 01 Oct 2018 11:15:32 +0200
Message-ID: <877ej2xc23.fsf_-_@xmission.com>
References: <20180919205037.9574-1-dima@arista.com>
        <874lej6nny.fsf@xmission.com>
        <20180924205119.GA14833@outlook.office365.com>
        <874leezh8n.fsf@xmission.com>
        <20180925014150.GA6302@outlook.office365.com>
        <87zhw4rwiq.fsf@xmission.com>
        <alpine.DEB.2.21.1809272247270.8118@nanos.tec.linutronix.de>
        <87mus1ftb9.fsf@xmission.com>
        <alpine.DEB.2.21.1809282023350.1432@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809282023350.1432@nanos.tec.linutronix.de>
        (Thomas Gleixner's message of "Fri, 28 Sep 2018 21:32:15 +0200
        (CEST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrey Vagin <avagin@virtuozzo.com>, Dmitry Safonov <dima@arista.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelianov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "criu@openvz.org" <criu@openvz.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Alexey
List-Id: linux-api@vger.kernel.org


In the context of process migration there is a simpler subproblem that I
think it is worth exploring if we can do something about.

For a cluster of machines all running with synchronized
clocks. CLOCK_REALTIME matches. CLOCK_MONOTNIC does not match between
machines.   Not having a matching CLOCK_MONOTONIC prevents successful
process migration between nodes in that cluster.

Would it be possible to allow setting CLOCK_MONOTONIC at the very
beginning of time?  So that all of the nodes in a cluster can be in
sync?

No change in skew just in offset for CLOCK_MONOTONIC.

There are also dragons involved in coordinating things so that
CLOCK_MONOTONIC gets set before CLOCK_MONOTONIC gets used.  So I don't
know if allowing CLOCK_MONOTONIC to be set would be practical but it
seems work exploring all on it's own.

Dmitry would setting CLOCK_MONOTONIC exactly once at boot time solve
your problem that is you are looking at a time namespace to solve?

Eric
