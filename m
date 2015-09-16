From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 6/7] [RFC] [media]: v4l2: introduce v4l2_timeval
Date: Wed, 16 Sep 2015 10:40:26 +0200
Message-ID: <3059739.5oJNmvzYWC@wuerfel>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de> <7758607.pJFdek7ljg@wuerfel> <55F92450.8010802@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F92450.8010802-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wednesday 16 September 2015 10:12:00 Hans Verkuil wrote:
> 
> Are you also attending the ELCE in Dublin? We could have a quick talk there.
> I think the discussion whether to switch to a new v4l2_buffer struct isn't really
> dependent on anything y2038.

No, unfortunately I won't be there.

Concerning a v4l2_buffer, I agree we should treat that as a completely independent
topic. The problem at hand for y2038 is only about we expect to happen when someone
compiles source code that uses the existing v4l2_buffer (and v4l2_event) with a
y2038-aware libc.

	Arnd
