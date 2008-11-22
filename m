From: David Newall <davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Sat, 22 Nov 2008 22:11:47 +1030
Message-ID: <4927EFFB.3050707@davidnewall.com>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com> <20081120230612.GB6536@ioremap.net> <200811211939.46812.arnd@arndb.de> <4927B0D5.4020907@davidnewall.com> <20081122094144.GB12543@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081122094144.GB12543-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Evgeniy Polyakov wrote:
> On Sat, Nov 22, 2008 at 05:42:21PM +1030, David Newall (davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org) wrote:
>   
>> Why not require local access to use the same mechanism as remote, i.e.
>> by "network mounting" the data on the local machine, too.  That way
>> there's no confusion over where the change originated nor who's copy
>> must be invalidated.
>>     
>
> There is always a possibility that some application will access given
> data directly and not via mounted partition

Yes, there will always be ways for motivated users to trip themselves
up.  But that doesn't matter.  You can protect the user, somewhat, using
file permissions on the (outermost) directory containing your files.  If
users break through that and corrupt their data, let them, and let them
learn a lesson.  Don't try to make a foolproof system because: a) it's
likely to be a lot of work for little to no benefit, if indeed it's even
possible; and b) "make a system that even a fool can use and only a fool
will want to," as the aphorism goes.


> plus I have to patch server's kernel with out of the tree modules

Yes, that's the client in a client/server architecture.  Your server is
also a client so it's unremarkable that it would need the client software.

Don't make more work for yourself than necessary.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
