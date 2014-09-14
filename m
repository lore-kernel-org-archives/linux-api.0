From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] Change userspace MKDEV, MAJOR, MINOR-macros from 8+8
 bit, to 12+20 bit layout
Date: Sun, 14 Sep 2014 10:46:22 -0700
Message-ID: <20140914174622.GA10315@kroah.com>
References: <5415D1E0.3020905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5415D1E0.3020905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <fruktopus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Sep 14, 2014 at 07:35:28PM +0200, Stephan M=FCller wrote:
> Delete old userspace-only versions (8+8 bit). Instead expose the kern=
el-space
> definitions (12+20 bit).
>=20
> Signed-off-by: Stephan Mueller <fruktopus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>=20
> Browsing some code I found that user-space and kernel-space macros fo=
r (un-)packing major/minor device numbers differ. The user-space ones u=
sing still the old 16 bit scheme. There was no explaining comment aroun=
d and most libraries have their own macros anyway so it should not be a=
 problematic UAPI change. So IMHO we could win some coherence in abando=
n this discrepancy.
> Please correct me if I am wrong.

You are wrong, we can't change this api, things will break :(

sorry,

greg k-h
