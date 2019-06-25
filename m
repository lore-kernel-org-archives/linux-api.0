From: Andy Lutomirski <luto@kernel.org>
Subject: Re: Detecting the availability of VSYSCALL
Date: Tue, 25 Jun 2019 13:13:11 -0700
Message-ID: <CALCETrWg+vZWAdY-6etLnh=wyB1aXdG9s8ASUXX=cjjFm7CKZQ@mail.gmail.com>
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com> <201906251131.419D8ACB@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kernel-hardening-return-16234-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <201906251131.419D8ACB@keescook>
To: Kees Cook <keescook@chromium.org>
Cc: Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-x86_64@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 25, 2019 at 1:08 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Jun 25, 2019 at 05:15:27PM +0200, Florian Weimer wrote:
> > Should we try mapping something at the magic address (without MAP_FIXED)
> > and see if we get back a different address?  Something in the auxiliary
> > vector would work for us, too, but nothing seems to exists there
> > unfortunately.
>
> It seems like mmap() won't even work because it's in the high memory
> area. I can't map something a page under the vsyscall page either, so I
> can't distinguish it with mmap, mprotect, madvise, or msync. :(
>

I keep contemplating making munmap() work on it.  That would nicely
answer the question: if munmap() fails, it's not there, and, if
munmap() succeeds, it's not there :)
