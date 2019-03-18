From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH] y2038: fix socket.h header inclusion
Date: Mon, 18 Mar 2019 15:37:07 +0100
Message-ID: <87mulsuu3w.fsf@mid.deneb.enyo.de>
References: <20190311153857.563743-1-arnd@arndb.de>
        <87k1h1fgkk.fsf@mid.deneb.enyo.de>
        <CAK8P3a1r8GRC7GTHHqWY-PUn=9rWB-7+Qo=7txanbEjGZ-wppw@mail.gmail.com>
        <87a7hvded7.fsf@mid.deneb.enyo.de>
        <CABeXuvrEecSAkBuN-SmAbGwhLWNCC+bA1=X78fm8xMyw8=hm6Q@mail.gmail.com>
        <CAK8P3a22n5L45Gknqd=2zinVGqRovkk0OABmGLJbGcmg8xXd+A@mail.gmail.com>
        <87o968y1uv.fsf@mid.deneb.enyo.de>
        <CAK8P3a1DzRhiuNxBeQaTYSX1NhCaN6+B0Ya7aeGfxUGj35LFhw@mail.gmail.com>
        <877ecwwckm.fsf@mid.deneb.enyo.de>
        <CAK8P3a3X26niT8Y8mWCNXgcRkWhT=ADK-Tt2vjYz6SLj90shCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3X26niT8Y8mWCNXgcRkWhT=ADK-Tt2vjYz6SLj90shCQ@mail.gmail.com>
        (Arnd Bergmann's message of "Mon, 18 Mar 2019 15:34:17 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, "David S . Miller" <davem@davemloft.net>, Willem de Bruijn <willemb@google.com>, alpha <linux-alpha@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-mips@vger.kernel.org, Parisc List <linux-parisc@vger.kernel.org>, sparclinux <sparclinux@vger.kernel.org>, Laura Abbott <labbott@redhat.com>, Networking <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jeff Law <law@redhat.com>
List-Id: linux-api@vger.kernel.org

* Arnd Bergmann:

> Ok, so not '__fds_bits'.
>
> Is '__kernel_fds_bits' ok? I would prefer to keep at least the
> name __kernel_ namespace that we have for typedefs and the
> occasional struct tag.

glibc should be okay with that.  We use __kernel_ in the math
libraries for something completely different, but those files do not
(or should not) include UAPI headers, and in any case, the set of such
identifiers is really small.
