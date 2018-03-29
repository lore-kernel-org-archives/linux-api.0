From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC][PATCH] ipc: Remove IPCMNI
Date: Thu, 29 Mar 2018 12:32:54 -0700
Message-ID: <20180329193254.GA22300@bombadil.infradead.org>
References: <87o9jru3bf.fsf@xmission.com>
 <935a7c50-50cc-2dc0-33bb-92c000d039bc@redhat.com>
 <87woyego2u.fsf_-_@xmission.com>
 <047c6ed6-6581-b543-ba3d-cadc543d3d25@redhat.com>
 <87h8ph6u67.fsf@xmission.com>
 <7d3a1f93-f8e5-5325-f9a7-0079f7777b6f@redhat.com>
 <20180329021409.gcjjrmviw2lckbfk@linux-n805>
 <3e201de2-bed2-6f7d-0783-700d095142e0@colorfullife.com>
 <20180329105601.GA597@bombadil.infradead.org>
 <05772f83-d680-aea1-b222-cef2430dcc83@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <05772f83-d680-aea1-b222-cef2430dcc83@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Waiman Long <longman@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Stanislav Kinsbursky <skinsbursky@parallels.com>, Linux Containers <containers@lists.linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 29, 2018 at 08:07:44PM +0200, Manfred Spraul wrote:
> Hello Mathew,
> 
> On 03/29/2018 12:56 PM, Matthew Wilcox wrote:
> > On Thu, Mar 29, 2018 at 10:47:45AM +0200, Manfred Spraul wrote:
> > > > > > > > This can be implemented trivially with the current code
> > > > > > > > using idr_alloc_cyclic.
> > > Is there a performance impact?
> > > Right now, the idr tree is only large if there are lots of objects.
> > > What happens if we have only 1 object, with id=INT_MAX-1?
> > The radix tree uses a branching factor of 64 entries (6 bits) per level.
> > The maximum ID is 31 bits (positive signed 32-bit integer).  So the
> > worst case for a single object is 6 pointer dereferences to find the
> > object anywhere in the range (INT_MAX/2 - INT_MAX].  That will read 12
> > cachelines.  If we were to constrain ourselves to a maximum of INT_MAX/2
> > (30 bits), we'd reduce that to 5 pointer dereferences and 10 cachelines.
> I'm concerned about the up to 6 branches.
> But this is just guessing, we need a test with a realistic workload.

Yes, and once there's a realistic workload, I'll be happy to prioritise
adapting the data structure to reduce the pointer chases.

FWIW, the plan is this:

There's currently an unused 32-bit field (on 64-bit machines) which I plan
to make the 'base' field.  So at each step down the tree, one subtracts
that field from the index in order to decide which slot to look at next.
Something like this:

index=0x3000'0000
(root) -> order=24
          offset=48 -> order=18
                       offset=0 -> order=12
                                   offset=0 -> order=6
                                               offset=0 -> order=0
                                                           offset=0 -> data

compresses to a single node:
(root) -> order=0
          base=3000'0000
          offset=0 -> data

If one has one entry at 5 and another entry at 0x3000'0000, the tree
looks like this (three nodes):

(root) -> order=24
          base=0
          offset=0  -> order=0
                       base=0
                       offset=5 -> entry1
          offset=48 -> order=0
                       base=0
                       offset=0 -> entry2

The trick is making sure that looking up offset 0x300'1000 returns NULL
and not entry2, but I can make that work.

An alternative is to go to something a little more libJudy and have
mutating internal nodes in the tree that can represent this kind of
situation in a more compact form.  There's a tradeoff to be made between
simplicity of implementation, cost of insertion, cost of lookup and
memory consumption.  I don't know where the right balance point is yet.
