From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [take2] Inotify: nested attributes support.
Date: Tue, 25 Nov 2008 16:24:34 -0800
Message-ID: <20081125162434.4feacbbf.akpm@linux-foundation.org>
References: <20081125194234.GA24449@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081125194234.GA24449-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Cc: john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pavel-AlSwsSmVLrQ@public.gmane.org, davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 25 Nov 2008 22:42:35 +0300
Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org> wrote:

> Hi.
> 
> Attached patch (also attached test application) implementes
> scalable nested attributes which are transferred on behalf the inotify
> mechanism. It uses inotify_init1() to show that new event format should
> be returned when reading from inotify file descriptor.
> 
> Attributes are attached to given inotify instance via TIOCSETD ioctl,
> where ID of the attribute is transferred. If entry with given ID exists,
> it is removed and -EEXIST is returned.
> 
> There is a set of callbacks indexed by ID (currently 4 attributes are
> supported: pid, tid, io details (start/size of the written block) and
> name), which are attached to given inotify device.
> When new event is created, each callback is executed and may queue some
> data into event structure, based on its internal details. When event is
> read from the userspace, first its header is transferred (old
> inotify_event structure) and then all attributes data in the order of
> its registration via above ioctl. Nested attributes have following
> structure: 
> 
> struct inotify_attribute
> {
> 	unsigned int		id;
> 	unsigned int		size;
> 	unsigned char		data[0];
> };
> 
> where size is nuber of attached bytes for given attribute.
> inotify_event.len contains number of bytes used to store all attached
> attributes and data.
> 
> Attribute callback can check if mask contains its bits and do some steps
> based on that information, for example io details attribute does not add
> own data (and header) if event mask does not contain IN_MODIFY bit.
> 
> It is possible to infinitely extend number of attributes processed, so
> we will be no longer limited by inotify API and ABI.
> 
> Test application usage:
> $ gcc ./iotest.c -W -Wall -I/path/to/kernel/include/ -o iotest
> $ ./iotest -f /tmp/ -t -n -p -i
> 2008-11-25 22:29:47.8477 pid: 1850, tid: 1850, name: /tmp/, wd: 1, mask: 303, attributes: pid: 1, tid: 1, io: 1, name: 1.
> event: 2, wd: 1, cookie: 0, len: 61.
> 	tid: 1672.
> 	pid: 1672.
> 	io details: start: 0, size: 0.
> 	name: test.
> event: 2, wd: 1, cookie: 0, len: 61.
> 	tid: 1672.
> 	pid: 1672.
> 	io details: start: 0, size: 6.
> 	name: test.
> 
> Example with only tid and io details:
> $ $ ./iotest -f /tmp/ -t -i
> 2008-11-25 22:40:30.201286 pid: 1928, tid: 1928, name: /tmp/, wd: 1,
> mask: 303, attributes: pid: 0, tid: 1, io: 1, name: 0.
> event: 2, wd: 1, cookie: 0, len: 36.
> 	tid: 1672.
> 	io details: start: 0, size: 0.
> 
> 
> while in parallel I did:
> $ echo qwe11 > /tmp/test
> 
> Two events were sent because of two calls for fsnotify_modify(), invoked
> lkely from attribute change and write. Events are not combined since
> because attributes may be different. Not having a name always combines
> (read: skips next event) events because of old logic.
> 

I guess I'm being more than usually thick, but I don't understand what
this is all about, why it was implemented, what value it provides to
users, etc, etc?  Why do I want scalable nested attributes in inotify??

I'm buried in patches which I don't understand lately, and having
hundreds of people send patches at one guy who doesn't understand them
isn't a good system.  Eric Paris is working on inotify-type things as
well.  It would be neat if you guys were to understand and review each
other's work.  Please.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
