From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 11/10] pipe: Add fsync() support [ver #2]
Date: Thu, 31 Oct 2019 15:13:16 +0000
Message-ID: <17042.1572534796@warthog.procyon.org.uk>
References: <20191027152223.GA21194@infradead.org> <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk> <30394.1571936252@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191027152223.GA21194@infradead.org>
Content-ID: <17041.1572534796.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> I am _really_ worried about overloading fsync for this behavior.  fsync
> hasn't done anything for 50 years, and suddenly adding any action
> is not helpful.  If you can't use FIONREAD please add a new ioctls
> instead, and document it properly.

Okay.

David
