From: Pratyush Anand <panand@redhat.com>
Subject: Re: [RFC] watchdog: Add watchdog device control through sysfs
 attributes
Date: Mon, 31 Aug 2015 08:41:41 +0530
Message-ID: <20150831031141.GC4660@dhcppc13>
References: <d9ac417a3bc1c6846f1ddfcd3cd07e5a92865c19.1440179209.git.panand@redhat.com>
 <20150829165124.GA22494@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150829165124.GA22494@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, dyoung@redhat.com, dzickus@redhat.com, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Wim Van Sebroeck <wim@iguana.be>
List-Id: linux-api@vger.kernel.org

On 29/08/2015:09:51:24 AM, Guenter Roeck wrote:
> > * timeout - reads current timeout and writes to program a new timeout.

Now, this is the only file which has write permission. I hope, that is fine. Pl
let me know if you expected this to be as RO as well.

~Pratyush
