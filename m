From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Date: Mon, 26 Jan 2015 21:32:40 +0000
Message-ID: <20150126213240.63d07005@lxorguk.ukuu.org.uk>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
	<20150119180642.GA27957@sig21.net>
	<20150119183806.GA8479@kroah.com>
	<20150119201906.GA337@sig21.net>
	<20150119203155.GA15441@kroah.com>
	<20150119233812.GA1874@sig21.net>
	<20150120011359.GE865@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150120011359.GE865-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 20 Jan 2015 09:13:59 +0800
> That's because people have not done anything really needing performance
> on the desktop over D-Bus in the past due to how slow the current
> implementation is. 

The desktop is a performance critical environment, even though certain
desktop developers think 2GB is a bit small to run an application and
5000 dbus transactions to start something is "ok"

Alan
