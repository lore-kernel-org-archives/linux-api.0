From: Peter Dolding <oiaohm@gmail.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Thu, 5 Apr 2018 10:05:45 +1000
Message-ID: <CANA3KFWLCfe=KYPBhKj+g698=frt4E-u-Hq2--5jFkHnkNoBnA@mail.gmail.com>
References: <CA+55aFzYbpRAdma0PvqE+9ygySuKzNKByqOzzMufBoovXVnfPw@mail.gmail.com>
 <CACdnJuv-VpdhjEe1cMysdHb6Oy67jQqg-_TVHbUrOfH9GmCVvg@mail.gmail.com>
 <CA+55aFwvuoSHhKnn82VnDndZ6oXMJgwHF604gZ=h3ehHyC600A@mail.gmail.com>
 <CA+55aFzJ2sQR13T+20MKEJ5co-f3Ev8rRxQkRCWVaeDSUU3yhQ@mail.gmail.com>
 <CACdnJuti5Riqoi1sesqPALYHq9LT87o4MFj-0Y5BZqqzJ5579g@mail.gmail.com>
 <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com>
 <CACdnJuuek-sS3esmomNOkjBMV_6VPL2NFCzRd+UGxbZrMe=4nw@mail.gmail.com>
 <CA+55aFxgrh5eeG9MRSEsJtyL5yTe0TehZ=BS2josGJaLxoMMBQ@mail.gmail.com>
 <CACdnJutuBaE3RaDx0KM5vDF9Sinrp=3tG9csrS-H3eU-J7-Utw@mail.gmail.com>
 <24353.1522848817@warthog.procyon.org.uk> <20180404135251.GD16242@thunk.org> <CACdnJuuGRRUt-a3i89o906ka3RDOhs+_7tz_G8LTG8Jc0DXAyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuuGRRUt-a3i89o906ka3RDOhs+_7tz_G8LTG8Jc0DXAyQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Theodore Tso <tytso@mit.edu>, David Howells <dhowells@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, luto@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> If you don't have secure boot then an attacker with root can modify your
> bootloader or kernel, and on next boot lockdown can be silently disabled.

Stop being narrow minded you don't need secure boot to protect
bootloader or kernel the classic is only boot from read only media.

Another is network boot using https can coreboot firmware.   This
checks the certificate  of the https server against selected CA before
downloading anything and as long as the firmware is set read only in
hardware the attack has absolutely nothing to work on.

In fact the network boot form https server is more secure than UEFI
secureboot due to highly limited parties who can alter/provide the
approved boot loader/kernel image.

Having root user rights does not override physical security.    The
fact there are other ways of doing bootloader and kernel security
other than UEFI secureboot that are in lots of cases more secure than
UEFI secureboot due to using more limited keys is the absolute reason
why lockdown is required without UEFI secureboot.

It would make sense to extend kexec to support UEFI secureboot
verification  and also kexec to have frameworks to support other
security options like https server storage of all kernel images.
Please note kexec supporting UEFI secureboot verification should also
support booting non UEFI secureboot but verified by some other method
and having own PK/KEK set for kexec and this would be when the Linux
kernel is placed in firmware and used instead of EFI firmware..

Please note there are many UEFI firmwares that with secureboot off
allow setting up secure https bootting where you are not in fact
validating the boot loader or kernel but validating the source you get
them from.

There are three different ways to achieve a protected boot process.
1) validate the boot files.(this is like UEFI secure boot and many
other methods)
2) validate source the boot files.  Yes this can be apply key check to
image if image is not signed don't boot from it and the image contain
boot loader and kernel then not bother validating the boot loader and
kernel image/parts individually same with https.
3) make boot files read only.

All three achieve the same level of security.   If you are using any
of the three lockdown option may provide some benefit.

Yes https network boot effectively does 2 and 3 so making having a
very limit threat against the boot process.

Remember there is more 1 way to skin a cat just like there is more
than 1 way to make a secure system.   Currently being too narrow in
methods for doing protected booting.


Peter Dolding.
