From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 16:07:17 +0100
Message-ID: <87va4zaeai.fsf@oldenburg.str.redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
        <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
        <877ehjx447.fsf@oldenburg.str.redhat.com>
        <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
        <875zx2vhpd.fsf@oldenburg.str.redhat.com>
        <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
        <20181113193859.GJ3505@e103592.cambridge.arm.com>
        <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
        <1C1B38FC-1266-4A91-B8F6-20A0C49ED1E2@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1C1B38FC-1266-4A91-B8F6-20A0C49ED1E2@amacapital.net> (Andy
        Lutomirski's message of "Wed, 14 Nov 2018 06:46:47 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Daniel Colascione <dancol@google.com>, nd <nd@arm.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Andy Lutomirski:

> Thread cancellation is a big mess, and we only really need to support
> it because on legacy code. The whole mechanism should IMO be
> considered extremely deprecated.

The part regarding legacy code is not true: people write new code using
it all the time.  It's true that this feature is difficult to use, and
it is often employed in cases where it is not needed or
counterproductive.  However, there are cases where code becomes simpler.

Thanks,
Florian
