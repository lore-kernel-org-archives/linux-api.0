From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [RFC PATCH 04/10] pipe: Use head and tail pointers for the ring,
 not cursor and length [ver #2]
Date: Thu, 31 Oct 2019 16:57:53 +0100
Message-ID: <CAOi1vP9GAmy5NXJisrDssspoRcc+UHum+cyBsJTMNTjz_jieoQ@mail.gmail.com>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
 <CAOi1vP97DMX8zweOLfBDOFstrjC78=6RgxK3PPj_mehCOSeoaw@mail.gmail.com>
 <4892d186-8eb0-a282-e7e6-e79958431a54@rasmusvillemoes.dk> <16620.1572534687@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <16620.1572534687@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-security-module@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 31, 2019 at 4:11 PM David Howells <dhowells@redhat.com> wrote:
>
> How about:
>
>  * We use head and tail indices that aren't masked off, except at the
>  * point of dereference, but rather they're allowed to wrap naturally.
>  * This means there isn't a dead spot in the buffer, provided the ring
>  * size is a power of two and <= 2^31.

To me "provided" reads like this thing works without a dead spot or
with a dead spot, depending on whether the condition is met.  I would
say:

>  * This means there isn't a dead spot in the buffer, but the ring
>  * size has to be a power of two and <= 2^31.

Thanks,

                Ilya
