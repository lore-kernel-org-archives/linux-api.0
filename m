From: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
Subject: Re: [PATCH] selftests/kdbus: handle cap_get_proc() error properly
Date: Wed, 17 Jun 2015 19:46:49 +0300
Message-ID: <20150617164649.GY4549@localhost.localdomain>
References: <1434550697-24785-1-git-send-email-sergei@s15v.net>
 <20150617143720.GA19114@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150617143720.GA19114-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Greg,

On Wed, Jun 17, 2015 at 07:37:20AM -0700, Greg Kroah-Hartman wrote:
> You sent 5 patches, yet no hints as to what order they should be applied
> in :(
> 
> Please resend in a patch series that is properly threaded so we can
> handle this correctly.

Thank you for feedback! I've resent series threaded:
http://lkml.kernel.org/g/1434558808-16129-1-git-send-email-sergei-E844GTqJAzo@public.gmane.org

It was unclear for me whether to use threaded layout and whether not,
but now it seems that I got it. Though those applied fine in any order
and had no chances to piss of a kernel maintainer :)
