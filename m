From: Matthew Garrett <mjg59@google.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 04 Apr 2018 20:18:38 +0000
Message-ID: <CACdnJuunSCaOHKuwDXkzV8N8V-EeaoBhfg+EkL9VPvX7Dkycdg@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com>
 <CACdnJuutJeeaaB2kwma0MMd9uDDbKavoHEk4koDLe1M6gYZWXQ@mail.gmail.com>
 <CALCETrVR_EcbKv5-4AR6Zm02XHhJQQGNDeO8FGkMbYozmuDTJw@mail.gmail.com>
 <20180404184255.exdrtpqnxlqme7tl@redhat.com> <alpine.DEB.2.21.1804042148480.1492@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1804042148480.1492@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: pjones@redhat.com, luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 4, 2018 at 1:01 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> Now where the disagreement lies is the way how the uid/ring0 aspect is
tied
> to secure boot, which makes it impossible to be useful independent of
> Secure Boot.

It doesn't - you can pass a command line parameter that enables it, or your
bootloader can set the bootparams flag. I don't see a fundamental problem
with offering the opportunity to change it at runtime, other than that some
stuff that was previously initialised may have to be torn down. The reason
for having the UEFI boot stub *optionally* check the secure boot state
itself and make a policy decision (rather than having the signed bootloader
do so) is because the kernel can be launched directly by the firmware.
