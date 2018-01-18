From: Colin Walters <walters@verbum.org>
Subject: Re: aio poll, io_pgetevents and a new in-kernel poll API V3
Date: Thu, 18 Jan 2018 12:55:47 -0500
Message-ID: <1516298147.3100407.1240074768.16816EBE@webmail.messagingengine.com>
References: <20180117192742.710-1-hch@lst.de>
 <x49bmhruq3k.fsf@segfault.boston.devel.redhat.com>
 <x497esfunfw.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x497esfunfw.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On Thu, Jan 18, 2018, at 11:44 AM, Jeff Moyer wrote:
> Jeff Moyer <jmoyer@redhat.com> writes:
> 
> > FYI, this kernel has issues.  It will boot up, but I don't have
> > networking, and even rebooting doesn't succeed.  I'm looking into it.
> 
> A bisect lands on: eventfd: switch to ->poll_mask.  That's not super
> helpful, though.  I did run the ltp eventfd2 tests, and they all pass.

FWIW: https://git.gnome.org/browse/glib/commit/?id=3904c8761a60dbadbdfaf98fe23ff19cbdcc4a9a

Since that a lot of userspace (including NetworkManager) uses eventfd. I haven't
tried this patchset myself but I'd look at what the GLib mainloop is doing.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
