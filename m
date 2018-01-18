From: Christoph Hellwig <hch@lst.de>
Subject: Re: aio poll, io_pgetevents and a new in-kernel poll API V3
Date: Thu, 18 Jan 2018 19:53:16 +0100
Message-ID: <20180118185316.GA28425@lst.de>
References: <20180117192742.710-1-hch@lst.de> <x49bmhruq3k.fsf@segfault.boston.devel.redhat.com> <x497esfunfw.fsf@segfault.boston.devel.redhat.com> <1516298147.3100407.1240074768.16816EBE@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516298147.3100407.1240074768.16816EBE@webmail.messagingengine.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin Walters <walters@verbum.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 18, 2018 at 12:55:47PM -0500, Colin Walters wrote:
> 
> FWIW: https://git.gnome.org/browse/glib/commit/?id=3904c8761a60dbadbdfaf98fe23ff19cbdcc4a9a
> 
> Since that a lot of userspace (including NetworkManager) uses eventfd. I haven't
> tried this patchset myself but I'd look at what the GLib mainloop is doing.

eventfd really isn't the interesting piece, the interesting piece
is epoll, especially if used in level triggered mode.
