From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC][PATCH] ipc: Remove IPCMNI
Date: Thu, 29 Mar 2018 13:52:25 -0500
Message-ID: <87lgea7lzq.fsf@xmission.com>
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
        <20180329105601.GA597@bombadil.infradead.org>
        <05772f83-d680-aea1-b222-cef2430dcc83@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <05772f83-d680-aea1-b222-cef2430dcc83@colorfullife.com> (Manfred
        Spraul's message of "Thu, 29 Mar 2018 20:07:44 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Matthew Wilcox <willy@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, Waiman Long <longman@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Stanislav Kinsbursky <skinsbursky@parallels.com>, Linux Containers <containers@lists.linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Manfred Spraul <manfred@colorfullife.com> writes:

> Hello Mathew,
>
> On 03/29/2018 12:56 PM, Matthew Wilcox wrote:
>> On Thu, Mar 29, 2018 at 10:47:45AM +0200, Manfred Spraul wrote:
>>>>>>>> This can be implemented trivially with the current code
>>>>>>>> using idr_alloc_cyclic.
>>> Is there a performance impact?
>>> Right now, the idr tree is only large if there are lots of objects.
>>> What happens if we have only 1 object, with id=INT_MAX-1?
>> The radix tree uses a branching factor of 64 entries (6 bits) per level.
>> The maximum ID is 31 bits (positive signed 32-bit integer).  So the
>> worst case for a single object is 6 pointer dereferences to find the
>> object anywhere in the range (INT_MAX/2 - INT_MAX].  That will read 12
>> cachelines.  If we were to constrain ourselves to a maximum of INT_MAX/2
>> (30 bits), we'd reduce that to 5 pointer dereferences and 10 cachelines.
> I'm concerned about the up to 6 branches.
> But this is just guessing, we need a test with a realistic workload.

Yes.

My primary purpose with the patch was to show that the issues with the
current limits could be resolved in a straght forward manner.  I really
don't know if idrs are the appropriate data structure.  It is possible
rbtrees are a better fit.


I think my algorithm I proposed for generating identifiers is as likely
as any to be a good one.  It does need testing on a wide variety of
applications to see what applications actually care about and for that I
think my proposed patch is more than sufficient.

By not keeping a generation counters in the slots themselves linux
already differs substantially from traditional implementations.

Doing something to free us from using a fixed number of bits for the
counter and a fixed number of bits to encode the slot we can support
much larger use of this API.

Eric
