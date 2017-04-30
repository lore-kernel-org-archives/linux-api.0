From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Sun, 30 Apr 2017 17:10:40 +0100
Message-ID: <20170430161040.GW29622@ZenIV.linux.org.uk>
References: <20170429220414.GT29622@ZenIV.linux.org.uk>
 <CALCETrXhOhG0tRDDOROwT9ghvQvKziM2PBN=CX5Soa2m7=0cFw@mail.gmail.com>
 <20170429232504.GU29622@ZenIV.linux.org.uk>
 <20170430043822.GE27790@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170430043822.GE27790-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Apr 29, 2017 at 09:38:22PM -0700, Matthew Wilcox wrote:

> It sounds more like AT_NO_ESCAPE ... or AT_BELOW, or something.

I considered AT_ROACH_MOTEL at one point...  Another interesting
question is whether EXDEV would've been better than ELOOP.
Opinions?
