From: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Subject: Re: [PATCH v4] Add virtio-input driver.
Date: Thu, 26 Mar 2015 12:23:16 +1030
Message-ID: <87oangh6cz.fsf@rustcorp.com.au>
References: <1427198927-1745-1-git-send-email-kraxel@redhat.com> <877fu5iwxk.fsf@rustcorp.com.au> <20150325053613.GA4572@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150325053613.GA4572-IBi9RG/b67k@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>
Cc: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org> writes:
> On Wed, Mar 25, 2015 at 01:51:43PM +1030, Rusty Russell wrote:
>> Imagine a future virtio standard which incorporates this.  And a Windows
>> or FreeBSD implementation of the device and or driver.  How ugly would
>> they be?
>
> A windows translation layer is fairly easy, people porting software from
> Windows to Linux told me numerous times that adapting isn't hard. I also
> believe that at least one of the BSD's has a compatible implementation
> these days based on the fact that I was asked to allow copying the
> headers in the past.

Thanks Vojtech, that answers my questions.

I figure we apply this and see where it leads...

Cheers,
Rusty.
