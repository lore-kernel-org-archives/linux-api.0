From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/24] Add the ability to lock down access to the running kernel image
Date: Wed, 11 Apr 2018 18:49:05 +0100
Message-ID: <7367.1523468945@warthog.procyon.org.uk>
References: <6a37b428-d9fb-12d5-8d36-8a032984af8c@infradead.org> <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk> <152346388583.4030.15146667041427303547.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6a37b428-d9fb-12d5-8d36-8a032984af8c@infradead.org>
Content-ID: <7366.1523468945.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> wrote:

> > +	  drivers from functioning because allowing manual configuration of
> > +	  hardware parameters is forbidden, lest a device be used to access the
> > +	  kernel by DMA.  This mostly applies to ISA devices.
> 
> 	Is DMA from non-ISA devices OK, or did I miss seeing that patch?

The issue is where you can directly command a device to do DMA, possibly by
using the wrong driver.  Ask Alan Cox.

David
