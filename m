From: Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Mon, 26 Jan 2015 16:26:53 +0100
Message-ID: <CAG-2HqUCZjc4Ucc-L21uG6e-di4UcLJAT5mW_-5-c-uqmoJyzA@mail.gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com>
 <54BFDAAA.50203@zonque.org> <54C0CE8A.5080805@gmail.com> <20150123155402.GB2159@kroah.com>
 <54C65267.7090905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54C65267.7090905@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>, Johannes Stezenbach <js@sig21.net>, Theodore T'so <tytso@mit.edu>, christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

Hi Michael,

On Mon, Jan 26, 2015 at 3:42 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> 2. Is the API to be invoked directly by applications or is intended to
>    be used only behind specific libraries? You seem to be saying that
>    the latter is the case (here, I'm referring to your comment above
>    about sd-bus). However, when I asked David Herrmann a similar
>    question I got this responser:
>
>       "kdbus is in no way bound to systemd. There are ongoing efforts
>        to port glib and qt to kdbus natively. The API is pretty simple
>        and I don't see how a libkdbus would simplify things. In fact,
>        even our tests only have slim wrappers around the ioctls to
>        simplify error-handling in test-scenarios."
>
>    To me, that implies that users will employ the raw kernel API.

The way I read this is that there will (probably) be a handful of
users, namely the existing dbus libraries: libdus, sd-bus, glib, Qt,
ell, and maybe a few others. However, third-party developers will not
know/care about the details of kdbus, they'll just be coding against
the dbus libraries as before (might be minor changes, but they
certainly won't need to know anything about the kernel API). Similarly
to how userspace developers now code against their libc of choice,
rather than use kernel syscalls directly.

HTH,

Tom
