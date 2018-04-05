From: Matthew Garrett <mjg59@google.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Thu, 05 Apr 2018 00:20:36 +0000
Message-ID: <CACdnJut330=gdaSOR8VdLJeNEiL7uupUMZYqVYy5YoE1J-w2vQ@mail.gmail.com>
References: <CA+55aFzYbpRAdma0PvqE+9ygySuKzNKByqOzzMufBoovXVnfPw@mail.gmail.com>
 <CACdnJuv-VpdhjEe1cMysdHb6Oy67jQqg-_TVHbUrOfH9GmCVvg@mail.gmail.com>
 <CA+55aFwvuoSHhKnn82VnDndZ6oXMJgwHF604gZ=h3ehHyC600A@mail.gmail.com>
 <CA+55aFzJ2sQR13T+20MKEJ5co-f3Ev8rRxQkRCWVaeDSUU3yhQ@mail.gmail.com>
 <CACdnJuti5Riqoi1sesqPALYHq9LT87o4MFj-0Y5BZqqzJ5579g@mail.gmail.com>
 <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com>
 <CACdnJuuek-sS3esmomNOkjBMV_6VPL2NFCzRd+UGxbZrMe=4nw@mail.gmail.com>
 <CA+55aFxgrh5eeG9MRSEsJtyL5yTe0TehZ=BS2josGJaLxoMMBQ@mail.gmail.com>
 <CACdnJutuBaE3RaDx0KM5vDF9Sinrp=3tG9csrS-H3eU-J7-Utw@mail.gmail.com>
 <24353.1522848817@warthog.procyon.org.uk> <20180404135251.GD16242@thunk.org>
 <CACdnJuuGRRUt-a3i89o906ka3RDOhs+_7tz_G8LTG8Jc0DXAyQ@mail.gmail.com> <CANA3KFWLCfe=KYPBhKj+g698=frt4E-u-Hq2--5jFkHnkNoBnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANA3KFWLCfe=KYPBhKj+g698=frt4E-u-Hq2--5jFkHnkNoBnA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Dolding <oiaohm@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, David Howells <dhowells@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, luto@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 4, 2018 at 5:05 PM Peter Dolding <oiaohm@gmail.com> wrote:

> > If you don't have secure boot then an attacker with root can modify your
> > bootloader or kernel, and on next boot lockdown can be silently
disabled.

> Stop being narrow minded you don't need secure boot to protect
> bootloader or kernel the classic is only boot from read only media.

And if you use another protected path you can set the appropriate bootparam
flag or pass the appropriate kernel command line argument and gain the same
functionality.
