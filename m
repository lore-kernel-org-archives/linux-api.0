From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 12:40:44 +0100
Message-ID: <877ehfdgzn.fsf@oldenburg.str.redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
        <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
        <877ehjx447.fsf@oldenburg.str.redhat.com>
        <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
        <875zx2vhpd.fsf@oldenburg.str.redhat.com>
        <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
        <20181113193859.GJ3505@e103592.cambridge.arm.com>
        <69B07026-5E8B-47FC-9313-E51E899FAFB0@amacapital.net>
        <20181114105449.GK3505@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181114105449.GK3505@e103592.cambridge.arm.com> (Dave Martin's
        message of "Wed, 14 Nov 2018 10:54:51 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Daniel Colascione <dancol@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Dave Martin:

> Fair points, though this is rather what I meant by "sane essentials".
> Because there are strict limits on what can be done in the vDSO, it may
> be more bloat-resistant and more conservatively maintained.
>
> This might provide a way to push some dumb compatibility kludge code
> that receives little ongoing maintenance outside the privilege wall,
> whereas it has to sit in the kernel proper today.
>
> In theory we could opt to advertise new syscalls only via vDSO entry
> points, and not maintain __NR_xxx values for them (which may or may
> not upset ptrace users.)  Anyway, I digress...

Is the vDSO available across all architectures?  (I don't think we use
it on all architectures in glibc.)

If not, a vDSO-based approach would merely lead to even more variance
between architectures, which can't be a good thing.

Thanks,
Florian
