From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv5 28/37] x86/vdso: Enable static branches for the timens vdso
Date: Wed, 31 Jul 2019 22:21:33 -0700
Message-ID: <CALCETrXL6pzDoHfn9Niw_CxNX-_W3=yotDYuqK+kxPhOLofmNA@mail.gmail.com>
References: <20190729215758.28405-1-dima@arista.com> <20190729215758.28405-29-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729215758.28405-29-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Linux Containers <containers@lists.linux-foundation.org>, criu
List-Id: linux-api@vger.kernel.org

On Mon, Jul 29, 2019 at 2:58 PM Dmitry Safonov <dima@arista.com> wrote:
>
> From: Andrei Vagin <avagin@gmail.com>
>
> As it has been discussed on timens RFC, adding a new conditional branch
> `if (inside_time_ns)` on VDSO for all processes is undesirable.
>
> Addressing those problems, there are two versions of VDSO's .so:
> for host tasks (without any penalty) and for processes inside of time
> namespace with clk_to_ns() that subtracts offsets from host's time.
>
> The timens code in vdso looks like this:
>
> if (timens_static_branch_unlikely()) {
>        clk_to_ns(clk, ts);
> }

I'm confused.  Now we effectively have *three* versions: the vDSO
without timens, and vDSO with timens but with it switched off, and the
vDSO with timens on.  This seems like too much.

What you need is, IMO, a static-branch-ish thing that is per mm.  This
has a fundamental problem that the vDSO can be modified using
FOLL_FORCE.  Perhaps any CoW of the vDSO should implicitly switch the
static branch on, which at least gives some degree of correctness even
if it's a bit surprising.

--Andy
