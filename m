From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Thu, 15 Nov 2018 16:00:12 -0500
Message-ID: <48868f73-53b4-a01a-de73-4a7b56b91c60@redhat.com>
References: <875zx2vhpd.fsf@oldenburg.str.redhat.com>
 <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <20181113193859.GJ3505@e103592.cambridge.arm.com>
 <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
 <CAKOZuesta_V=doXsVLc2E6WCQvywdur3F+u2pFKaPN+CEQd+ZQ@mail.gmail.com>
 <alpine.DEB.2.21.1811141741000.16571@digraph.polyomino.org.uk>
 <CAKOZuetCGCfNdJ2QM0phu3_3Q29f5Yeh=NHiM_A9MhHsCjK48A@mail.gmail.com>
 <alpine.DEB.2.21.1811141840140.16571@digraph.polyomino.org.uk>
 <20181115053026.GA20617@thunk.org>
 <alpine.DEB.2.21.1811151628490.27351@digraph.polyomino.org.uk>
 <20181115170807.GB20617@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181115170807.GB20617@thunk.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Joseph Myers <joseph@codesourcery.com>, Daniel Colascione <dancol@google.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Dave P Martin <Dave.Martin@arm.com>, nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On 11/15/18 12:08 PM, Theodore Y. Ts'o wrote:
> On Thu, Nov 15, 2018 at 04:29:43PM +0000, Joseph Myers wrote:
>> On Thu, 15 Nov 2018, Theodore Y. Ts'o wrote:
>>
>>> That's great.  But is it or is it not true (either de jure or de
>>> facto) that "a single active glibc developer" can block a system call
>>> from being supported by glibc by objecting?  And if not, under what is
>>> the process by resolving a conflict?
>>
>> We use a consensus-building process as described at 
>> <https://sourceware.org/glibc/wiki/Consensus>.
> 
> So can a single glibc developer can block Consensus?

Yes.

I think the comparison to the "liberum veto" is not a fair
comparison to the way the glibc community works :-)

(1) Community consensus.

Consensus need not imply unanimity.

Consensus is only from the set of important and concerned
interests. The community gets to decide that you're a troll
that does no real work, and can therefore ignore you.

Consensus is blocked only by sustained objection (not just
normal objections, which are recorded as part of the 
development process e.g. "I don't like it, but I leave it
up to you to decide").

Therefore an involved glibc developer can lodge a sustained
objection, and block consensus.

(2) The GNU package maintainers for glibc.

There are 8 GNU package maintainers for glibc.

The package maintainers created the consensus process to
empower the community, but they can act as a final 
review committee to move issues where there are two
reasonable but competing view points.

As Joseph points out we haven't ever used the GNU pakcage
maintainers to vote on a stuck issue, but I will arrange
it when the need arises. If you think we're at that point
with wrapper functions, just say so, but it doesn't seem
like it to me.

-- 
Cheers,
Carlos.
