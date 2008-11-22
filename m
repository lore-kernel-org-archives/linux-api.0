From: David Newall <davidn@davidnewall.com>
Subject: Re: [take 3] Use pid in inotify events.
Date: Sat, 22 Nov 2008 17:42:21 +1030
Message-ID: <4927B0D5.4020907@davidnewall.com>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com> <20081120230612.GB6536@ioremap.net> <200811211939.46812.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756792AbYKVHMh@vger.kernel.org>
In-Reply-To: <200811211939.46812.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Friday 21 November 2008, Evgeniy Polyakov wrote:
> I have a network server, which gets IO requests from different clients
> and maintains coherency of the data between them, but if file is
> modified locally I want to flush or invalidate remote data. I decided
> not to dig into the kernel on the server node and use inotify to get
> notifications about events, but there is no way to determine if given IO
> was originated by server itself (and in this case nothing should be
> done), or by external application which accesses exported directory (and
> in this case I should send update messages to clients).

Why not require local access to use the same mechanism as remote, i.e.
by "network mounting" the data on the local machine, too.  That way
there's no confusion over where the change originated nor who's copy
must be invalidated.
