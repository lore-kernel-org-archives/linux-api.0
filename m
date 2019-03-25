From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 09:58:38 -0700
Message-ID: <CAKOZuev9TccQekrJjt50AhKA5cYskMmmKR3WF+Rm7G1xmbiV_w@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <18683.1553532974@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18683.1553532974@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, khlebnikov@yandex-team.ru, Andy Lutomirski <luto@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, bl0pbl33p@gmail.com, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, nagarathnam.muthusamy@oracle.com, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Joel Fernandes <joel@joelfe>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 9:56 AM David Howells <dhowells@redhat.com> wrote:
> Daniel Colascione <dancol@google.com> wrote:
>
> > System calls are cheap.
>
> Only to a point.  x86_64 will have an issue when we hit syscall 512.  We're
> currently at 427.

IIRC, a while ago, someone proposed restarting system call numbering
above (again, IIRC) 1024 for both 32- and 64-bit varieties to
establish a clean slate and sidestep this problem.
