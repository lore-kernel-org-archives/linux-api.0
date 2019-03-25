From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 16:39:25 -0700
Message-ID: <CALCETrVYUcn99MPJ_qcAK6n70LKPs+gsvyWO7WMk7drfaTHS4A@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <18683.1553532974@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18683.1553532974@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Daniel Colascione <dancol@google.com>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, bl0pbl33p@gmail.com, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>A
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 9:56 AM David Howells <dhowells@redhat.com> wrote:
>
> Daniel Colascione <dancol@google.com> wrote:
>
> > System calls are cheap.
>
> Only to a point.  x86_64 will have an issue when we hit syscall 512.  We're
> currently at 427.
>

I don't consider this to be a problem.  I have patches to make this
problem go away forever.  I just need to tidy them up a bit and
upstream them.
