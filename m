From: Jann Horn <jannh@google.com>
Subject: Re: For review: documentation of clone3() system call
Date: Mon, 11 Nov 2019 21:24:33 +0100
Message-ID: <CAG48ez3K6g7NSFmeuw-4paqPQTDYmNkZ-nVvufk25EB+Us850w@mail.gmail.com>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
 <20191107151941.dw4gtul5lrtax4se@wittgenstein> <2eb2ab4c-b177-29aa-cdc4-420b24cfd7b3@gmail.com>
 <CAG48ez2of684J6suPZpko7JFV6hg5KQsrP0KAn8B8-C3PM9OfQ@mail.gmail.com> <20191111165800.GD7017@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191111165800.GD7017@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Christian Brauner <christian.brauner@ubuntu.com>, Florian Weimer <fweimer@redhat.com>, Christian Brauner <christian@brauner.io>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 11, 2019 at 5:58 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Mon, Nov 11, 2019 at 03:55:35PM +0100, Jann Horn wrote:
> > Not on Linux, but on OpenBSD, they do use MAP_STACK now AFAIK; this
> > was announced here:
> > <http://openbsd-archive.7691.n7.nabble.com/stack-register-checking-td338238.html>.
> > Basically they periodically check whether the userspace stack pointer
> > points into a MAP_STACK region, and if not, they kill the process. So
> > even if it's a no-op on Linux...
>
> Hmm, is that something we should do in Linux?  Even if we only check
> on syscall entry, which should be pretty inexpensive, it seems like it
> would be very effective in protecting various ROP techniques.

I'm not a big fan, especially if that would only happen on syscall
entry; at the point where you have enough control to perform syscalls,
it probably isn't too difficult to move your ROP stack over to a
legitimate stack.
