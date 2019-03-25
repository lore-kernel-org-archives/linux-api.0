From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 16:56:14 +0000
Message-ID: <18683.1553532974@warthog.procyon.org.uk>
References: <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com> <20190325162052.28987-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
Content-ID: <18682.1553532974.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: dhowells@redhat.com, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, khlebnikov@yandex-team.ru, Andy Lutomirski <luto@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, bl0pbl33p@gmail.com, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, nagarathnam.muthusamy@oracle.com, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Joel
List-Id: linux-api@vger.kernel.org

Daniel Colascione <dancol@google.com> wrote:

> System calls are cheap.

Only to a point.  x86_64 will have an issue when we hit syscall 512.  We're
currently at 427.

David
