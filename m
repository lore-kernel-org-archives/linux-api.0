From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/6] Adjust watch_queue documentation to mention mount and superblock watches. [ver #5]
Date: Mon, 01 Jul 2019 09:52:50 +0100
Message-ID: <8212.1561971170@warthog.procyon.org.uk>
References: <7a288c2c-11a1-87df-9550-b247d6ce3010@infradead.org> <156173701358.15650.8735203424342507015.stgit@warthog.procyon.org.uk> <156173703546.15650.14319137940607993268.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7a288c2c-11a1-87df-9550-b247d6ce3010@infradead.org>
Content-ID: <8211.1561971170.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> wrote:

> I'm having a little trouble parsing that sentence.
> Could you clarify it or maybe rewrite/modify it?
> Thanks.

How about:

  * ``info_filter`` and ``info_mask`` act as a filter on the info field of the
    notification record.  The notification is only written into the buffer if::

	(watch.info & info_mask) == info_filter

    This could be used, for example, to ignore events that are not exactly on
    the watched point in a mount tree by specifying NOTIFY_MOUNT_IN_SUBTREE
    must not be set, e.g.::

	{
		.type = WATCH_TYPE_MOUNT_NOTIFY,
		.info_filter = 0,
		.info_mask = NOTIFY_MOUNT_IN_SUBTREE,
		.subtype_filter = ...,
	}

    as an event would be only permissible with this filter if::

    	(watch.info & NOTIFY_MOUNT_IN_SUBTREE) == 0

David
