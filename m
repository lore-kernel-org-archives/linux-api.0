From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv5 21/37] x86/vdso: Restrict splitting VVAR VMA
Date: Wed, 31 Jul 2019 22:23:48 -0700
Message-ID: <CALCETrW4YpndyXHLxCuBSaXX2V9UYNs3d6kLv1MS-vt0FxOvAw@mail.gmail.com>
References: <20190729215758.28405-1-dima@arista.com> <20190729215758.28405-22-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729215758.28405-22-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Linux Containers <containers@lists.linux-foundation.org>, criu@openvz.org, Linux API <linux-api@vger.ke>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 29, 2019 at 2:58 PM Dmitry Safonov <dima@arista.com> wrote:
>
> Although, time namespace can work with VVAR VMA split, it seems worth
> to forbid splitting VVAR resulting in stricter ABI and reducing amount
> of corner-cases to consider while working further on VDSO.
>
> I don't think there is any use-case for partial mremap() of vvar,
> but if there is any - this patch can be easily reverted.

Seems reasonable to me.
