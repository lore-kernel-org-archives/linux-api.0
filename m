From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 02/21] Add a prelocked wake-up
Date: Tue, 15 Oct 2019 23:33:16 +0100
Message-ID: <20274.1571178796@warthog.procyon.org.uk>
References: <CAHk-=whiz1sHXu8SVZKEC2dup=r5JMrftPtEt6ff9Ea8dyH8yQ@mail.gmail.com> <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk> <157117608708.15019.1998141309054662114.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=whiz1sHXu8SVZKEC2dup=r5JMrftPtEt6ff9Ea8dyH8yQ@mail.gmail.com>
Content-ID: <20273.1571178796.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Tim Chen <tim.c.chen@linux.intel.com>, Kan Liang <kan.liang@intel.com>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Add a wakeup call for a case whereby the caller already has the waitqueue
> > spinlock held.
> 
> That naming is crazy.

Sorry, yeah.  This is a bit hacked together at the moment and needs some more
tidying up.  I've had a lot of problems with performance regressions of up to
40% from seemingly simple changes involving moving locks around - it turns out
that the problem was that I was running with kasan enabled.

David
