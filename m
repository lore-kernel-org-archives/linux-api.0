From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [1/2,v2] fdmap(2)
Date: Fri, 20 Oct 2017 09:48:29 +0200
Message-ID: <20171020074829.GA9010@kroah.com>
References: <20170924200620.GA24368@avx2>
 <20171010220804.GA30735@outlook.office365.com>
 <20171011181234.GB2119@avx2>
 <20171012080608.GA23077@outlook.office365.com>
 <CACVxJT_ZP=VAJQ_=D1JV0yt3bT_RZjtWTW61KcV5gCbhF8ixBw@mail.gmail.com>
 <CALCETrW769=r4uXH2RqoQ0cQL2CakfupwAUM2_81Fr8Mo3JX=Q@mail.gmail.com>
 <CACVxJT_AKQmd0ziP7jWQvfA5MQGJgC2q2VA3xyFjVARrQR-ekg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVxJT_AKQmd0ziP7jWQvfA5MQGJgC2q2VA3xyFjVARrQR-ekg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Andrei Vagin <avagin@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Djalal Harouni <tixxdz@gmail.com>, Alexey Gladkov <gladkov.alexey@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 19, 2017 at 05:34:35PM +0200, Alexey Dobriyan wrote:
> So the answer it not to fix /proc, the answer it to leave /proc alone.

No, because:

> The answer is make Unix shell people move their lazy asses and
> implement minimal type system and a way to execute raw system calls
> like all normal programming languages do. They still haven't done it
> after dozens of years and are arrogant enough to say "oh uh we can't
> use cat and pipe to awk".

Have you submitted changes and patches to those projects in order to
implement such a thing?

If not, just complaining about it isn't going to change anything, you
know better than that :)

sorry,

greg k-h
