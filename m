From: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1 0/1] ioctl to disallow detaching kernel USB drivers
Date: Mon, 30 Nov 2015 10:08:48 +0100
Message-ID: <1448874528.21708.2.camel@suse.com>
References: <1448466334-21346-1-git-send-email-emilio.lopez@collabora.co.uk>
	 <5656CEA1.9010203@samsung.com> <20151126172914.GA8671@kroah.com>
	 <565817FD.3090409@samsung.com> <20151128023925.GA5177@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151128023925.GA5177-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Emilio =?ISO-8859-1?Q?L=F3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2015-11-27 at 18:39 -0800, Greg KH wrote:
> Yes, it's tough, I know, good luck.
> 
> Also deal with multiple devices, busses that are ordered differently
> depending on the phase of the moon, and other fun things with dynamic
> devices and ioctls.  It's a loosing battle :)

IMHO the fundamental problem is using one device node per device.
And I think it should be tackled. Yet I have no idea how to do
this in a compatible manner.

	Regards
		Oliver
