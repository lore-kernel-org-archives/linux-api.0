From: Andy Lutomirski <luto@kernel.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Sun, 30 Apr 2017 21:52:37 -0700
Message-ID: <CALCETrX0dx3d6OQQ+1GJ_xgSz3iNVeRn+8o6b-+3f7awVOWdQg@mail.gmail.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk> <CALCETrXhOhG0tRDDOROwT9ghvQvKziM2PBN=CX5Soa2m7=0cFw@mail.gmail.com>
 <20170429232504.GU29622@ZenIV.linux.org.uk> <20170430043822.GE27790@bombadil.infradead.org>
 <20170430161040.GW29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170430161040.GW29622@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>, Andy Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Apr 30, 2017 at 9:10 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Apr 29, 2017 at 09:38:22PM -0700, Matthew Wilcox wrote:
>
>> It sounds more like AT_NO_ESCAPE ... or AT_BELOW, or something.
>
> I considered AT_ROACH_MOTEL at one point...  Another interesting
> question is whether EXDEV would've been better than ELOOP.
> Opinions?

In support of my homeland, I propose AT_HOTEL_CALIFORNIA.

How about EXDEV for crossing a mountpoint and ELOOP for absolute
symlinks or invalid ..?  (Is there a technical reason why the same AT_
flag should trigger both cases?)

--Andy
