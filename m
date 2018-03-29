From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC][PATCH] ipc: Remove IPCMNI
Date: Thu, 29 Mar 2018 03:56:01 -0700
Message-ID: <20180329105601.GA597@bombadil.infradead.org>
References: <87woyfyh57.fsf@xmission.com>
 <5d4a858a-3136-5ef4-76fe-a61e7f2aed56@redhat.com>
 <87o9jru3bf.fsf@xmission.com>
 <935a7c50-50cc-2dc0-33bb-92c000d039bc@redhat.com>
 <87woyego2u.fsf_-_@xmission.com>
 <047c6ed6-6581-b543-ba3d-cadc543d3d25@redhat.com>
 <87h8ph6u67.fsf@xmission.com>
 <7d3a1f93-f8e5-5325-f9a7-0079f7777b6f@redhat.com>
 <20180329021409.gcjjrmviw2lckbfk@linux-n805>
 <3e201de2-bed2-6f7d-0783-700d095142e0@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3e201de2-bed2-6f7d-0783-700d095142e0@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Waiman Long <longman@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Stanislav Kinsbursky <skinsbursky@parallels.com>, Linux Containers <containers@lists.linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 29, 2018 at 10:47:45AM +0200, Manfred Spraul wrote:
> > > > > > This can be implemented trivially with the current code
> > > > > > using idr_alloc_cyclic.
>
> Is there a performance impact?
> Right now, the idr tree is only large if there are lots of objects.
> What happens if we have only 1 object, with id=INT_MAX-1?

The radix tree uses a branching factor of 64 entries (6 bits) per level.
The maximum ID is 31 bits (positive signed 32-bit integer).  So the
worst case for a single object is 6 pointer dereferences to find the
object anywhere in the range (INT_MAX/2 - INT_MAX].  That will read 12
cachelines.  If we were to constrain ourselves to a maximum of INT_MAX/2
(30 bits), we'd reduce that to 5 pointer dereferences and 10 cachelines.

I have plans to make the representation more efficient and bring
the specific case of one element with a high ID down to one pointer
dereference and 2 cachelines, but I have not yet had time to implement
those plans.

>From a memory consumption point of view, 6 layers of tree will consume
6/7 of a page on a 64-bit x86 kernel.  I'm aiming to bring that down to
1/7 of a page.  We get 7 radix_tree_nodes per 4kB page.

(The old IDR tree had 256 entries per level which would have taken only
four layers to get us to 31 bits, but the cost was getting only 3 layers
per 8kB order-1 page, so we'd've taken 2 + 2/3 page to accomplish the
same goal).
