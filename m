From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 00/14] pipe: Keyrings, Block and USB notifications [ver #3]
Date: Wed, 15 Jan 2020 21:07:34 +0000
Message-ID: <24899.1579122454@warthog.procyon.org.uk>
References: <CAHk-=wjrrOgznCy3yUmcmQY1z_7vXVr6GbvKiy8cLvWbxpmzcw@mail.gmail.com> <157909503552.20155.3030058841911628518.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wjrrOgznCy3yUmcmQY1z_7vXVr6GbvKiy8cLvWbxpmzcw@mail.gmail.com>
Content-ID: <24898.1579122454.1@warthog.procyon.org.uk>
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: dhowells@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, Ian Kent <raven@themaw.net>, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I no longer hate the implementation, but I do want to see the
> actual user space users come out of the woodwork and try this out for
> their use cases.

I'll see if I can get someone to help fix this:

	https://bugzilla.redhat.com/show_bug.cgi?id=1551648

for the KEYRING kerberos cache using notifications.  Note that the primary
thrust of this BZ is with KCM cache, but it affects KEYRING as well.

Also, I'll poke Greg, since he was interested in using it for USB
notifications.

David
