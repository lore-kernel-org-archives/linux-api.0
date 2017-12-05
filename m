From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: COW pages and FL_PUNCH_HOLE
Date: Tue, 5 Dec 2017 07:34:01 -0800
Message-ID: <20171205153401.GC28760@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


I don't see a discussion of this anywhere ... and I thought linux-api was
the right place to ask.

I see holepunch as being "like ftruncate() but for the middle of the file".
So it feels weird to me that MAP_PRIVATE behaves differently; truncate
will rip out COWed pages, but holepunch won't.  Is there a good reason for
this behaviour, and is it too late to change?
