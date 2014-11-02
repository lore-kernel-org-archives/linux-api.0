From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: kdbus: add documentation
Date: Sat, 1 Nov 2014 18:29:23 -0700
Message-ID: <20141102012923.GA9717@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-2-git-send-email-gregkh@linuxfoundation.org>
 <alpine.DEB.2.02.1410301231040.32212@pmeerw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1410301231040.32212-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 01:20:23PM +0100, Peter Meerwald wrote:
> 
> > kdbus is a system for low-latency, low-overhead, easy to use
> > interprocess communication (IPC).
> > 
> > The interface to all functions in this driver is implemented through ioctls
> > on /dev nodes.  This patch adds detailed documentation about the kernel
> > level API design.
> 
> just some typos below

<snip>

Many thanks for the fixes, I've made them all to the file now, it will
show up in the next version we send out.

greg k-h
