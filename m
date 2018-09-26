From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [RFC 00/20] ns: Introduce Time Namespace
Date: Wed, 26 Sep 2018 18:59:49 +0100
Message-ID: <CAJwJo6bseG42YNqA0cxWpB0C252_CWER0gDrF0OUOm+=DJ7XdQ@mail.gmail.com>
References: <20180919205037.9574-1-dima@arista.com> <874lej6nny.fsf@xmission.com>
 <20180924205119.GA14833@outlook.office365.com> <874leezh8n.fsf@xmission.com>
 <20180925014150.GA6302@outlook.office365.com> <87zhw4rwiq.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87zhw4rwiq.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrey Vagin <avagin@virtuozzo.com>, Dmitry Safonov <dima@arista.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelianov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "criu@openvz.org" <criu@openvz.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Alexey Dobriyan <adob>
List-Id: linux-api@vger.kernel.org

2018-09-26 18:36 GMT+01:00 Eric W. Biederman <ebiederm@xmission.com>:
> The advantage of timekeeping_update per time namespace is that it allows
> different lengths of seconds per time namespace.  Which allows testing
> ntp and the kernel in interesting ways while still having a working
> production configuration on the same system.

Just a quick note: the different length of second per namespace sounds
very interesting in my POV, I remember I've seen this article:
http://publish.illinois.edu/science-of-security-lablet/files/2014/05/DSSnet-A-Smart-Grid-Modeling-Platform-Combining-Electrical-Power-Distributtion-System-Simulation-and-Software-Defined-Networking-Emulation.pdf

And their realisation with a simulation of time going with different speed
per-pid  (with vdso disabled):
https://github.com/littlepretty/VirtualTimeKernel

Thanks,
             Dmitry
