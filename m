From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 07/24] hibernate: Disable when the kernel is locked down
Date: Sun, 22 Apr 2018 07:34:43 -0700
Message-ID: <CALCETrWnucpY8VueVh==ZGo8LpvVBpppoK6MLwW188A89TwzQQ@mail.gmail.com>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346392521.4030.5108539377959227838.stgit@warthog.procyon.org.uk>
 <20180413202234.GA4484@amd> <27926.1524148733@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <27926.1524148733@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, Linus Torvalds <torvalds@linux-foundation.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 19, 2018 at 7:38 AM, David Howells <dhowells@redhat.com> wrote:
> Pavel Machek <pavel@ucw.cz> wrote:
>
>> > There is currently no way to verify the resume image when returning
>> > from hibernate.  This might compromise the signed modules trust model,
>> > so until we can work with signed hibernate images we disable it when the
>> > kernel is locked down.
>>
>> I'd rather see hibernation fixed than disabled like this.
>
> The problem is that you have to store the hibernated kernel image encrypted,
> but you can't store the decryption key on disk unencrypted or you've just
> wasted the effort.
>
> So the firmware has to unlock the image, asking the user for a password to
> unlock the key.

Why firmware?

Either the boot kernel could figure out how to ask for a password (or
unseal using the TPM) or we could defer this to userspace.  The latter
should already work using kexec-jump, no?
