From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 04/10] pipe: Use head and tail pointers for the ring,
 not cursor and length [ver #2]
Date: Sun, 3 Nov 2019 03:17:38 -0800
Message-ID: <20191103111738.GC15832@bombadil.infradead.org>
References: <CAHk-=wh7cf3ANq-G9MmwSQiUK2d-=083C0HV_8hTGe2Mb4X7JA@mail.gmail.com>
 <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
 <24075.1572533871@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <24075.1572533871@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 31, 2019 at 02:57:51PM +0000, David Howells wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > It's shorter and more obvious to just write
> > 
> >    pipe->head = head;
> > 
> > than it is to write
> > 
> >    pipe_commit_write(pipe, head);
> 
> But easier to find the latter.  But whatever.

May I suggest that you use a name that's easier to grep for?

$ git grep -cw p_tail
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c:9
$ git grep -cw p_head
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c:3
