From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [1/2,v2] fdmap(2)
Date: Wed, 25 Oct 2017 15:11:29 +0200
Message-ID: <CACVxJT9kjkDp2LgcE2EgQP8X1k34A9AeUT826-=DmEtocGyGUA@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <20171010220804.GA30735@outlook.office365.com>
 <20171011181234.GB2119@avx2> <20171012080608.GA23077@outlook.office365.com>
 <CACVxJT_ZP=VAJQ_=D1JV0yt3bT_RZjtWTW61KcV5gCbhF8ixBw@mail.gmail.com>
 <CALCETrW769=r4uXH2RqoQ0cQL2CakfupwAUM2_81Fr8Mo3JX=Q@mail.gmail.com>
 <CACVxJT_AKQmd0ziP7jWQvfA5MQGJgC2q2VA3xyFjVARrQR-ekg@mail.gmail.com> <20171020074829.GA9010@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020074829.GA9010-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/20/17, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> On Thu, Oct 19, 2017 at 05:34:35PM +0200, Alexey Dobriyan wrote:
>> So the answer it not to fix /proc, the answer it to leave /proc alone.
>
> No, because:
>
>> The answer is make Unix shell people move their lazy asses and
>> implement minimal type system and a way to execute raw system calls
>> like all normal programming languages do. They still haven't done it
>> after dozens of years and are arrogant enough to say "oh uh we can't
>> use cat and pipe to awk".
>
> Have you submitted changes and patches to those projects in order to
> implement such a thing?

This is open source equivalent of "sod off".

> If not, just complaining about it isn't going to change anything, you
> know better than that :)

Greg, I'm not "just complaining", fdmap() was implemented and
sent for discussion.

Unix shell people seem to me to be anti-intellectual if after all
these years they didn't realize that their core ideas of "universal"
interface and serialization/deserialization at every opportunity
are wrong and stupid. It is best to avoid such people and not
interact with them. However what they can do is to not become
anchors asking for the world to revolve around them.

I'm not proposing to delete /proc, I'm proposing (kind of)
to leave it as is.

P.S.: even Perl 5 has "syscall" function!
