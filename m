From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
Date: Fri, 7 Jun 2019 11:56:16 -0700
Message-ID: <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
References: <20190319165123.3967889-1-arnd@arndb.de> <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
 <87tvd2j9ye.fsf@oldenburg2.str.redhat.com> <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
 <871s05fd8o.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <871s05fd8o.fsf@oldenburg2.str.redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Joseph Myers <joseph@codesourcery.com>, Arnd Bergmann <arnd@arndb.de>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Laura Abbott <labbott@redhat.com>, Paul Burton <pburton@wavecomp.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 7, 2019 at 11:43 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> On the glibc side, we nowadays deal with this by splitting headers
> further.  (We used to suppress definitions with macros, but that tended
> to become convoluted.)  In this case, moving the definition of
> __kernel_long_t to its own header, so that
> include/uapi/asm-generic/socket.h can include that should fix it.

I think we should strive to do that on the kernel side too, since
clearly we shouldn't expose that "val[]" thing in the core posix types
due to namespace rules, but at the same time I think the patch to
rename val[] is fundamentally broken too.

Can you describe how you split things (perhaps even with a patch ;)?
Is this literally the only issue you currently have? Because I'd
expect similar issues to show up elsewhere too, but who knows.. You
presumably do.

                Linus
