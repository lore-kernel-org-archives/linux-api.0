From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 4 Apr 2018 22:01:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1804042148480.1492@nanos.tec.linutronix.de>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org> <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk> <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com> <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com> <CACdnJuutJeeaaB2kwma0MMd9uDDbKavoHEk4koDLe1M6gYZWXQ@mail.gmail.com> <CALCETrVR_EcbKv5-4AR6Zm02XHhJQQGNDeO8FGkMbYozmuDTJw@mail.gmail.com>
 <20180404184255.exdrtpqnxlqme7tl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180404184255.exdrtpqnxlqme7tl@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Matthew Garrett <mjg59@google.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 4 Apr 2018, Peter Jones wrote:
> That is to say, as a result of the way malware has been written, our way
> of thinking about it is often that it's a way to build a boot loader for
> a malicious kernel, so that's how we wind up talking about it.  Are we
> concerned with malware stealing your data?  Yes, but Secure Boot is only
> indirectly about that.  It's primarily about denying the malware easy
> mechanisms to build a persistence mechanism.  The uid-0 != ring-0 aspect
> is useful independent of Secure Boot, but Secure Boot without it falls
> way short of accomplishing its goal.

I think we can all agree that

  The uid-0 != ring-0 aspect is useful independent of Secure Boot

There is probably resonable consensus about the second part of this
sentence as well:

   but Secure Boot without it falls way short of accomplishing its goal.

Now where the disagreement lies is the way how the uid/ring0 aspect is tied
to secure boot, which makes it impossible to be useful independent of
Secure Boot.

So the real question is, how can we make 'lockdown' usable and useful
without Secure Boot and at the same time not violate the constraints of
the Secure Boot scenario.

If we can agree on the above then I hope that we can focus on the technical
problems instead of arguing in circles.

Thanks,

	tglx
