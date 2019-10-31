From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 11/10] pipe: Add fsync() support [ver #2]
Date: Thu, 31 Oct 2019 15:15:53 +0000
Message-ID: <17311.1572534953@warthog.procyon.org.uk>
References: <c6e044cc-5596-90b7-4418-6ad7009d6d79@yandex-team.ru> <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk> <30394.1571936252@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c6e044cc-5596-90b7-4418-6ad7009d6d79@yandex-team.ru>
Content-ID: <17310.1572534953.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Konstantin Khlebnikov <khlebnikov@yandex-team.ru> wrote:

> Similar synchronization is required for reusing memory after vmsplice()?
> I don't see other way how sender could safely change these pages.

Sounds like a point - if you have multiple parallel contributors to the pip=
e
via vmsplice(), then FIONREAD is of no use.  To use use FIONREAD, you have =
to
let the pipe become empty before you can be sure.

David
