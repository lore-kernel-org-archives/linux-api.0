From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Thu, 5 Jun 2014 10:14:52 -0700
Message-ID: <CAGXu5jLjneRP=eF67k86cZNNGczZ=9-D4x9GQ-TaSKheCoG-Tg@mail.gmail.com>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1401975635-6162-1-git-send-email-drysdale@google.com>
Sender: linux-arch-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "x86@kernel.org" <x86@kernel.org>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jun 5, 2014 at 6:40 AM, David Drysdale <drysdale@google.com> wrote:
> Resending, adding cc:linux-api.
>
> Also, it may help to add a little more background -- this patch is
> needed as a (small) part of implementing Capsicum in the Linux kernel.
>
> Capsicum is a security framework that has been present in FreeBSD since
> version 9.0 (Jan 2012), and is based on concepts from object-capability
> security [1].
>
> One of the features of Capsicum is capability mode, which locks down
> access to global namespaces such as the filesystem hierarchy.  In
> capability mode, /proc is thus inaccessible and so fexecve(3) doesn't
> work -- hence the need for a kernel-space alternative.
>
> [1] http://www.cl.cam.ac.uk/research/security/capsicum/papers/2010usenix-security-capsicum-website.pdf

Thanks for reposting!

I think it'd be quite helpful to have this available for very tightly
confined sandboxes. And in a larger sense, Capsicum itself is an
interesting way to do programmatic isolation.

-Kees

-- 
Kees Cook
Chrome OS Security
