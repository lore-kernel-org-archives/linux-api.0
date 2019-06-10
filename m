From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 06/13] keys: Add a notification facility [ver #4]
Date: Mon, 10 Jun 2019 11:11:10 -0600
Message-ID: <20190610111110.72468326@lwn.net>
References: <155991702981.15579.6007568669839441045.stgit@warthog.procyon.org.uk>
        <155991709983.15579.13232123365803197237.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155991709983.15579.13232123365803197237.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 07 Jun 2019 15:18:19 +0100
David Howells <dhowells@redhat.com> wrote:

> Add a key/keyring change notification facility whereby notifications about
> changes in key and keyring content and attributes can be received.
> 
> Firstly, an event queue needs to be created:
> 
> 	fd = open("/dev/event_queue", O_RDWR);
> 	ioctl(fd, IOC_WATCH_QUEUE_SET_SIZE, page_size << n);
> 
> then a notification can be set up to report notifications via that queue:
> 
> 	struct watch_notification_filter filter = {
> 		.nr_filters = 1,
> 		.filters = {
> 			[0] = {
> 				.type = WATCH_TYPE_KEY_NOTIFY,
> 				.subtype_filter[0] = UINT_MAX,
> 			},
> 		},
> 	};
> 	ioctl(fd, IOC_WATCH_QUEUE_SET_FILTER, &filter);
> 	keyctl_watch_key(KEY_SPEC_SESSION_KEYRING, fd, 0x01);

One little nit: it seems that keyctl_watch_key is actually spelled
keyctl(KEYCTL_WATCH_KEY, ...).

jon
