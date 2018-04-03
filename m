From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 14:58:01 -0700
Message-ID: <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com>
 <9758.1522775763@warthog.procyon.org.uk> <CALCETrWHS9p1My=j07=V=OP7v4SwQkW-kJ3JOx6EbPU8fb_XEQ@mail.gmail.com>
 <13189.1522784944@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13189.1522784944@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Matthew Garrett <mjg59@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 12:49 PM, David Howells <dhowells@redhat.com> wrote:
> Andy Lutomirski <luto@kernel.org> wrote:
>
>> >>> A kernel that allows users arbitrary access to ring 0 is just an
>> >>> overfeatured bootloader. Why would you want secure boot in that case?
>> >>
>> >> To get a chain of trust.
>> >
>> > You don't have a chain of trust that you can trust in that case.
>> >
>> Please elaborate on why I can’t trust it.
>
> If the user can arbitrarily modify the running kernel image, you cannot trust
> anything.  You cannot determine the trustworthiness of something because your
> basis for determining that trust can be compromised.

I'm having a very, very hard time coming up with a scenario where I
can "trust" something if an attacker can get root but can't modify the
running kernel image but I can't "trust" something if the attacker
can't.  About the only think I can come up with is that root generally
has a hard time directly reading kernel keyring data.

But if we really think that kernel keyring data is so sacred, let's
please solve it properly using SGX or some hypervisor doodad like
Microsoft's Credential Guard.  Protecting the keyring with lockdown is
a whole lot of annoyance without all that much gain.

>
>> Please also elaborate on how lockdown helps at all.
>
> Stopping the kernel from being arbitrarily modified allows you to preserve
> your trust.

If I build a voting machine, an ATM, or a server that runs Panera
Bread's website, I can certainly issue a press release that says "hey,
the bad guy just downloaded tens of millions of customer records, but
they didn't actually get to run CPL0 code, so all is well."

</sarcasm>

>
> Stopping the kernel from being arbitrarily read stops any encryption keys it
> may be using from being retrieved.

If I build a server that runs Panera Bread 2.0's website, and the
attacker exploits my machine to steal tens of millions of customer
records by getting the machine to talk to some database server using
keys that are securely stored in the kernel keyring, I would feel
sooooooo much better knowing that the attacker didn't also manage to
extract the key that lets the machine talk to the database server.
Never mind that the attacker already stole the entire contents of the
database.

</sarcasm>
