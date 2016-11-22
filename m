From: Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] fs: add AT_REPLACE flag for linkat() which replaces
 the target
Date: Tue, 22 Nov 2016 14:05:50 -0500
Message-ID: <1479841550.1179792.796154969.6592FA1B@webmail.messagingengine.com>
References: <cover.1479802448.git.osandov@fb.com>
 <6b3b7387538efd1a582fc34da2a15ae37cf59429.1479802448.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6b3b7387538efd1a582fc34da2a15ae37cf59429.1479802448.git.osandov-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 22, 2016, at 03:25 AM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
> 
> One of the most common uses of temporary files is the classic atomic
> replacement pattern, i.e.,
> 
> - write temporary file
> - fsync temporary file
> - rename temporary file over real file
> - fsync parent directory
> 
> Now, we have O_TMPFILE, which gives us a much better way to create
> temporary files, but it's not possible to use it for this pattern.

FWIW, I have some userspace code that indeed wants exactly this:

https://github.com/GNOME/libglnx/blob/36396b49ad6636c9959f3dfac5e04d41584b1a92/glnx-fdio.c#L232

So if we add this, I'd presumably change the code to try it and
fall back on EINVAL as usual?
