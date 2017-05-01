From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Mon, 1 May 2017 06:15:06 +0100
Message-ID: <20170501051506.GY29622@ZenIV.linux.org.uk>
References: <20170429220414.GT29622@ZenIV.linux.org.uk>
 <CALCETrXhOhG0tRDDOROwT9ghvQvKziM2PBN=CX5Soa2m7=0cFw@mail.gmail.com>
 <20170429232504.GU29622@ZenIV.linux.org.uk>
 <20170430043822.GE27790@bombadil.infradead.org>
 <20170430161040.GW29622@ZenIV.linux.org.uk>
 <CALCETrX0dx3d6OQQ+1GJ_xgSz3iNVeRn+8o6b-+3f7awVOWdQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrX0dx3d6OQQ+1GJ_xgSz3iNVeRn+8o6b-+3f7awVOWdQg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Apr 30, 2017 at 09:52:37PM -0700, Andy Lutomirski wrote:
> On Sun, Apr 30, 2017 at 9:10 AM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> > On Sat, Apr 29, 2017 at 09:38:22PM -0700, Matthew Wilcox wrote:
> >
> >> It sounds more like AT_NO_ESCAPE ... or AT_BELOW, or something.
> >
> > I considered AT_ROACH_MOTEL at one point...  Another interesting
> > question is whether EXDEV would've been better than ELOOP.
> > Opinions?
> 
> In support of my homeland, I propose AT_HOTEL_CALIFORNIA.
> 
> How about EXDEV for crossing a mountpoint and ELOOP for absolute
> symlinks or invalid ..?  (Is there a technical reason why the same AT_
> flag should trigger both cases?)

You do realize that mount --bind can do everything absolute symlinks could,
right?  And absolute symlinks most likely do lead to (or at least through)
a different fs...
