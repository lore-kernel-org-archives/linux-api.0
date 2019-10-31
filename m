From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 07/10] pipe: Conditionalise wakeup in pipe_read() [ver #2]
Date: Thu, 31 Oct 2019 15:21:22 +0000
Message-ID: <18022.1572535282@warthog.procyon.org.uk>
References: <fe167a90-1503-7ca2-4150-eeffd5cb1378@yandex-team.ru> <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk> <157186189069.3995.10292601951655075484.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fe167a90-1503-7ca2-4150-eeffd5cb1378@yandex-team.ru>
Content-ID: <18021.1572535282.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Konstantin Khlebnikov <khlebnikov@yandex-team.ru> wrote:

> > Only do a wakeup in pipe_read() if we made space in a completely full
> > buffer.  The producer shouldn't be waiting on pipe->wait otherwise.
>=20
> We could go further and wakeup writer only when at least half of buffer i=
s
> empty.  This gives better batching and reduces rate of context switches.
>=20
> https://lore.kernel.org/lkml/157219118016.7078.16223055699799396042.stgit=
@buzz/T/#u

Yeah, I saw that.  I suspect that where you put the slider may depend on th=
e
context.

David
