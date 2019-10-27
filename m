From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 11/10] pipe: Add fsync() support [ver #2]
Date: Sun, 27 Oct 2019 08:22:23 -0700
Message-ID: <20191027152223.GA21194@infradead.org>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <30394.1571936252@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <30394.1571936252@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 24, 2019 at 05:57:32PM +0100, David Howells wrote:
> pipe: Add fsync() support
> 
> The keyrings testsuite needs the ability to wait for all the outstanding
> notifications in the queue to have been processed so that it can then go
> through them to find out whether the notifications it expected have been
> emitted.
> 
> Implement fsync() support for pipes to provide this.  The tailmost buffer
> at the point of calling is marked and fsync adds itself to the list of
> waiters, noting the tail position to be waited for and marking the buffer
> as no longer mergeable.  Then when the buffer is consumed, if the flag is
> set, any matching waiters are woken up.

I am _really_ worried about overloading fsync for this behavior.  fsync
hasn't done anything for 50 years, and suddenly adding any action
is not helpful.  If you can't use FIONREAD please add a new ioctls
instead, and document it properly.
